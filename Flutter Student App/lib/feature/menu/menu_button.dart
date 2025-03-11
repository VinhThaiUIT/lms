import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/confirmation_dialog.dart';
import 'package:opencentric_lms/components/ripple_button.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/controller/cart_controller.dart';
import 'package:opencentric_lms/controller/theme_controller.dart';
import 'package:opencentric_lms/core/helper/responsive_helper.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/data/model/menu_model.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/language_change.dart';
import 'package:opencentric_lms/utils/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MenuButton extends StatelessWidget {
  final MenuModel? menu;
  final bool? isLogout;
  const MenuButton({super.key, @required this.menu, @required this.isLogout});

  @override
  Widget build(BuildContext context) {
    int count = ResponsiveHelper.isTab(context) ? 6 : 4;
    double size = ((context.width) / count) - Dimensions.paddingSizeDefault;

    return Stack(
      children: [
        Column(children: [
          Container(
            height: size - (size * 0.35),
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            alignment: Alignment.center,
            child: SvgPicture.asset(menu!.icon!, width: size, height: size),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(menu!.title!,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
              textAlign: TextAlign.center),
        ]),
        Positioned.fill(
          child: RippleButton(
            onTap: () async {
              if (isLogout!) {
                Get.back();
                if (Get.find<AuthController>().isLoggedIn()) {
                  Get.dialog(
                      ConfirmationDialog(
                          icon: Images.logout,
                          description: 'are_you_sure_to_logout'.tr,
                          isLogOut: true,
                          onYesPressed: () {
                            Get.find<AuthController>().logout();

                            Get.find<AuthController>().clearSharedData();
                            Get.find<CartController>().clearCartList();
                            Get.offAllNamed(
                                RouteHelper.getSignInRoute(RouteHelper.splash));
                          }),
                      useSafeArea: false);
                } else {
                  Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
                }
              } else if (menu!.route!.startsWith('http')) {
                if (await canLaunchUrlString(menu!.route!)) {
                  launchUrlString(menu!.route!,
                      mode: LaunchMode.externalApplication);
                }
              } else if (menu!.route!.contains('forum')) {
                Get.back();
                Get.toNamed(RouteHelper.forum);
              } else if (menu!.route!.contains('group')) {
                Get.back();
                Get.toNamed(RouteHelper.group);
              } else if (menu!.route!.contains('language')) {
                Get.back();
                Get.bottomSheet(const LanguageChange(),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true);
              } else if (menu!.route!.contains('dark_mode')) {
                Get.back();
                Get.find<ThemeController>().toggleTheme();
              } else {
                Get.offNamed(menu!.route!);
              }
            },
          ),
        )
      ],
    );
  }
}
