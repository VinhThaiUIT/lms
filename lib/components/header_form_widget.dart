import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/user_controller.dart';

class HeaderFormWidget extends StatefulWidget {
  final Color avatarBg;
  const HeaderFormWidget( {super.key, required this.avatarBg,});

  @override
  State<HeaderFormWidget> createState() => _HeaderFormWidgetState();
}

class _HeaderFormWidgetState extends State<HeaderFormWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (controller) {
      return mainUI(controller);
    });
  }

  Row mainUI(UserController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.network(
            'https://lms.dev.everlms.com/themes/custom/lms_theme/logo.svg'),
        Padding(
          padding: const EdgeInsets.all(10), // Border radius
          child: ClipOval(
            child: controller.selectedImageUri != null
              ? Image.file(
                controller.selectedImageUri!,
                fit: BoxFit.cover,
                height: 75,
                width: 75,
                )
              : CircleAvatar(
                radius: 30,
                backgroundColor: widget.avatarBg,
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 35,
                ),
              ),
          ),
        ),
      ],
    );
  }
}
