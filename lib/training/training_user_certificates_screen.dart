import 'package:flutter/material.dart';
import 'package:opencentric_lms/training/controller/your_account_controller.dart';
import 'package:get/get.dart';
import '../feature/forum/pdf_viewer_screen.dart';

class UserCertificatesScreen extends StatefulWidget {
  const UserCertificatesScreen({super.key});

  @override
  State<UserCertificatesScreen> createState() => _UserCertificatesScreenState();
}

class _UserCertificatesScreenState extends State<UserCertificatesScreen> {
  @override
  void initState() {

    Get.find<YourAccountController>().getCertificates();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Your certificates'),
      ),
      body: GetBuilder<YourAccountController>(
          builder: (controller) {
            return ListView.builder(
              itemCount: controller.certificates.length,
              itemBuilder: (context, index) {
                return PDFViewerScreen(
                  pdfUrl: controller.certificates[index] ?? '',
                  fileName: 'Certificate', );
              }
            );

          })
      ,
    ));
  }
}
