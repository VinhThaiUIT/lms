import 'package:flutter/material.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

class PagerDot extends StatelessWidget {
  const PagerDot({super.key, required this.index, required this.currentIndex});
  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: Dimensions.paddingSizeExtraSmall,
      width: currentIndex == index
          ? Dimensions.paddingSizeLarge
          : Dimensions.paddingSizeExtraSmall,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
