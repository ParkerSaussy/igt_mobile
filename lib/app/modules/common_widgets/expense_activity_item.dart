import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/constants.dart';
import '../../../master/general_utils/date.dart';
import '../../../master/general_utils/text_styles.dart';
import '../../models/expense_activities.dart';

class ExpenseActivityItem extends StatelessWidget {
  final ExpenseActivities model;
  final TripDetailsModel tripDetailsModel;

  const ExpenseActivityItem({
    Key? key,
    required this.model,
    required this.tripDetailsModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      height: AppDimens.circleNavBarHeight,
      decoration: BoxDecoration(
          border: Border.all(
            width: AppDimens.paddingNano,
            color: Get.theme.colorScheme.background
                .withAlpha(Constants.veryLightAlfa),
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimens.paddingMedium.pw,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${getDateString(model.expenseOn!)} - ${model.name}',
                      style: onBackGroundTextStyleMedium(),
                    ),
                    Text(
                        model.uId == gc.loginData.value.id
                            ? "${LabelKeys.youPaid.tr} \$${model.totalAmount?.toStringAsFixed(2)}"
                            : '${model.creditor} ${LabelKeys.paid.tr} \$${model.totalAmount?.toStringAsFixed(2)}',
                        style: onBackgroundTextStyleRegular(
                            fontSize: AppDimens.textMedium,
                            alpha: Constants.veryLightAlfa),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimens.paddingMedium.pw,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        model.uId == gc.loginData.value.id
                            ? model.remainAmount! > 0
                                ? LabelKeys.youLent.tr
                                : LabelKeys.youReceived.tr
                            : model.remainAmount! > 0
                                ? LabelKeys.youBorrowed.tr
                                : LabelKeys.youPaid.tr,
                        style: model.uId == gc.loginData.value.id
                            ? model.remainAmount! > 0
                                ? primaryTextStyleRegular(
                                    fontSize: AppDimens.textSmall)
                                : primaryTextStyleRegular(
                                    fontSize: AppDimens.textSmall)
                            : model.remainAmount! > 0
                                ? secondaryTextStyleRegular(
                                    fontSize: AppDimens.textSmall)
                                : secondaryTextStyleRegular(
                                    fontSize: AppDimens.textSmall)),
                    Text(
                        model.uId == gc.loginData.value.id
                            ? model.remainAmount! > 0
                                ? "\$${model.remainAmount?.toStringAsFixed(2)}"
                                : "\$${model.amount?.toStringAsFixed(2)}"
                            : model.remainAmount! > 0
                                ? "\$${model.remainAmount?.toStringAsFixed(2)}"
                                : "\$${model.amount?.toStringAsFixed(2)}",
                        style: model.uId == gc.loginData.value.id
                            ? model.remainAmount! > 0
                                ? primaryTextStyleMedium()
                                : primaryTextStyleMedium()
                            : model.remainAmount! > 0
                                ? secondaryTextStyleMedium()
                                : secondaryTextStyleMedium(),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getDateString(DateTime date) {
    //DateTime date = Date.shared().dateFromString(sDate);
    return "${Date.shared().ordinalSuffixOf(int.parse(Date.shared().getOnlyDateFromDateTime(date)))} ${Date.shared().getMonthNameFromDateTime((date))}";
  }
}
