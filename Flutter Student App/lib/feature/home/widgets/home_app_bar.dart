import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/cart_controller.dart';
import 'package:opencentric_lms/controller/user_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/training/training_your_account_screen.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../../components/custom_button.dart';
import '../../../components/loading_indicator.dart';
import '../../../controller/auth_controller.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? backButton;
  final Function()? callBack;
  const HomeAppBar({super.key, this.backButton = true, this.callBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: backButton! ? Dimensions.paddingSizeLarge : 0,
      leading: backButton!
          ? Padding(
              padding:
                  const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.pop(context),
              ),
            )
          : const SizedBox(),
      title: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //user profile
              GetBuilder<UserController>(builder: (controller) {
                return Expanded(
                  child: controller.userData == null
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            // Get.toNamed(RouteHelper.profile);
                            Get.to(() => const YourAccountScreen());
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Row(
                            children: [
                              // ClipRRect(
                              //   borderRadius: const BorderRadius.all(
                              //       Radius.circular(
                              //           Dimensions.radiusExtraLarge)),
                              //   child: CustomImage(
                              //       height: 40,
                              //       width: 40,
                              //       image:
                              //           controller.userModel?.data?.image ??
                              //               ''),
                              // ),
                              const SizedBox(
                                width: Dimensions.paddingSizeSmall,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.userData?.name ?? '',
                                    style: robotoBold.copyWith(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.w600,
                                        fontSize: Dimensions.fontSizeDefault),
                                  ),
                                  Text(
                                    controller.userData?.email ?? '',
                                    style: robotoRegular.copyWith(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                );
              }),

              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                children: [
                  if (Get.find<AuthController>().isLoggedIn())
                    GetBuilder<CartController>(builder: (controller) {
                      return InkWell(
                        hoverColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => Get.toNamed(RouteHelper.getCartScreen()),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeRadius),
                          child: controller.cartList.isNotEmpty
                              ? badges.Badge(
                                  badgeContent: Text(
                                      "${controller.cartList.length}",
                                      style: TextStyle(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Colors.white)),
                                  badgeStyle: const badges.BadgeStyle(
                                      badgeColor: Colors.black),
                                  child: SvgPicture.asset(Images.cartSvg),
                                )
                              : const SizedBox(),
                        ),
                      );
                    }),
                  InkWell(
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Get.toNamed(RouteHelper.discussion);
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeRadius),
                      child: SvgPicture.asset(
                        Images.chat,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Get.toNamed(RouteHelper.notificationScreen);
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeRadius),
                      child: SvgPicture.asset(
                        Images.notification,
                      ),
                    ),
                  ),
                  // InkWell(
                  //   hoverColor: Colors.transparent,
                  //   borderRadius: BorderRadius.circular(30),
                  //   onTap: () => Get.toNamed(RouteHelper.searchScreen),
                  //   child: Padding(
                  //     padding:
                  //         const EdgeInsets.all(Dimensions.paddingSizeRadius),
                  //     child: SvgPicture.asset(
                  //       Images.search,
                  //     ),
                  //   ),
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'online_mode'.tr,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      InkWell(
                        onTap: () {
                          callBack!();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          color: Colors.white,
                          child: Text(
                            'tap_to_offline'.tr,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
