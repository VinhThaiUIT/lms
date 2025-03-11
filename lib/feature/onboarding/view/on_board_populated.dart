import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/components/pager_dots.dart';
import 'package:opencentric_lms/controller/on_board_pager_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/feature/onboarding/view/pager_content.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';

class OnBoardPopulated extends GetView<OnBoardController> {
  const OnBoardPopulated({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardController>(initState: (state) {
      Get.find<OnBoardController>().getOnBoardList();
    }, builder: (onBoardController) {
      return Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (value) {
                  controller.onPageChanged(value);
                },
                itemCount: onBoardController.onBoardDataList.length,
                itemBuilder: (context, index) => PagerContent(
                  image: onBoardController.onBoardDataList[index].image!,
                ),
              ),
            ),
            SizedBox(
              height: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onBoardController.onBoardDataList.length,
                        (index) => GetBuilder<OnBoardController>(
                          builder: (onBoardController) {
                            return PagerDot(
                                index: index,
                                currentIndex: onBoardController.pageIndex);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 95,
            ),
            SizedBox(
              height: 90,
              child: PageView.builder(
                onPageChanged: (value) {
                  controller.onPageChanged(value);
                },
                itemCount: onBoardController.onBoardDataList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          onBoardController
                              .onBoardDataList[onBoardController.pageIndex]
                              .title!,
                          textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                              fontSize: Dimensions.fontSizeLarge),
                        ),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeExtraSmall,
                      ),
                      Expanded(
                        child: Text(
                          onBoardController
                              .onBoardDataList[onBoardController.pageIndex]
                              .description!,
                          textAlign: TextAlign.center,
                          style: robotoMedium.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                              fontSize: Dimensions.fontSizeLarge),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (onBoardController.pageIndex != 2)
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(RouteHelper.main);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Text(
                      "skip".tr,
                      style: robotoRegular.copyWith(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            if (onBoardController.pageIndex == 2)
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Get.offNamed(
                        RouteHelper.getMainRoute(RouteHelper.onBoardingScreen));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Text(
                      "continue_as_a_guest".tr,
                      style: robotoRegular.copyWith(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 30,
            ),
            if (onBoardController.pageIndex == 0)
              CustomButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.main);
                  },
                  buttonText: 'get_started'.tr),
            if (onBoardController.pageIndex == 1)
              CustomButton(
                  onPressed: () {
                    Get.toNamed(RouteHelper.main);
                  },
                  buttonText: 'next'.tr),
            if (onBoardController.pageIndex == 2)
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      Get.offNamed(RouteHelper.getSignInRoute('onboard'));
                    },
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall)),
                      child: Text('sign_in'.tr,
                          style: robotoMedium.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: Dimensions.fontSizeSmall)),
                    ),
                  )),
                  const SizedBox(
                    width: Dimensions.paddingSizeDefault,
                  ),
                  Expanded(
                    child: CustomButton(
                        onPressed: () {
                          Get.offNamed(RouteHelper.getPhoneSignUpScreen());
                        },
                        buttonText: 'sign_up'.tr),
                  ),
                ],
              )
          ],
        ),
      );
    });
  }
}
