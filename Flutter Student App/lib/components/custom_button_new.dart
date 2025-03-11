import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class CustomButtonNew extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;
  final Color? color;
  final List<Widget>? widgets;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;

  const CustomButtonNew({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.color,
    this.widgets,
    this.height,
    this.width,
    this.fontSize,
    this.radius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
            horizontal: Dimensions.paddingSizeDefault),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              buttonText!,
              style: Theme.of(context).textTheme.titleSmall
            ),
            IconButton.filledTonal(
              onPressed: onPressed,
              
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                
              ),
              style:  IconButton.styleFrom(
                backgroundColor: const Color(0xFFCEE3E5)
              ),
            ),
          ],
        ),
      ),
    );
  }


}
