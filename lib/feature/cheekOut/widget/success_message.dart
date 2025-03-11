import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

class SuccessMessage extends StatelessWidget {
  const SuccessMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // <-- SEE HERE
      alignment: Alignment.center,
      children: <Widget>[
        const SizedBox(
          height: Dimensions.paddingSizeLarge,
        ),
        Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Theme.of(context).primaryColor,
              child: SvgPicture.asset(Images.successful),
            )),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Text(
                "Successful",
                style: robotoSemiBold.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: Dimensions.fontSizeDefault),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.customAppBarSize),
              child: Text(
                "Congratulations, you have completed your Purchase!",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.5),
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: CustomButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.learningScreen);
                },
                buttonText: 'go_to_playlist'.tr,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
