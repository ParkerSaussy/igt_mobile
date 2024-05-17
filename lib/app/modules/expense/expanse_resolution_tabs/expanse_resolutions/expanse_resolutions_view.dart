import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../../master/general_utils/app_dimens.dart';
import '../../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../routes/app_pages.dart';
import '../../../common_widgets/expense_resolution_item.dart';
import 'expanse_resolutions_controller.dart';

class ExpanseResolutionsView extends GetView<ExpanseResolutionsController> {
  const ExpanseResolutionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimens.paddingLarge.ph,
        Expanded(
          child: Obx(
            () => controller.isResolutionsFound.value
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.expenseResolutionList.length,
                    restorationId: controller.restorationId.value,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ExpenseResolutionItem(
                        model: controller.expenseResolutionList[index],
                        tripDetailsModel: controller.tripDetailsModel!,
                        onPayPressed: () {
                          Get.toNamed(Routes.EXPANSE_PAY, arguments: [
                            controller.tripDetailsModel?.id,
                            controller.expenseResolutionList[index]
                          ])?.then(
                              (value) => controller.getExpenseResolutions());
                        },
                      );
                    },
                  )
                : controller.isDataLoading.value
                    ? const SizedBox()
                    : const NoRecordFound(),
          ),
        ),
        AppDimens.paddingMedium.ph,
        MasterButtonsBounceEffect.gradiantButton(
          btnText: LabelKeys.addExpense.tr,
          onPressed: () async {
            await Get.toNamed(Routes.ADD_EXPANSES,
                arguments: [controller.tripDetailsModel?.id]);
            controller.getExpenseResolutions();
          },
        ),
        AppDimens.paddingMedium.ph
      ],
    );
  }
}
