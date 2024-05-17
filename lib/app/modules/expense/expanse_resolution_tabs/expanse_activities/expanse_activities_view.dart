import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../../master/general_utils/app_dimens.dart';
import '../../../../../master/general_utils/constants.dart';
import '../../../../../master/general_utils/images_path.dart';
import '../../../../../master/general_utils/text_styles.dart';
import '../../../../../master/generic_class/custom_textfield.dart';
import '../../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../routes/app_pages.dart';
import '../../../common_widgets/expense_activity_item.dart';
import '../../../common_widgets/placeholder_container_with_icon.dart';
import 'expanse_activities_controller.dart';

class ExpanseActivitiesView extends GetView<ExpanseActivitiesController> {
  const ExpanseActivitiesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: controller.activationMode.value,
      key: controller.expenseFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimens.paddingMedium.ph,
          Obx(() => controller.isHost.value
              ? PlaceholderContainerWithIcon(
                  widget: CustomTextField(
                    controller: controller.unequalController,
                    maxLength: 8,
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        prefixText: '\$',
                        prefixRightPadding: 0,
                        hintText: "200.00",
                        hintStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    keyBoardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,2})')),
                    ],
                    validator: (v) {
                      if (v!.isEmpty) {
                        return LabelKeys.cBlankDepositAmount.tr;
                      } else if (double.parse(v) <= 0) {
                        return LabelKeys.validDepositAmount.tr;
                      }
                      return null;
                    },
                  ),
                  titleName: LabelKeys.depositAmount.tr,
                  iconPath: IconPath.dollarIcon,
                  endWidget: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: AppDimens.paddingVerySmall,
                        horizontal: AppDimens.paddingSmall),
                    child: MasterButtonsBounceEffect.gradiantButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.paddingVerySmall,
                          horizontal: AppDimens.paddingExtraLarge),
                      height: 45.0,
                      btnText: LabelKeys.ask.tr,
                      onPressed: () {
                        if (controller.expenseFormKey.currentState!
                            .validate()) {
                          hideKeyboard();
                          Get.focusScope?.unfocus();
                          controller.amount.value =
                              double.parse(controller.unequalController.text);
                          controller.callGuestListApi();
                        } else {
                          controller.activationMode.value =
                              AutovalidateMode.onUserInteraction;
                        }
                      },
                    ),
                  ),
                )
              : const SizedBox()),
          AppDimens.paddingLarge.ph,
          Text(
            LabelKeys.activities.tr,
            style: onBackGroundTextStyleMedium(),
          ),
          AppDimens.paddingMedium.ph,
          Expanded(
            child: Obx(
              () => controller.isActivitiesFound.value
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: controller.expenseActivitiesList.length,
                      restorationId: controller.restorationId.value,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ExpenseActivityItem(
                          model: controller.expenseActivitiesList[index],
                          tripDetailsModel: controller.tripDetailsModel!,
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
              controller.getExpenseActivities();
            },
          ),
          AppDimens.paddingMedium.ph
        ],
      ),
    );
  }
}
