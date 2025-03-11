import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/controller/certificate_controller.dart';
import 'package:opencentric_lms/data/model/common/course.dart';
import 'package:opencentric_lms/feature/common/in_development.dart';
import 'package:opencentric_lms/feature/profile/widgets/certificate_dialog.dart';
import 'package:opencentric_lms/feature/root/view/no_data_screen.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'certificates'.tr,
        bgColor: Theme.of(context).cardColor,
        titleColor: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      body: GetBuilder<CertificateController>(
        initState: (state) async {
          await Get.find<CertificateController>()
              .getCourseBasedOnCertificate(1, true);
        },
        builder: (certificateController) {
          return const InDevelopment();
          List<Course>? courseList = certificateController.courseList;
          if (courseList == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return courseList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15),
                      itemCount: courseList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return InkWell(
                          onTap: () {
                            Get.dialog(CertificateDialog(
                              course: courseList.elementAt(index),
                            ));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Dimensions.radiusSmall),
                                ),
                                child: Image.asset(
                                  Images.demoCertificate,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : NoDataScreen(
                    text: 'no_certificate_found'.tr,
                    type: NoDataType.certificate,
                  );
          }
        },
      ),
    );
  }
}
