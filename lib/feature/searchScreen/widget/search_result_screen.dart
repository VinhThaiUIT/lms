import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/course_shimmer.dart';
import 'package:opencentric_lms/controller/search_controller.dart'
    as lms_search;
import 'package:opencentric_lms/core/helper/responsive_helper.dart';
import 'package:opencentric_lms/feature/searchScreen/widget/search_app_bar.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'item_view.dart';

class SearchResultScreen extends StatefulWidget {
  final String? queryText;

  const SearchResultScreen({super.key, required this.queryText});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  void initState() {
    Get.find<lms_search.SearchController>().removeService();
    if (widget.queryText!.isNotEmpty) {
      Get.find<lms_search.SearchController>()
          .searchData(widget.queryText!, shouldUpdate: false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(backButton: true),
      body: GetBuilder<lms_search.SearchController>(
        builder: (searchController) {
          return SingleChildScrollView(
            child: Container(
                child: searchController.searchResultCourseList == null
                    ? Center(
                        child: SizedBox(
                          width: Get.width,
                          child: GridView.builder(
                            key: UniqueKey(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: Dimensions.paddingSizeDefault,
                              mainAxisSpacing: Dimensions.paddingSizeDefault,
                              childAspectRatio:
                                  ResponsiveHelper.isTab(context) ? 1 : .70,
                              crossAxisCount: ResponsiveHelper.isMobile(context)
                                  ? 2
                                  : ResponsiveHelper.isTab(context)
                                      ? 3
                                      : 5,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 15,
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeDefault),
                            itemBuilder: (context, index) {
                              return const CourseShimmer(
                                  isEnabled: true, hasDivider: true);
                            },
                          ),
                        ),
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            ItemView(),
                          ])),
          );
        },
      ),
    );
  }
}
