import 'package:opencentric_lms/data/model/common/course.dart';

import 'calculations.dart';
import 'cart.dart';

class CartListData {
  List<Cart>? carts;
  List<Course>? listCourse;
  Calculations? calculations;

  CartListData({this.carts, this.calculations, this.listCourse});

  factory CartListData.fromJson(Map<String, dynamic> json) => CartListData(
        carts: (json['order_items'] as List<dynamic>?)
            ?.map((e) => Cart.fromJsonDrupal(e as Map<String, Object?>))
            .toList(),
        calculations: (json['total_price'] != null &&
                (json['total_price'] as List).isNotEmpty)
            ? Calculations.fromJsonDrupal(json['total_price'][0])
            : null,
        listCourse: json['field_products'] != null
            ? List<Course>.from((json['field_products'] as Map<String, dynamic>)
                .values
                .map((e) {
                return Course.fromJsonCourseDetail(e);
              }))
            : null,
      );

  Map<String, Object?> toJson() => {
        'carts': carts?.map((e) => e.toJson()).toList(),
        'calculations': calculations?.toJson(),
      };
}
