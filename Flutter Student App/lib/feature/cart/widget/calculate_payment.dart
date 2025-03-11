import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../../data/model/cart_list/calculations.dart';

class CalculatePayment extends StatelessWidget {
  final Calculations? calculation;
  const CalculatePayment({super.key, required this.calculation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Container(
          // height: 96,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.06)),
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimensions.radiusSmall))),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total'.tr,
                      style: robotoSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyLarge!.color!),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                          .format(double.tryParse(
                                  calculation?.totalPayable ?? "") ??
                              0),
                      style: robotoSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodyLarge!.color!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
