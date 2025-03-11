import 'dart:io';

import 'package:get/get.dart';
import 'package:opencentric_lms/config.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

String formatTimeAgo(Duration diff) {
  int days = diff.inDays;
  int hours = diff.inHours % 24;
  int minutes = diff.inMinutes % 60;
  int seconds = diff.inSeconds % 60;

  String timeAgo = '';
  if (days > 0) {
    timeAgo += '$days day${days > 1 ? 's' : ''} ';
  }
  if (hours > 0) {
    timeAgo += '$hours hour${hours > 1 ? 's' : ''} ';
  }
  if (minutes > 0) {
    timeAgo += '$minutes minute${minutes > 1 ? 's' : ''} ';
  }
  if (seconds > 0 && timeAgo.isEmpty) {
    // Only show seconds if no other time unit is shown
    timeAgo += '$seconds second${seconds > 1 ? 's' : ''} ';
  }

  return '${timeAgo.trim()} ago';
}

Future<File> downloadPDF(String url, String fileName) async {
  try {
    // Get the directory to save the file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    // Download the file
    final response = await http.get(Uri.parse(url));

    // Check if the download was successful
    if (response.statusCode == 200) {
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download file');
    }
  } catch (e) {
    throw Exception('Error downloading file: $e');
  }
}
