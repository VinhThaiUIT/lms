import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/title_view.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/data/model/book_detail/instructor.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

class Author extends StatelessWidget {
  final String title;
  final BookInstructor instructor;
  const Author({super.key, required this.title, required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleView(title: title.tr, isViewAllEnabled: false),
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        SizedBox(
          height: 100,
          child: authorItem(context),
        ),
      ],
    );
  }

  Widget authorItem(BuildContext context) {
    return Container(
      height: 96,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
            width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        radius: 5,
        onTap: () => Get.toNamed(RouteHelper.getInstructorDetails(),
            arguments: instructor.id),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Stack(
            children: [
              Positioned(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: instructor.image ?? '',
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    placeholder: (context, url) =>
                        Image.asset(Images.placeholder),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                left: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instructor.name ?? '',
                      style: robotoMedium.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: Dimensions.fontSizeSemiSmall),
                    ),
                    Text(instructor.designation ?? '',
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.fontSizeExtraSmall)),
                    Text("Join: ${instructor.joined}",
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: Dimensions.fontSizeSmall)),
                    Text(
                        "Published ${instructor.publishedBook} ${'books'.tr.toLowerCase()}.",
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontSize: Dimensions.fontSizeSmall)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
