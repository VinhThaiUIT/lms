import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:opencentric_lms/training/controller/your_account_controller.dart';
import 'package:opencentric_lms/training/model/progress_report_model.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

import '../data/model/common/course.dart';

class ProgressReportScreen extends StatefulWidget {
  const ProgressReportScreen({super.key});

  @override
  State<ProgressReportScreen> createState() => _ProgressReportScreen();
}

class _ProgressReportScreen extends State<ProgressReportScreen> {
  Course? course;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorLight,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColorLight,
            iconTheme: Theme.of(context).iconTheme.copyWith(
              size: 30, 
              ),
            // leading: const Icon(Icons.arrow_back_ios_new_outlined),
            title: Text(
              'Your progress report',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          body: GetBuilder<YourAccountController>(
              builder: (controller) {
                if(controller.listCourseReport == null || (controller.listCourseReport.isEmpty ?? true)) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                  child: ListView.builder(
                      itemCount: controller.listCourseReport!.length,
                      itemBuilder: (context, index) {
                        return courseDetailWidget(controller.listCourseReport![index]!);
                      }
                  ),
                );
              }
          ),
        )
    );
  }

  Widget courseDetailWidget(ProgressReportModel myCourse) {
    // format epoch time
    final created = DateTime.fromMillisecondsSinceEpoch(int.parse(myCourse.created!) * 1000);
    final createdFormat = DateFormat.yMMMMd().format(created).toString();
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(myCourse.name!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),),
            customTextStyle('Category: ${myCourse.category}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent[100],
                    backgroundColor: Colors.black,
                    value: double.parse(myCourse.courseProgress!) / 100,
                  ),
                ),
                customTextStyle('${double.parse(myCourse.courseProgress!).toStringAsPrecision(2)}%'),
                customTextStyle('Total quiz pass: ${myCourse.totalQuizPass}'),
                customTextStyle('Result: ${myCourse.result}'),

              ],
            ),
            myCourse.certificatesTitle != null
                ? customTextStyle('Certificate: ${myCourse.certificatesTitle}')
                : customTextStyle('Certificate: none'),

            customTextStyle('Created: $createdFormat'),
          ],
        ),
      ),
    );
  }

  Widget customTextStyle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Roboto'
      ),
    );
  }
}
