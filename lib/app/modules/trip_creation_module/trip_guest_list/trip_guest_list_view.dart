import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/contact_badge_list.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/general_utils/constants.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import '../../common_widgets/trip_guest_list.dart';
import 'trip_guest_list_controller.dart';

class TripGuestListView extends GetView<TripGuestListController> {
  const TripGuestListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Get.theme.colorScheme.primary,
        appBar: CustomAppBar.buildAppBar(
          backgroundColor: Get.theme.colorScheme.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          isCustomTitle: true,
          customTitleWidget: CustomAppBar.backButton(),
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.textExtraLarge),
                child: Text(
                  LabelKeys.guest.tr,
                  style: onPrimaryTextStyleMedium(
                      fontSize: AppDimens.textExtraLarge),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.textExtraLarge),
                child: Text(
                  LabelKeys.selectTripGuest.tr,
                  style:
                      onPrimaryTextStyleMedium(fontSize: AppDimens.textMedium),
                ),
              ),
              AppDimens.paddingMedium.ph,
              Expanded(
                child: ContainerTopRoundedCorner(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Obx(() => controller.isHostOrCoHost.value && controller.lstSelectedContact.isNotEmpty
                            ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingMedium,
                              vertical: AppDimens.paddingSmall),
                          height: AppDimens.subscriptionCardHeight,
                          child: ContactBadgeList(
                            lstAddedGuest:
                            controller.lstSelectedContact.value,
                            onRemoveTap: (index) {
                              if (controller
                                  .lstSelectedContact[index]
                                  .isSelected) {
                                controller.lstSelectedContact[index]
                                    .isSelected = false;
                                controller.lstSelectedContact.removeWhere(
                                        (element) =>
                                    element.id ==
                                        controller
                                            .lstSelectedContact[
                                        index]
                                            .id);
                                printMessage(
                                    "controller.lstSelectedContact.length111: ${controller.lstSelectedContact.length}");
                              } else {
                                controller.lstSelectedContact[index]
                                    .isSelected = true;
                                controller.lstSelectedContact.add(
                                    controller
                                        .lstSelectedContact[index]);
                                printMessage(
                                    "controller.lstSelectedContact.length: ${controller.lstSelectedContact.length}");
                              }
                              controller.restorationId.value =
                                  getRandomString();
                            },
                            isTripFinalized: controller.isTripFinalized.value,
                          ),
                        ) : const SizedBox()),
                        CustomTextField(
                          textInputAction: TextInputAction.search,
                          controller: controller.searchTextEditController,
                          onChanged: (value) {
                            controller.lstAddedGuestSearchData.value =
                                controller.lstAddedGuestModel
                                    .where((element) => element.firstName
                                        .toString()
                                        .toLowerCase()
                                        .contains(
                                            value.toString().toLowerCase()))
                                    .toList();
                            controller.restorationId.value = getRandomString();
                          },
                          inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            hintText: LabelKeys.searchInvitees.tr,
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Get.theme.colorScheme.onBackground
                                      .withAlpha(Constants.limit)),
                            ),
                            isDense: true,
                            suffixIconConstraints:
                                const BoxConstraints(maxHeight: 60),
                            prefixIconConstraints:
                                const BoxConstraints(maxHeight: 60),
                            contentPadding: const EdgeInsets.fromLTRB(
                                0, 18, AppDimens.paddingExtraLarge, 15),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.searchTextEditController.text = "";
                                controller.lstAddedGuestSearchData.value =
                                    controller.lstAddedGuestModel;
                                controller.restorationId.value =
                                    getRandomString();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  IconPath.closeRoundedIcon,
                                  height: AppDimens.normalIconSize,
                                  width: AppDimens.normalIconSize,
                                ),
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: AppDimens.paddingMedium),
                              child: SvgPicture.asset(
                                IconPath.searchIcon,
                                height: AppDimens.normalIconSize,
                                width: AppDimens.normalIconSize,
                              ),
                            ),
                          ),
                        ),
                        AppDimens.paddingMedium.ph,
                        Expanded(
                          child: Obx(() => controller
                                  .lstAddedGuestSearchData.isNotEmpty
                              ? TripGuestList(
                                  restorationId: controller.restorationId.value,
                                  onTap: (index) {
                                    if (controller
                                        .lstAddedGuestSearchData[index]
                                        .isSelected) {
                                      controller.lstAddedGuestSearchData[index]
                                          .isSelected = false;
                                      controller.lstSelectedContact.removeWhere(
                                          (element) =>
                                              element.id ==
                                              controller
                                                  .lstAddedGuestSearchData[
                                                      index]
                                                  .id);
                                      printMessage(
                                          "controller.lstSelectedContact.length111: ${controller.lstSelectedContact.length}");
                                    } else {
                                      controller.lstAddedGuestSearchData[index]
                                          .isSelected = true;
                                      controller.lstSelectedContact.add(
                                          controller
                                              .lstAddedGuestSearchData[index]);
                                      printMessage(
                                          "controller.lstSelectedContact.length: ${controller.lstSelectedContact.length}");
                                    }
                                    controller.restorationId.value =
                                        getRandomString();
                                  },
                                  lstAddedGuest:
                                      controller.lstAddedGuestSearchData.value,
                                )
                              : controller.isDataLoading.value
                                  ? SizedBox(
                                      width: Get.width,
                                    )
                                  : const NoRecordFound()),
                        ),
                        isKeyboardOpen
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: MasterButtonsBounceEffect.gradiantButton(
                                  btnText: LabelKeys.importGuests.tr,
                                  onPressed: () {
                                    if (controller
                                        .lstSelectedContact.isNotEmpty) {
                                      controller.addGuest();
                                    } else {
                                      RequestManager.getSnackToast(
                                          message:
                                              LabelKeys.pleaseSelectInvitee.tr);
                                    }
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
