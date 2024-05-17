import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/share_list.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/common_network_image.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../master/networking/request_manager.dart';
import 'expanse_guest_list_tabs_controller.dart';

class ExpanseGuestListTabsView extends GetView<ExpanseGuestListTabsController> {
  const ExpanseGuestListTabsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar.buildAppBar(
          isCustomTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          customTitleWidget: CustomAppBar.backButton(),
          actionWidget: [
            Obx(
              () => Visibility(
                visible: !controller.showCheckbox
                    .value, //TODO hid the above unselect checkbox hence controller.showCheckbox.value is set to false
                child: Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.unselected.value =
                          !controller.unselected.value;
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: AppDimens.paddingLarge),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              controller.unselected.value
                                  ? IconPath.check
                                  : IconPath.unCheck,
                              colorFilter: ColorFilter.mode(
                                  Get.theme.colorScheme.onBackground,
                                  BlendMode.srcIn)),
                          AppDimens.paddingSmall.pw,
                          Text(LabelKeys.unselectAll.tr,
                              style: onBackGroundTextStyleMedium(
                                  fontSize: AppDimens.textMedium,
                                  alpha: Constants.darkAlfa),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            ContainerTopRoundedCorner(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge),
                child: Column(
                  children: [
                    TabBar(
                      controller: controller.splitController,
                      indicatorColor: Get.theme.colorScheme.primary,
                      labelColor: Get.theme.colorScheme.primary,
                      unselectedLabelColor: Get.theme.colorScheme.background,
                      labelStyle: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textMedium,
                      ),
                      unselectedLabelStyle: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textMedium,
                      ),
                      onTap: (index) {
                        if (index == 0) {
                          controller.showCheckbox.value = true;
                          controller.showRemainingAmount.value = false;
                          controller.selectedTab.value = "Equally";
                        } else {
                          controller.showCheckbox.value =
                              true; //TODO when visibility value of this controller.showCheckbox.value is set to true, change here only controller.showCheckbox.value = false
                          controller.showRemainingAmount.value = true;
                          controller.selectedTab.value = "Unequally";
                        }
                      },
                      tabs: [
                        Tab(
                          text: LabelKeys.equally.tr,
                        ),
                        Tab(
                          text: LabelKeys.unequally.tr,
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller.splitController,
                        children: [
                          RefreshIndicator(
                            onRefresh: () async {},
                            child: Obx(() {
                              controller.isListAvailable.value = true;
                              return controller.isListAvailable.value
                                  ? Obx(() => equally())
                                  : Center(
                                      child: Text(LabelKeys.noDataError.tr));
                            }),
                          ),
                          RefreshIndicator(
                            onRefresh: () async {},
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Obx(() {
                                return controller.isListAvailable.value
                                    ? Obx(() => unequally())
                                    : Center(
                                        child: Text(LabelKeys.noDataError.tr));
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Visibility(
                      visible: controller.showRemainingAmount.value,
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                LabelKeys.remainingAmount.tr,
                                style: onBackGroundTextStyleMedium(),
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$',
                                  style: onBackgroundTextStyleRegular(
                                      fontSize: AppDimens.textMedium,
                                      alpha: Constants.veryLightAlfa),
                                ),
                                AppDimens.paddingSmall.pw,
                                SizedBox(
                                  width: AppDimens.onBoardingTitleHeight,
                                  child: Text(
                                    controller.remainingAmount.value,
                                    style: onBackgroundTextStyleRegular(
                                        fontSize: AppDimens.textMedium,
                                        alpha: Constants.veryLightAlfa),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    AppDimens.paddingMedium.ph,
                    MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.save.tr,
                      onPressed: () {
                        if (controller.selectedTab.value == "Equally") {
                          if (controller.selectedGuestList.isEmpty) {
                            RequestManager.getSnackToast(
                                message: LabelKeys.cBlankAddExpenseSelectMembers.tr);
                          } else {
                            for (var trip in controller.selectedGuestList) {
                              controller.shareList.add(
                                ShareList(
                                  debtor: trip.id,
                                  amount: controller.amountDividedInGuest(),
                                ),
                              );
                            }
                          }
                          Get.back(result: {
                            'shareList': controller.shareList,
                            'selectedTab': controller.selectedTab.value
                          });
                        } else {
                          // selected tab is Unequally
                          double finalAmount = 0;
                          if (controller.textFieldValues.isNotEmpty) {
                            controller.shareList.clear();
                            for (int i = 0;
                            i < controller.tripGuestList.length &&
                                i < controller.textFieldValues.length;
                            i++) {
                              finalAmount = finalAmount +
                                  double.parse(controller.textFieldValues[i]
                                      .toStringAsFixed(2));
                              controller.shareList.add(ShareList(
                                  debtor: controller.tripGuestList[i].id,
                                  amount: controller.textFieldValues[i]
                                      .toStringAsFixed(2)));
                            }
                            if (finalAmount > double.parse(controller.amount.value)) {
                              RequestManager.getSnackToast(
                                  message: LabelKeys.expenseAmountMsg.tr);
                            } else {
                              Get.back(result: {
                                'shareList': controller.shareList,
                                'selectedTab': controller.selectedTab.value
                              });
                            }
                          }
                        }
                      },
                    ),
                    AppDimens.paddingMedium.ph,
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget equally() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimens.paddingMedium.ph,
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.tripGuestList.value.length,
            restorationId: controller.restorationId.value,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return itemEqually(index);
            },
          ),
        ],
      ),
    );
  }

  Widget unequally() {
    return SingleChildScrollView(
      reverse: true,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimens.paddingMedium.ph,
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.tripGuestList.value.length,
            restorationId: controller.restorationId.value,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return itemUnequally(index);
            },
          ),
        ],
      ),
    );
  }

  Widget itemEqually(int index) {
    return Obx(
      () => InkWell(
        onTap: () {
          if (controller.tripGuestList[index].isSelected) {
            controller.tripGuestList[index].isSelected = false;
          } else {
            controller.tripGuestList[index].isSelected = true;
          }
          controller.restorationId.value = getRandomString();
          controller.selectedGuestList.clear();
          for (var tripguestlist in controller.tripGuestList) {
            if (tripguestlist.isSelected) {
              controller.selectedGuestList.add(tripguestlist);
            }
          }
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppDimens.paddingTiny),
                          child: CommonNetworkImage(
                            imageUrl:
                                controller.tripGuestList[index].profilePicture,
                            height: AppDimens.largeIconSize,
                            width: AppDimens.largeIconSize,
                            radius: AppDimens.paddingMedium,
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: controller.tripGuestList[index].isSelected
                                ? SvgPicture.asset(IconPath.selExpenseIcon)
                                : const SizedBox()),
                      ],
                    ),
                    AppDimens.paddingMedium.pw,
                    Text(
                      '${controller.tripGuestList[index].firstName!} ${controller.tripGuestList[index].lastName!}',
                      style: onBackGroundTextStyleMedium(),
                    ),
                  ],
                ),
                Text(
                  controller.tripGuestList[index].isSelected
                      ? controller.amountDividedInGuest()
                      : '0.00',
                  style: onBackgroundTextStyleSemiBold(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemUnequally(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.paddingSmall),
      height: AppDimens.circleNavBarHeight,
      decoration: BoxDecoration(
          border: Border.all(
            width: AppDimens.paddingNano,
            color: Get.theme.colorScheme.background
                .withAlpha(Constants.veryLightAlfa),
          ),
          color: Colors.transparent,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingTiny),
                    child: CommonNetworkImage(
                      imageUrl: controller.tripGuestList[index].profilePicture,
                      height: AppDimens.largeIconSize,
                      width: AppDimens.largeIconSize,
                      radius: AppDimens.paddingMedium,
                    ),
                  ),
                  AppDimens.paddingMedium.pw,
                  Flexible(
                    child: Text(
                      '${controller.tripGuestList[index].firstName!} ${controller.tripGuestList[index].lastName!}',
                      style: onBackGroundTextStyleMedium(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  '\$',
                  style: onBackgroundTextStyleRegular(
                      fontSize: AppDimens.textMedium,
                      alpha: Constants.veryLightAlfa),
                ),
                AppDimens.paddingSmall.pw,
                SizedBox(
                  width: AppDimens.onBoardingTitleHeight,
                  child: CustomTextField(
                    enabled: controller.tripGuestList[index].id !=
                        controller.guestId.value,
                    controller: controller.textEditingController[index],
                    keyBoardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textMedium,
                        alpha: Constants.veryLightAlfa),
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.colorScheme.onBackground
                                    .withAlpha(Constants.veryLightAlfa))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.colorScheme.onBackground
                                    .withAlpha(Constants.veryLightAlfa))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.colorScheme.onBackground
                                    .withAlpha(Constants.veryLightAlfa))),
                        isDense: true,
                        labelStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    onChanged: (value) {
                      controller.textFieldValues.clear();
                      controller.customDebouncer.run(() {
                        for (int i = 0;
                            i < controller.textEditingController.length;
                            i++) {
                          if (controller.tripGuestList[i].id !=
                              controller.guestId.value) {
                            if (controller
                                .textEditingController[i].text.isNotEmpty) {
                              controller.textFieldValues.add(double.parse(
                                  controller.textEditingController[i].text
                                      .trim()));
                            } else {
                              controller.textFieldValues.add(0);
                            }
                          }
                        }

                        controller.amountDividedUnequally.value =
                            controller.textFieldValues.reduce((a, b) {
                          return a + b;
                        });
                        if (controller.amountDividedUnequally.value <=
                            double.parse(controller.amount.value)) {
                          final calculatedAmount =
                              double.parse(controller.amount.value) -
                                  controller.amountDividedUnequally.value;
                          controller.remainingAmount.value =
                              calculatedAmount.toStringAsFixed(2);
                        } else {
                          RequestManager.getSnackToast(
                              message: LabelKeys.remainingAmountMsg.tr);
                        }

                        for (int i = 0;
                            i < controller.tripGuestList.length;
                            i++) {
                          if (controller.tripGuestList[i].id ==
                              controller.guestId.value) {
                            controller.textEditingController[i].text =
                                controller.remainingAmount.value;
                            controller.textFieldValues.insert(
                                i,
                                double.parse(
                                    controller.textEditingController[i].text));
                          }
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
