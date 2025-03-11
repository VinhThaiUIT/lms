import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/localization_controller.dart';
import 'package:opencentric_lms/core/helper/help_me.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

class LanguageChange extends StatefulWidget {
  const LanguageChange({super.key});

  @override
  State<LanguageChange> createState() => _LanguageChangeState();
}

class _LanguageChangeState extends State<LanguageChange> {
  bool? value = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radiusExtraLarge),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'language'.tr,
                    style: robotoSemiBold.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.fontSizeDefault),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          Dimensions.paddingSizeExtraSmall),
                      child: SvgPicture.asset(
                        Images.cancel,
                        height: Dimensions.paddingSizeSmall,
                        width: Dimensions.paddingSizeSmall,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.6),
                            BlendMode.srcIn),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: AppConstants.languages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                        ),
                        child: Divider(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.06),
                          thickness: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          localizationController.setLanguage(Locale(
                              AppConstants.languages[index].languageCode!,
                              AppConstants.languages[index].countryCode));
                          localizationController.setSelectIndex(index,
                              shouldUpdate: true);
                        },
                        child: Row(
                          children: [
                            Radio(
                              value:
                                  localizationController.selectedIndex == index
                                      ? true
                                      : false,
                              groupValue: true,
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                              onChanged: (value) {
                                localizationController.setLanguage(Locale(
                                    AppConstants.languages[index].languageCode!,
                                    AppConstants.languages[index].countryCode));
                                localizationController.setSelectIndex(index,
                                    shouldUpdate: true);
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
                      ),
                    ],
                  );
                }) //Co
          ],
        ),
      );
    });
  }
}
