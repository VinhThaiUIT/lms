import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/my_course_offline_controller.dart';
import 'package:opencentric_lms/data/model/common/my_course_offline.dart';
import 'package:opencentric_lms/feature/common/my_course_offline_widget_item.dart';
import 'package:opencentric_lms/network_service.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../core/helper/route_helper.dart';

class MyCourseOfflineScreen extends StatefulWidget {
  const MyCourseOfflineScreen({super.key});

  @override
  State<MyCourseOfflineScreen> createState() => _MyCourseOfflineScreenState();
}

class _MyCourseOfflineScreenState extends State<MyCourseOfflineScreen> {
  final ScrollController _scrollController = ScrollController();
  final MyCourseOfflineController _controller = MyCourseOfflineController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      _controller.getMyCourseList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          title: const Text(
            'Your downloaded courses',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'offline_mode'.tr,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
                InkWell(
                  onTap: () async {
                    final isConnected =
                        await NetworkService().checkInternetConnection();
                    if (context.mounted) {
                      !isConnected
                          ? ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'You are no connected to the internet',
                                textAlign: TextAlign.center,
                              ),
                            ))
                          : Get.offAllNamed(
                              RouteHelper.getMainRoute(RouteHelper.splash));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    color: Colors.white,
                    child: Text(
                      'tap_to_online'.tr,
                      style: const TextStyle(fontSize: 10, color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
              width: 10,
            )
          ],
        ),
        //body: Center(child: Text("Test"))
        body: StreamBuilder<bool>(
            stream: NetworkService().networkStatusStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!Get.currentRoute.contains(RouteHelper.main)) {
                    Get.offAllNamed(
                        RouteHelper.getMainRoute(RouteHelper.splash));
                  }
                });
                return const Center(
                  child: Text('You are connected to the internet'),
                );
              } else {
                return StreamBuilder<bool>(
                    stream: _controller.loadingStream,
                    initialData: true,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return const LoadingIndicator();
                      }
                      return StreamBuilder<List<MyCourseOffline>>(
                          stream: _controller.downloadStream,
                          initialData: _controller.myCourseOfflineList,
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall),
                              child: _controller.isMyCourseLoading
                                  ? const LoadingIndicator()
                                  : _controller.myCourseOfflineList.isEmpty
                                      ? Center(
                                          child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              Images.emptyCourse,
                                              scale: 3,
                                            ),
                                            const Text(
                                                "You don't have any downloaded course.",
                                                style: robotoRegular),
                                          ],
                                        ))
                                      : mainUI(_controller),
                            );
                          });
                    });
              }
            }));
  }

  Widget mainUI(MyCourseOfflineController controller) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return MyCourseOfflineWidgetItem(
              course: controller.myCourseOfflineList[index],
              controller: controller,
            );
          }, childCount: controller.myCourseOfflineList.length),
        ),
      ],
    );
  }
}
