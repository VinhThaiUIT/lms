import 'package:flutter/material.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/my_course_offline_controller.dart';
import 'package:opencentric_lms/data/model/common/my_course_offline.dart';
import 'package:opencentric_lms/feature/common/my_course_offline_widget_item.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import '../../../utils/styles.dart';

class DownloadedCourseList extends StatefulWidget {
  const DownloadedCourseList({super.key});

  @override
  State<DownloadedCourseList> createState() => _DownloadedCourseListState();
}

class _DownloadedCourseListState extends State<DownloadedCourseList> {
  final ScrollController _scrollController = ScrollController();
  final MyCourseOfflineController _controller = MyCourseOfflineController();

  @override
  void initState() {
    super.initState();

    _controller.getMyCourseList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

  Widget mainUI(MyCourseOfflineController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.getMyCourseList(),
      child: CustomScrollView(
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
      ),
    );
  }
}
