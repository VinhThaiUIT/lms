import 'package:flutter/material.dart';
import 'on_board_populated.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: OnBoardPopulated(),
    );
  }
}
