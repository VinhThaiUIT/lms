import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:universal_html/html.dart';
import '../../utils/dimensions.dart';
import '../../utils/helper.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String fileName;

  const PDFViewerScreen(
      {super.key, required this.pdfUrl, required this.fileName});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with your logic
    } else {
      // Handle the case when permission is not granted
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pdfUrl.isEmpty) {
      return Container();
    }
    return FutureBuilder<File>(
      future: downloadPDF(widget.pdfUrl, widget.fileName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 550,
                child: PDFView(
                  filePath: snapshot.data!.path,
                ),
              ),

              CustomButton(
                  buttonText: "download".tr,
                  margin: const EdgeInsets.symmetric(horizontal: 100),

                  onPressed: () {
                    downloadAndSaveFile(widget.pdfUrl, widget.fileName);
                  }),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<void> downloadAndSaveFile(String url, String fileName) async {
    try {
      if (!kIsWeb) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          openAppSettings();
          return;
        }
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        if (Platform.isAndroid) {
          String downloadsPath = '/storage/emulated/0/Download';
          String fullPath = '$downloadsPath/$fileName.pdf';
          File file = File(fullPath);
          await file.writeAsBytes(bytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File saved as: $fullPath')),
          );
        } else if (Platform.isIOS) {
          String? selectedDirectory =
              await FilePicker.platform.getDirectoryPath();
          if (selectedDirectory != null) {
            String fullPath = '$selectedDirectory/$fileName.pdf';
            File file = File(fullPath);
            await file.writeAsBytes(bytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File saved as: $fullPath')),
            );
          } else {
            throw Exception('Failed to get selected directory');
          }
        }
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Load the PDF file from the download external storage
  Future<File> getPDF() async {
    Directory dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/certi.pdf');

    return file;
  }
}
