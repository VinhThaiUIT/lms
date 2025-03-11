import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/data/model/organization_detail/organization_profile.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

class OrganizerInfo extends StatelessWidget {
  final OrganizationProfileData data;
  const OrganizerInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: Dimensions.paddingSizeDefault,
        left: Dimensions.paddingSizeDefault,
        bottom: Dimensions.paddingSizeDefault,
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Get.isDarkMode
                    ? Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.6)
                    : Theme.of(context).primaryColorLight),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(Images.phone,
                      colorFilter: ColorFilter.mode(
                          Get.isDarkMode
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.6)
                              : Theme.of(context).primaryColor,
                          BlendMode.srcIn),
                      height: Dimensions.paddingSizeSmall),
                  const SizedBox(width: 12),
                  Text(data.phone ?? "",
                      style: robotoRegular.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.6),
                          fontSize: Dimensions.fontSizeExtraSmall))
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                children: [
                  SvgPicture.asset(Images.mail,
                      colorFilter: ColorFilter.mode(
                          Get.isDarkMode
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.6)
                              : Theme.of(context).primaryColor,
                          BlendMode.srcIn),
                      height: Dimensions.paddingSizeSmall),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text(data.email ?? "",
                      style: robotoRegular.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.6),
                          fontSize: Dimensions.fontSizeExtraSmall))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
