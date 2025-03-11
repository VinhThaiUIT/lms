import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/course_view_verticle.dart';
import 'package:opencentric_lms/controller/search_controller.dart'
    as lms_search;
import 'package:opencentric_lms/feature/root/view/no_data_screen.dart';
import 'package:opencentric_lms/feature/searchScreen/widget/search_suggestion.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';

class ItemView extends GetView<SearchController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<lms_search.SearchController>(builder: (searchController) {
      if (searchController.isSearchComplete) {
        return Center(
            child: SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (searchController.searchResultCourseList != null &&
                        searchController.searchResultCourseList!.isNotEmpty)
                      Container(
                        color: Theme.of(context).hoverColor,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeDefault),
                            child: Text(
                              "${searchController.searchResultCourseList!.length} ${'courses_found'.tr}",
                              style: robotoRegular.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (searchController.searchResultCourseList != null &&
                        searchController.searchResultCourseList!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Text(
                          'services'.tr,
                          style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                      ),
                    ServiceViewVertical(
                      service: searchController.searchResultCourseList!,
                      noDataType: NoDataType.search,
                    ),
                  ],
                )));
      } else {
        return searchController.historyList!.isNotEmpty
            ? const SearchSuggestion()
            : const SizedBox();
      }
    });
  }
}
