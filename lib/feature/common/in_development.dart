import 'package:flutter/material.dart';
import 'package:opencentric_lms/utils/styles.dart';

class InDevelopment extends StatelessWidget {
  const InDevelopment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Feature under development. Please check back later.",
          style: robotoRegular),
    );
  }
}
