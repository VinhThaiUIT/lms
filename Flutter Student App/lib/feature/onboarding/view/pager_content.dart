import 'package:flutter/material.dart';
import 'package:opencentric_lms/components/custom_image.dart';

class PagerContent extends StatelessWidget {
  const PagerContent({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        CustomImage(
          image: image,
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
