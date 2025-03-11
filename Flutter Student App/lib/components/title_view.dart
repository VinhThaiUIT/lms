import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';

class TitleView extends StatelessWidget {
  final String title;
  final bool? isViewAllEnabled;
  final Function()? onViewAllClicked;
  const TitleView(
      {super.key,
      required this.title,
      this.isViewAllEnabled = true,
      this.onViewAllClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
          if (isViewAllEnabled == true)
            GestureDetector(
              onTap: () =>
                  onViewAllClicked != null ? onViewAllClicked!() : null,
              child: Text(
                'view_all'.tr,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Get.isDarkMode
                        ? Theme.of(context).textTheme.bodyMedium!.color
                        : Theme.of(context).primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
