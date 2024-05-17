import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/expense_resolutions.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/constants.dart';
import '../../../master/general_utils/date.dart';
import '../../../master/general_utils/text_styles.dart';
import '../../../master/generic_class/master_buttons_bounce_effect.dart';

class ExpenseResolutionItem extends StatelessWidget {
  final ExpenseResolutions model;
  final TripDetailsModel tripDetailsModel;
  final Function onPayPressed;

  const ExpenseResolutionItem({
    Key? key,
    required this.model,
    required this.tripDetailsModel,
    required this.onPayPressed,
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
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.paddingMedium),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: AppDimens.paddingSmall),
                child: Text(
                    model.amount! < 0
                        ? "${LabelKeys.youOwe.tr} ${model.opponent} \$${((model.amount!) * (-1)).toStringAsFixed(2)}"
                        : "${model.opponent} ${LabelKeys.owesYou.tr} \$${model.amount!.toStringAsFixed(2)}",
                    style: generalTextStyleMedium(
                        fontSize: AppDimens.textLarge,
                        color: model.amount! < 0
                            ? Get.theme.colorScheme.secondary
                            : Get.theme.colorScheme.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            model.amount! < 0
                ? Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: AppDimens.paddingSmall,
                          horizontal: AppDimens.paddingSmall),
                      child: MasterButtonsBounceEffect.gradiantButton(
                        btnText: LabelKeys.pay.tr,
                        onPressed: () {
                          onPayPressed();
                        },
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  String getDateString(DateTime date) {
    return "${Date.shared().ordinalSuffixOf(int.parse(Date.shared().getOnlyDateFromDateTime(date)))} ${Date.shared().getMonthNameFromDateTime(date)}";
  }
}
