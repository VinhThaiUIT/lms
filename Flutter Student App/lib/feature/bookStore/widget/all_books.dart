import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:opencentric_lms/components/course_view_verticle.dart';
import 'package:opencentric_lms/components/paginated_list_view.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';

class AllBooksWidget extends StatelessWidget {
  const AllBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child: Text(
            'all_books'.tr,
            style:
                robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
        ),
        PaginatedListView(
          scrollController: scrollController,
          totalSize: 10,
          offset: 1,
          onPaginate: (int offset) {},
          itemView: const ServiceViewVertical(
            service: [],
          ),
        ),
      ],
    );
  }
}
