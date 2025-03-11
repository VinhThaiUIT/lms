import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/title_view.dart';
import 'package:opencentric_lms/data/model/common/book.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

import '../../common/book_widget.dart';

class RelatedBook extends StatelessWidget {
  final List<BookModel> bookList;
  const RelatedBook({super.key, required this.bookList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleView(title: 'related_book'.tr),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: bookList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0
                          ? Dimensions.paddingSizeDefault
                          : Dimensions.paddingSizeExtraSmall,
                      right: Dimensions.paddingSizeExtraSmall,
                    ),
                    child: BookWidget(book: bookList[index]),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
