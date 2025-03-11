import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/components/custom_text_field.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/training/form_custom.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';
import '../../components/loading_indicator.dart';

class SignInScreen extends StatelessWidget {
  final String fromPage;
  const SignInScreen({super.key, required this.fromPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist:
            fromPage == "fromSplash" || fromPage == "onboard" ? false : true,
        bgColor: Theme.of(context).cardColor,
        titleColor: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return Container(
            color: Theme.of(context).cardColor,
            child: Stack(
              children: [
                mainUI(context, controller),
                controller.isLoading
                    ? const LoadingIndicator()
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget mainUI(BuildContext context, AuthController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 100,
              child: SvgPicture.asset(
                Images.splash,
                // scale: 3,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'sign_in'.tr,
              style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeOverLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color!),
            ),
            const SizedBox(height: 60),
            userField(context, controller),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            passwordField(context, controller),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            CustomButton(
                onPressed: () => controller.login(), buttonText: 'sign_in'.tr),
            const SizedBox(
              height: 30,
            ),
            newUserUI(context),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          ],
        ),
      ),
    );
  }

  InkWell continueButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHelper.main);
      },
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        child: Text('or_continue_with'.tr,
            style: robotoRegular.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.5),
                fontSize: Dimensions.fontSizeSmall)),
      ),
    );
  }

  Row newUserUI(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('new_user'.tr,
            style: robotoRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                fontSize: Dimensions.fontSizeSmall)),
        InkWell(
          onTap: () {
            // Get.toNamed(RouteHelper.signUp);
            Get.to(() => const FormCustom());
          },
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Text('create_account'.tr,
                style: robotoRegular.copyWith(
                    color: Get.isDarkMode
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeSmall)),
          ),
        ),
      ],
    );
  }

  Widget userField(BuildContext context, AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.06),
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.paddingSizeExtraSmall)),
          ),
          child: CustomTextField(
            hintText: 'user_name'.tr,
            controller: controller.signInEmailController,
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeDefault,
                  top: Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeDefault,
                ),
                child: SvgPicture.asset(
                  Images.mail,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      ],
    );
  }

  Column passwordField(BuildContext context, AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.06)),
            borderRadius: const BorderRadius.all(
                Radius.circular(Dimensions.paddingSizeExtraSmall)),
          ),
          child: CustomTextField(
            hintText: 'password'.tr,
            controller: controller.signInPasswordController,
            inputType: TextInputType.visiblePassword,
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeDefault,
                  top: Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeDefault,
                ),
                child: SvgPicture.asset(
                  Images.lock,
                ),
              ),
            ),
            isPassword: true,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.forgotPasswordScreen),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Text(
              'forget_password'.tr,
              style: robotoRegular.copyWith(
                  color: Get.isDarkMode
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeSmall),
            ),
          ),
        ),
      ],
    );
  }
}
