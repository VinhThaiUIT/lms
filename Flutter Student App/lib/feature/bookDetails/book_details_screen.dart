import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/feature/bookDetails/widget/author.dart';
import 'package:opencentric_lms/feature/bookDetails/widget/book_details_header_section.dart';
import 'package:opencentric_lms/feature/bookDetails/widget/book_rating_view.dart';
import 'package:opencentric_lms/feature/bookDetails/widget/book_cart_section.dart';
import 'package:opencentric_lms/feature/bookDetails/widget/related_book.dart';
import 'package:opencentric_lms/feature/bookDetails/widget/review_view.dart';
import 'package:opencentric_lms/feature/bookDetails/widget/summary.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

import '../../controller/book_detail_controller.dart';
import '../../data/model/book_detail/data.dart';
import '../common/organization.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  //final detailController = Get.put(BookDetailController());

  @override
  void initState() {
    // detailController.getBookDetail(Get.arguments);
    super.initState();
  }

  @override
  void dispose() {
    //detailController.dispose();
    super.dispose();
  }

  bool isSelect = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'book_details'.tr,
        centerTitle: false,
        bgColor: Theme.of(context).primaryColor,
        actions: const [
          // IconButton(
          //   onPressed: () => Get.find<WishListController>()
          //       .addToWishList(Get.arguments, 'book'),
          //   icon: SvgPicture.asset(
          //     Images.heart,
          //     colorFilter: ColorFilter.mode(
          //         Theme.of(context).primaryColorLight, BlendMode.srcIn),
          //   ),
          //   splashRadius: 23,
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset(
          //     Images.share,
          //     colorFilter: ColorFilter.mode(
          //         Theme.of(context).primaryColorLight, BlendMode.srcIn),
          //   ),
          //   splashRadius: 23,
          // ),
        ],
      ),
      body: GetBuilder<BookDetailController>(
          initState: (state) =>
              Get.find<BookDetailController>().getBookDetail(Get.arguments),
          builder: (controller) {
            return controller.isLoading
                ? const LoadingIndicator()
                : controller.bookDetail != null
                    ? mainUI(controller.bookDetail!, controller)
                    : const SizedBox();
          }),
      bottomNavigationBar:
          GetBuilder<BookDetailController>(builder: (controller) {
        return controller.isLoading == false
            ? BookCartSection(
                data: controller.bookDetail!,
              )
            : const SizedBox();
      }),
    );
  }

  Widget mainUI(BookDetailData data, BookDetailController controller) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: BookDetailsHeaderSection(data: controller.bookDetail!)),
        SliverToBoxAdapter(
          child: Author(title: 'author'.tr, instructor: data.instructor!),
        ),
        const SliverToBoxAdapter(
            child: SizedBox(height: Dimensions.paddingSizeDefault)),
        SliverToBoxAdapter(child: SummaryWidget(summary: data.summary!)),
        const SliverToBoxAdapter(
            child: SizedBox(height: Dimensions.paddingSizeDefault)),
        if (data.rating != null)
          SliverToBoxAdapter(
              child: BookRatingView(
            canReview: data.canReview ?? true,
            rating: controller.bookDetail!.rating!,
            id: data.id!,
          )),
        SliverToBoxAdapter(
          child: ReviewView(id: Get.arguments),
        ),
        const SliverToBoxAdapter(
            child: SizedBox(height: Dimensions.paddingSizeDefault)),
        SliverToBoxAdapter(child: RelatedBook(bookList: data.relatedBooks!)),
        if (data.organization != null)
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        if (data.organization != null)
          SliverToBoxAdapter(
              child: OrganizationWidget(organization: data.organization!)),
        const SliverToBoxAdapter(
            child: SizedBox(height: Dimensions.paddingSizeDefault)),
      ],
    );
  }
}
