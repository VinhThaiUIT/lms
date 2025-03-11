import 'dart:convert';

import 'package:get/get.dart';
import 'package:opencentric_lms/controller/quiz_controller.dart';
import 'package:opencentric_lms/repository/quiz_repository.dart';
import 'package:opencentric_lms/training/model/progress_report_model.dart';

import '../../components/custom_snackbar.dart';
import '../../data/model/course_detail/faq.dart';
import '../repository/faq_repo.dart';
import '../repository/your_account_repo.dart';

class YourAccountController extends GetxController implements GetxService {
  YourAccountController({required this.yourAccountRepo, required this.faqRepo});
  final YourAccountRepo yourAccountRepo;
  final FaqRepo faqRepo;

  List<ProgressReportModel?> _listCourseReport = [];
  List<ProgressReportModel?> get listCourseReport =>  _listCourseReport;

  final List<String?> _certificates = [];
  List<String?> get certificates => _certificates;
  final List<Faq> _listFaq = [];
  List<Faq> get listFaq => _listFaq;
  @override
  void onInit() {
    getProgressReport();
    getFaq();
    super.onInit();
  }

  Future<void> getProgressReport() async {
    final response = await yourAccountRepo.getProgressReport();
    List<ProgressReportModel> report = [];
    if(response != null && response.statusCode == 200) {
      List data = response.body['data'];

      report = List.generate(
          data.length,
          (index) => ProgressReportModel.fromJson(data[index])
      );

      // report = List<ProgressReportModel>.from((data as Map<String, dynamic>).values.map((e) {
      //   return ProgressReportModel.fromJson(e);
      // }));
    }

    _listCourseReport.clear();
    _listCourseReport.addAll(report);
  }
  Future<void> getCertificates() async {
    final response = await yourAccountRepo.getCertificates();
    if (response != null && response.statusCode == 200) {
      final data = response.body['comment_Data'];
      _certificates.clear();
      for (int i = 0; i < data.length; i++) {
        _certificates.add(data[i]['url_certificate_pdf']);
      }
      update();
    } else {
      customSnackBar('Error load certificates');
    }
  }

  void getFaq() async {
    final response = await faqRepo.getFaq();
    List<Faq> faq = [];
    if(response != null && response.statusCode == 200) {
      final data = response.body['data'];
      faq = List<Faq>.from((data as Map<String, dynamic>).values.map((e) {
        return Faq.fromJson(e);
      }));
    }
    _listFaq.clear();
    _listFaq.addAll(faq);
  }


}