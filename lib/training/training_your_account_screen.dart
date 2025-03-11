import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:opencentric_lms/components/custom_button_new.dart';
import 'package:opencentric_lms/components/custom_button_notification.dart';
import 'package:opencentric_lms/feature/auth/change_password/change_password_screen.dart';
import 'package:opencentric_lms/feature/profile/edit_profile_screen.dart';
import 'package:opencentric_lms/feature/profile/widgets/user_logout.dart';
import 'package:opencentric_lms/components/header_form_widget.dart';
import 'package:opencentric_lms/training/controller/your_account_controller.dart';
import 'package:opencentric_lms/training/lesson_browser.dart';
import 'package:opencentric_lms/training/training_faq_screen.dart';
import 'package:opencentric_lms/training/training_user_certificates_screen.dart';
import '../utils/dimensions.dart';
import 'progress_report_screen.dart';

class YourAccountScreen extends StatefulWidget {
  const YourAccountScreen({super.key});

  @override
  State<YourAccountScreen> createState() => _YourAccountScreenState();
}

class _YourAccountScreenState extends State<YourAccountScreen> {
  bool isHide = false;
  @override
  void initState() {
    Get.find<YourAccountController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Dimensions.paddingSizeDefault,
          children: [
            const HeaderFormWidget(avatarBg:Color(0xffEEF9FC)),
            Text('Your account', style: Theme.of(context).textTheme.titleLarge,),
            Text('Progress', style: Theme.of(context).textTheme.titleSmall,),
            CustomButtonNew(buttonText:'Progress report',onPressed: () {
              Get.to(() => const ProgressReportScreen());
            }),
            CustomButtonNew(buttonText:'Download certificates',onPressed: () {
              Get.to(() => const UserCertificatesScreen());
            }),
            Text('Results', style: Theme.of(context).textTheme.titleSmall,),
            CustomButtonNew(buttonText:'Lesson browsers', onPressed: () {
              Get.to(() => const LessonBrowser());
            }),
            CustomButtonNotification(
              buttonText: 'Feedback alert',
              notifications: List.filled(5, 'feedback'),
              btnColor: const Color(0xff9CD9E8),
              expandColor: Theme.of(context).primaryColorLight,
              alert: true,),
            Text('Help', style: Theme.of(context).textTheme.titleSmall,),
            CustomButtonNew(buttonText:'FAQ', onPressed: () {
              Get.to(() => const FaqScreen());
            }),
            Text('Profile & security', style: Theme.of(context).textTheme.titleSmall,),
            CustomButtonNew(buttonText:'Change your details',onPressed: () {
              Get.to(() => const EditProfileScreen());
            }),
            CustomButtonNew(buttonText:  'Reset password', onPressed: () {
              Get.to(() => ChangePasswordScreen());
            }),
            Card(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Log out',
                        style:  Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)
                    ),
                    IconButton(
                      onPressed: () {
                        Get.bottomSheet(const UserLogout(),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true);
                      },
                      icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
