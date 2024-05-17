import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/common_widgets/placeholder_container_with_icon.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/generic_class/common_network_image.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottomsheet_with_close.dart';
import 'add_expanses_controller.dart';

class AddExpansesView extends GetView<AddExpansesController> {
  const AddExpansesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          isCustomTitle: true,
          customTitleWidget: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: AppDimens.paddingMedium,
                  bottom: AppDimens.paddingMedium,
                  right: AppDimens.paddingMedium),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(IconPath.backArrow),
                  const SizedBox(
                    width: AppDimens.paddingMedium,
                  ),
                  Text(
                    LabelKeys.back.tr,
                    style: onBackgroundTextStyleRegular(),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Obx(
          () => ContainerTopRoundedCorner(
            child: ScrollViewRoundedCorner(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: AppDimens.paddingExtraLarge,
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge),
                child: Form(
                  autovalidateMode: controller.activationMode.value,
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LabelKeys.addExpense.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textExtraLarge),
                      ),
                      AppDimens.paddingMedium.ph,
                      RichText(
                        text: TextSpan(
                            style: onBackGroundTextStyleMedium(
                                fontSize: AppDimens.textLarge),
                            children: <TextSpan>[
                              TextSpan(text: LabelKeys.expense.tr),
                            ]),
                      ),
                      CustomTextField(
                          controller: controller.addExpenseController,
                          inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            border: const UnderlineInputBorder(),
                            isDense: true,
                            hintText: LabelKeys.expense.tr,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: AppDimens.paddingSmall),
                            hintStyle: onBackgroundTextStyleRegular(
                                alpha: Constants.lightAlfa),
                          ),
                          keyBoardType: TextInputType.text,
                          validator: (v) {
                            return CustomTextField.validatorFunction(
                                v!,
                                ValidationTypes.other,
                                LabelKeys.cBlankAddExpense.tr);
                          }),
                      AppDimens.paddingExtraLarge.ph,
                      //Add Description Edit field
                      PlaceholderContainerWithIcon(
                          widget: CustomTextField(
                              maxLines: 5,
                              maxLength: 250,
                              controller: controller.addDescController,
                              onChanged: (v) {
                                controller.descCount.value =
                                    (250 - (v.toString().length)).toString();
                              },
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: LabelKeys.addDetails.tr,
                                      isDense: true,
                                      prefixRightPadding: 0,
                                      counterText: "",
                                      counterStyle:
                                          onBackgroundTextStyleRegular(
                                              alpha:
                                                  Constants.transparentAlpha),
                                      alignLabelWithHint: true,
                                      hintStyle: onBackgroundTextStyleRegular(
                                          fontSize: AppDimens.textLarge,
                                          alpha: Constants.transparentAlpha)),
                              keyBoardType: TextInputType.multiline,
                              validator: (v) {
                                return CustomTextField.validatorFunction(
                                    v!,
                                    ValidationTypes.other,
                                    LabelKeys.cBlankAddExpenseDescription.tr);
                              }),
                          titleName: LabelKeys.addDescription.tr),
                      AppDimens.paddingSmall.ph,
                      // Character Counter
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${controller.descCount.value} ${Constants.characterCountLabel}",
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.transparentAlpha),
                        ),
                      ),
                      AppDimens.paddingExtraLarge.ph,
                      // Date
                      GestureDetector(
                        onTap: () async {
                          Get.focusScope?.unfocus();
                          final DateTime? pickedDate = await datePicker();
                          if (pickedDate != null) {
                            final String strPickedDate =
                                DateFormat("MMM dd, yyyy").format(pickedDate);
                            controller.onDate.value = strPickedDate;
                          }
                        },
                        child: PlaceholderContainerWithIcon(
                          widget: Text(controller.onDate.value,
                              style: onBackgroundTextStyleRegular(
                                  fontSize: AppDimens.textLarge,
                                  alpha: Constants.veryLightAlfa),
                              overflow: TextOverflow.ellipsis),
                          titleName: LabelKeys.date.tr,
                          iconPath: IconPath.icCalendar,
                        ),
                      ),
                      AppDimens.paddingLarge.ph,
                      // Amount Text Field
                      PlaceholderContainerWithIcon(
                        widget: CustomTextField(
                            controller: controller.amountController,
                            style: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textLarge,
                                alpha: Constants.veryLightAlfa),
                            maxLength: 8,
                            onChanged: (a) {
                              controller.split.value =
                                  LabelKeys.cBlankAddExpenseSelectMembers.tr;
                              controller.shareList.clear();
                            },
                            inputDecoration:
                                CustomTextField.prefixSuffixOnlyIcon(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    prefixText: "\$ ",
                                    labelStyle: onBackgroundTextStyleRegular(
                                        alpha: Constants.transparentAlpha)),
                            keyBoardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^\d*\.?\d{0,2})')),
                            ],
                            validator: (v) {
                              if (v!.isEmpty) {
                                return LabelKeys.cBlankAddExpenseAmount.tr;
                              } else if (double.parse(v) <= 0) {
                                return LabelKeys.validAddExpenseAmount.tr;
                              }
                              return null;
                            }),
                        titleName: LabelKeys.amount.tr,
                        iconPath: IconPath.dollarIcon,
                      ),
                      AppDimens.paddingExtraLarge.ph,
                      // Label Paid By
                      Text(
                        LabelKeys.paidBy.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textExtraLarge),
                      ),
                      AppDimens.paddingMedium.ph,
                      // Paid By Widget
                      GestureDetector(
                        onTap: () async {
                          Get.focusScope?.unfocus();
                          var data = await Get.bottomSheet(
                            isScrollControlled: true,
                            BottomSheetWithClose(
                              widget: paidByGuestBottomSheet(),
                            ),
                          );
                          controller.paidBy.value = data['selectedGuestName'];
                          controller.guestId.value = data['selectedGuestId'];
                        },
                        child: PlaceholderContainerWithIcon(
                          widget: Padding(
                            padding: const EdgeInsets.only(
                                top: AppDimens.paddingTiny),
                            child: Text(
                                '${gc.loginData.value.firstName} ${gc.loginData.value.lastName}' ==
                                        controller.paidBy.value
                                    ? LabelKeys.you.tr
                                    : controller.paidBy.value,
                                style: onBackGroundTextStyleMedium(
                                    fontSize: AppDimens.textLarge),
                                textAlign: TextAlign.center),
                          ),
                          endWidget: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(IconPath.forwardArrow),
                            ),
                          ),
                        ),
                      ),

                      AppDimens.paddingExtraLarge.ph,
                      // Title Spilt
                      Text(
                        LabelKeys.split.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textExtraLarge),
                      ),
                      AppDimens.paddingMedium.ph,
                      // Split Widget
                      GestureDetector(
                        onTap: () async {
                          Get.focusScope?.unfocus();
                          if (controller.amountController.value.text.isEmpty) {
                            RequestManager.getSnackToast(
                                message: LabelKeys.cBlankAddExpenseAmount.tr);
                          } else if (controller.guestId.value == 0) {
                            RequestManager.getSnackToast(
                                message:
                                    LabelKeys.cBlankAddExpenseSelectPaidBy.tr,
                                colorText: Colors.white,
                                backgroundColor: Colors.red);
                          } else {
                            var data = await Get.toNamed(
                                Routes.EXPANSE_GUEST_LIST_TABS,
                                arguments: [
                                  controller.tripID.value,
                                  controller.amountController.text,
                                  controller.guestId.value
                                ]);
                            controller.shareList = data['shareList'];
                            controller.split.value = data['selectedTab'];
                          }
                        },
                        child: PlaceholderContainerWithIcon(
                          widget: Padding(
                            padding: const EdgeInsets.only(
                                top: AppDimens.paddingTiny),
                            child: Text(
                              controller.split.value,
                              style: onBackGroundTextStyleMedium(
                                  fontSize: AppDimens.textLarge),
                            ),
                          ),
                          endWidget: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(IconPath.forwardArrow),
                            ),
                          ),
                        ),
                      ),
                      AppDimens.paddingExtraLarge.ph,
                      //Save Button
                      MasterButtonsBounceEffect.gradiantButton(
                        btnText: LabelKeys.save.tr,
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            Get.focusScope?.unfocus();
                            hideKeyboard();
                            if (controller.guestId.value == 0) {
                              RequestManager.getSnackToast(
                                  message:
                                      LabelKeys.cBlankAddExpenseSelectPaidBy.tr,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red);
                            } else if (controller.shareList.isEmpty) {
                              RequestManager.getSnackToast(
                                  message: LabelKeys
                                      .cBlankAddExpenseSelectMembers.tr,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.red);
                            } else {
                              controller.addExpense();
                            }
                          }
                          controller.activationMode.value =
                              AutovalidateMode.onUserInteraction;
                        },
                      ),
                      AppDimens.paddingExtraLarge.ph,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paidByGuestBottomSheet() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimens.paddingMedium.ph,
          Obx(
            () => Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.tripGuestList.value.length,
                restorationId: controller.restorationId.value,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  return itemPaidByGuest(index);
                },
              ),
            ),
          ),
          AppDimens.paddingMedium.ph,
          Padding(
            padding: const EdgeInsets.only(
                left: AppDimens.paddingLarge,
                right: AppDimens.paddingLarge,
                bottom: AppDimens.paddingLarge),
            child: MasterButtonsBounceEffect.gradiantButton(
              btnText: LabelKeys.submit.tr,
              onPressed: () {
                AddedGuestmodel selectedGuest = controller.getSelectedGuest();
                Get.back(result: {
                  'selectedGuestName':
                      '${selectedGuest.firstName} ${selectedGuest.lastName}',
                  'selectedGuestId': selectedGuest.id
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget itemPaidByGuest(int index) {
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        onTap: () {
          Get.focusScope?.unfocus();
          for (int i = 0; i < controller.tripGuestList.length; i++) {
            controller.tripGuestList[i].isSelected = false;
          }
          controller.tripGuestList[index].isSelected = true;
          controller.restorationId.value = getRandomString();
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimens.paddingSmall),
          height: AppDimens.circleNavBarHeight,
          decoration: BoxDecoration(
              border: Border.all(
                width: AppDimens.paddingNano,
                color: Get.theme.colorScheme.background
                    .withAlpha(Constants.veryLightAlfa),
              ),
              color: controller.tripGuestList[index].isSelected
                  ? Get.theme.colorScheme.primary
                      .withAlpha(Constants.inputFieldCount)
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.paddingMedium))),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingTiny),
                        child:
                            /*controller.tripGuestList[index].profilePicture! != ""
                              ?*/
                            CommonNetworkImage(
                          imageUrl:
                              controller.tripGuestList[index].profilePicture,
                          height: AppDimens.largeIconSize,
                          width: AppDimens.largeIconSize,
                          radius: AppDimens.paddingMedium,
                        )
                        /*: Image.asset(ImagesPath.user5),*/
                        ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: controller.tripGuestList[index].isSelected
                          ? SvgPicture.asset(IconPath.selExpenseIcon)
                          : const SizedBox(),
                    )
                  ],
                ),
                AppDimens.paddingMedium.pw,
                Text(
                  '${controller.tripGuestList[index].firstName!} ${controller.tripGuestList[index].lastName!}',
                  style: onBackGroundTextStyleMedium(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
