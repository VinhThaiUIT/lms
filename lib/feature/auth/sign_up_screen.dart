import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/components/custom_text_field.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../components/loading_indicator.dart';
import '../../controller/localization_controller.dart';
import '../../utils/app_constants.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        bgColor: Theme.of(context).cardColor,
        titleColor: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      body: GetBuilder<AuthController>(builder: (controller) {
        return Stack(
          children: [
            mainUI(context, controller),
            controller.isLoading ? const LoadingIndicator() : const SizedBox(),
          ],
        );
      }),
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
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'sign_up'.tr,
              style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeOverLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color!),
            ),
            const SizedBox(height: 60),
            usernameField(context, controller),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            emailAddressField(context, controller),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            passwordField(context, controller),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            confirmPasswordField(context, controller),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    "language".tr,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: AppConstants.languages.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.find<AuthController>().languageCode = index;
                          Get.find<LocalizationController>().setLanguage(Locale(
                              AppConstants.languages[index].languageCode!,
                              AppConstants.languages[index].countryCode));
                          Get.find<LocalizationController>()
                              .setSelectIndex(index, shouldUpdate: true);
                          Get.find<AuthController>().update();
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: Get.find<AuthController>().languageCode ==
                                      index
                                  ? true
                                  : false,
                              groupValue: true,
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                              onChanged: (value) {
                                Get.find<AuthController>().languageCode = index;
                                Get.find<AuthController>().update();
                                Get.find<LocalizationController>().setLanguage(
                                    Locale(
                                        AppConstants
                                            .languages[index].languageCode!,
                                        AppConstants
                                            .languages[index].countryCode));
                                Get.find<LocalizationController>()
                                    .setSelectIndex(index, shouldUpdate: true);
                              },
                            ),
                            Text(
                              AppConstants.languages[index].languageName!,
                              style: robotoRegular.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!,
                                  fontSize: Dimensions.fontSizeSmall),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            ) //Co
            ,
            CustomButton(
                onPressed: () => controller.registration(),
                buttonText: 'sign_up'.tr),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('already_have_an_account'.tr,
                    style: robotoRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color!,
                        fontSize: Dimensions.fontSizeSmall)),
                InkWell(
                  onTap: () {
                    Get.offNamed(
                        RouteHelper.getSignInRoute(RouteHelper.signUp));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Text(
                      'sign_in_here'.tr,
                      style: robotoRegular.copyWith(
                          color: Get.isDarkMode
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          ],
        ),
      ),
    );
  }

  Column emailAddressField(BuildContext context, AuthController controller) {
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
            hintText: 'email_address'.tr,
            controller: controller.emailController,
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
      ],
    );
  }

  Column confirmPasswordField(BuildContext context, AuthController controller) {
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
            hintText: 'confirm_password'.tr,
            controller: controller.confirmPasswordController,
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
            controller: controller.passwordController,
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
      ],
    );
  }

  Column usernameField(BuildContext context, AuthController controller) {
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
            controller: controller.usernameController,
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
                  Images.user,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
