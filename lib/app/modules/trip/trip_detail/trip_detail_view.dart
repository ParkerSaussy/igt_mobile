import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/modules/common_widgets/city_poll_list.dart';
import 'package:lesgo/app/modules/common_widgets/date_poll_list.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottomsheet_with_close.dart';
import '../../common_widgets/placeholder_container_with_icon.dart';
import '../../common_widgets/select_date_bottomsheet.dart';
import 'trip_detail_controller.dart';

class TripDetailView extends GetView<TripDetailController> {
  const TripDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Preference.isGetNotification()) {
          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          Get.back();
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          isCustomTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          customTitleWidget: CustomAppBar.backButton(
              iconColor: Get.theme.colorScheme.onPrimary,
              onBack: () {
                printMessage(
                    "Preference.isGetNotification(): ${Preference.isGetNotification()}");
                if (Preference.isGetNotification()) {
                  Get.offAllNamed(Routes.DASHBOARD);
                } else {
                  Get.back();
                }
              },
              textStyle: onPrimaryTextStyleMedium()),
          actionWidget: [
            Obx(
              () => controller.isTripDetailsLoaded.value &&
                      controller.tripDetailsModel!.role == Role.host
                  ? deleteTripActionMenu()
                  : const SizedBox(),
            ),
            groupChatActionMenu(),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Obx(
          () => controller.isTripDetailsLoaded.value
              ? GestureDetector(
                  onTap: () {
                    Get.focusScope?.unfocus();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          //Header Image
                          headerImageWidget(),
                          // Header Image gradiant layer
                          headerImageGradiantLayer(),
                          // Trip name and date on header
                          tripNameAndDateOnHeader(),
                        ],
                      ),
                      Expanded(
                        child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: false,
                          header: WaterDropMaterialHeader(
                            backgroundColor: Get.theme.colorScheme.primary,
                          ),
                          controller: controller.tripDetailController,
                          onRefresh: controller.onRefresh,
                          onLoading: controller.onLoading,
                          child: SingleChildScrollView(
                            controller: controller.scrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  AppDimens.paddingExtraLarge),
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Premium features unlocked by
                                    premiumTripInfo(),
                                    // Trip Name Textview
                                    tripNameTextView(),
                                    //Trip Name EditText
                                    tripNameEditText(),
                                    controller.isEditable.value == 1
                                        ? AppDimens.paddingExtraLarge.ph
                                        : 0.ph,
                                    //Trip Description
                                    tripDescription(),
                                    controller.isEditable.value != 1
                                        ? AppDimens.paddingExtraLarge.ph
                                        : 0.ph,
                                    // Date and city poll view
                                    controller
                                            .tripDetailsModel!.isTripFinalised!
                                        ? const SizedBox()
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                LabelKeys.polls.tr,
                                                style:
                                                    onBackGroundTextStyleMedium(
                                                  fontSize:
                                                      AppDimens.textExtraLarge,
                                                  alpha: Constants.darkAlfa,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              AppDimens.paddingSmall.ph,
                                              poll1(),
                                              AppDimens.paddingMedium.ph,
                                              cityPoll(),
                                            ],
                                          ),

                                    controller
                                            .tripDetailsModel!.isTripFinalised!
                                        ? 0.ph
                                        : AppDimens.paddingMedium.ph,
                                    // Arrival Time widget
                                    arrivalTimeWidget(),

                                    controller.isEditable.value == 1 &&
                                            controller.startEndDateText.value
                                                .isNotEmpty
                                        ? AppDimens.paddingMedium.ph
                                        : controller.tripDetailsModel!
                                                .isTripFinalised!
                                            ? AppDimens.paddingMedium.ph
                                            : 0.ph,

                                    //If trip finalized then show city venue
                                    controller
                                            .tripDetailsModel!.isTripFinalised!
                                        ? GestureDetector(
                                            onTap: () {
                                              controller.isSelectedCategory
                                                      .value =
                                                  !controller
                                                      .isSelectedCategory.value;
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: PlaceholderContainerWithIcon(
                                              titleName: LabelKeys.cityVenue.tr,
                                              widget: Text(
                                                controller
                                                        .tripDetailsModel!
                                                        .cityNameDetails!
                                                        .cityName ??
                                                    "",
                                                style:
                                                    onBackgroundTextStyleRegular(
                                                        alpha: Constants
                                                            .veryLightAlfa),
                                              ),
                                              iconPath: IconPath.iconGallery,
                                            ),
                                          )
                                        : const SizedBox(),

                                    controller
                                            .tripDetailsModel!.isTripFinalised!
                                        ? AppDimens.paddingMedium.ph
                                        : 0.ph,

                                    //Trip finalizing comment
                                    tripFinalizingWidget(),
                                    controller.isEditable.value == 1
                                        ? AppDimens.paddingMedium.ph
                                        : controller.tripDetailsModel!
                                                .isTripFinalised!
                                            ? 0.ph
                                            : AppDimens.paddingMedium.ph,

                                    //Itinerary Details textfield
                                    controller.tCommentController.text == "" &&
                                            controller.isEditable.value != 1
                                        ? const SizedBox()
                                        : PlaceholderContainerWithIcon(
                                            widget: CustomTextField(
                                              controller: controller
                                                  .itineraryController,
                                              focusNode:
                                                  controller.itineraryNode,
                                              readOnly:
                                                  controller.isEditable.value !=
                                                      1,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              style:
                                                  onBackgroundTextStyleRegular(
                                                      alpha:
                                                          Constants.lightAlfa),
                                              onTap: () {},
                                              enabled:
                                                  controller.isEditable.value ==
                                                      1,
                                              maxLines: 5,
                                              maxLength: 250,
                                              inputDecoration: CustomTextField
                                                  .prefixSuffixOnlyIcon(
                                                      prefixRightPadding: 0,
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: AppDimens
                                                                  .paddingSmall,
                                                              top: AppDimens
                                                                  .paddingSmall),
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      alignLabelWithHint: true,
                                                      isDense: true,
                                                      hintText:
                                                          LabelKeys.optional.tr,
                                                      counterText: ""),
                                              onFieldSubmitted: (v) {},
                                              onChanged: (v) {},
                                            ),
                                            titleName:
                                                LabelKeys.itineraryDetails.tr,
                                          ),
                                    AppDimens.paddingMedium.ph,
                                    //Response deadLine date picker
                                    responseDeadLineDatePicker(),
                                    controller.isEditable.value == 1
                                        ? AppDimens.paddingMedium.ph
                                        : 0.ph,
                                    //Reminder stepper
                                    controller.isEditable.value == 1
                                        ? selectReminderStepper()
                                        : const SizedBox(),
                                    controller.isEditable.value == 1
                                        ? AppDimens.paddingMedium.ph
                                        : 0.ph,
                                    // Select Display Image Widget
                                    displayImageWidget(),

                                    controller.isEditable.value == 1
                                        ? AppDimens.paddingExtraLarge.ph
                                        : 0.ph,

                                    // Features TextView
                                    featuresTextView(),

                                    AppDimens.paddingSmall.ph,

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //Group Chat Grid Item
                                        groupChatGridItem(),
                                        AppDimens.paddingVerySmall.pw,
                                        //Activities Grid Item
                                        activitiesGridItem(),
                                        AppDimens.paddingVerySmall.pw,
                                        //Group Expense Grid Item
                                        groupExpenseGridItem(),
                                        AppDimens.paddingVerySmall.pw,
                                        //Guest List Grid Item
                                        guestListGridItem(),
                                      ],
                                    ),
                                    AppDimens.paddingVerySmall.ph,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //Trip Photos Grid Item
                                        tripPhotosGridItem(),
                                        AppDimens.paddingVerySmall.pw,
                                        //Documents Grid Item
                                        documentsGridItem(),
                                        AppDimens.paddingVerySmall.pw,
                                        //Add to Calender Grid Item
                                        addToCalenderGridItem(),
                                      ],
                                    ),
                                    AppDimens.paddingExtraLarge.ph,
                                    controller.isEditable.value == 1
                                        ? saveOrFinalizeButtons()
                                        : (controller.isEditable.value == 0
                                            ? inOutButtons()
                                            : const SizedBox()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget arriveWidget(
      String title,
      String leftStr,
      String rightStr,
      String leftValue,
      String rightValue,
      Function onTimeTap,
      Function onLeaveAfterTap) {
    return PlaceholderContainerWithIcon(
      iconPath: IconPath.iconTime,
      titleName: title,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimens.paddingSmall.ph,
          IntrinsicWidth(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                AppDimens.paddingMedium.pw,
                GestureDetector(
                  onTap: () {
                    onTimeTap();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(leftStr,
                          style: onBackGroundTextStyleMedium(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.darkAlfa)),
                      Text(leftValue,
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.veryLightAlfa)),
                    ],
                  ),
                ),
                SvgPicture.asset(IconPath.arrowLong),
                GestureDetector(
                  onTap: () {
                    onLeaveAfterTap();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(rightStr,
                          style: onBackGroundTextStyleMedium(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.darkAlfa)),
                      Text(rightValue,
                          style: onBackGroundTextStyleMedium(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.veryLightAlfa)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gridItem(double width, String icon, String title, bool isPaidTrip) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Get.theme.colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppDimens.paddingMedium)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: isPaidTrip
                  ? Stack(
                      children: [
                        SvgPicture.asset(IconPath.premiumShapeIcon),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Transform.rotate(
                            angle: -math.pi / 5,
                            child: controller.isPremiumTrip.value
                                ? SvgPicture.asset(IconPath.premiumKingIcon)
                                : Text(
                                    LabelKeys.pro.tr,
                                    style: onPrimaryTextStyleRegular(
                                      fontSize: AppDimens.textSmall,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppDimens.paddingSmall,
                  right: AppDimens.paddingSmall,
                  top: AppDimens.paddingMedium,
                  bottom: AppDimens.paddingTiny),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppDimens.paddingMedium.ph,
                  SvgPicture.asset(icon),
                  AppDimens.paddingVerySmall.ph,
                  Text(
                    '$title\n',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textTiny,
                        alpha: Constants.veryLightAlfa),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cityPoll() {
    return Container(
      key: controller.listGlobalKey[0],
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimens.paddingMedium),
          border: Border.all(color: Get.theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Get.theme.dividerColor,
              blurRadius: AppDimens.paddingNano,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: AppDimens.paddingLarge,
                right: AppDimens.paddingMedium,
                top: AppDimens.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LabelKeys.selectCity.tr,
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textMedium,
                        alpha: Constants.veryLightAlfa)),
                Row(
                  children: [
                    controller.isEditable.value == 1
                        ? GestureDetector(
                            onTap: () {
                              FocusScope.of(Get.context!).unfocus();
                              Get.bottomSheet(
                                  enableDrag: false,
                                  isScrollControlled: true,
                                  ignoreSafeArea: false,
                                  selectCityView());
                            },
                            child: SvgPicture.asset(IconPath.plus))
                        : const SizedBox(),
                    AppDimens.paddingSmall.pw,
                    popupInfo(),
                  ],
                ),
              ],
            ),
          ),
          AppDimens.paddingMedium.ph,
          Padding(
            padding: const EdgeInsets.only(
                top: AppDimens.paddingMedium,
                left: AppDimens.paddingLarge,
                right: AppDimens.paddingExtraLarge),
            child: Obx(
              () => CityPollListView(
                isDatePollExpanded: controller.isCityPollExpanded.value,
                restorationId: controller.restorationIdCity.value,
                lstPollModel: controller.lstTripDetailsCityPoll.value,
                onSelect: (index) {
                  if (controller.isEditable.value == 1) {
                    if (controller.lstTripDetailsCityPoll[index].cityNameDetails
                            ?.isDefault !=
                        1) {
                      for (int i = 0;
                          i < controller.lstTripDetailsCityPoll.length;
                          i++) {
                        controller.lstTripDetailsCityPoll[i].userVoted = 0;
                      }
                      controller.lstTripDetailsCityPoll[index].userVoted = 1;
                      controller.selectedTripCityByHost =
                          controller.lstTripDetailsCityPoll[index];
                      controller.restorationIdCity.value = getRandomString();
                    }
                  } else {
                    controller.lstTripDetailsCityPoll[index].userVoted =
                        controller.lstTripDetailsCityPoll[index].userVoted == 1
                            ? 0
                            : 1;
                    if (controller.lstTripDetailsCityPoll[index].cityNameDetails
                            ?.isDefault ==
                        1) {
                      if (controller.lstTripDetailsCityPoll[index].userVoted ==
                          1) {
                        for (int i = 0;
                            i < controller.lstTripDetailsCityPoll.length;
                            i++) {
                          if (i != index) {
                            controller.lstTripDetailsCityPoll[i].userVoted = 0;
                          }
                        }
                      }
                      controller.restorationIdCity.value = getRandomString();
                    } else {
                      for (int i = 0;
                          i < controller.lstTripDetailsCityPoll.length;
                          i++) {
                        if (controller.lstTripDetailsCityPoll[i].cityNameDetails
                                ?.isDefault ==
                            1) {
                          controller.lstTripDetailsCityPoll[i].userVoted = 0;
                        }
                      }
                    }
                    controller.restorationIdCity.value = getRandomString();
                  }
                },
              ),
            ),
          ),
          AppDimens.paddingSmall.ph,
          Container(
            height: AppDimens.paddingNano,
            color: Get.theme.colorScheme.outline,
            width: Get.width,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: AppDimens.paddingLarge, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.lstTripDetailsCityPoll.isNotEmpty
                    ? MasterButtonsBounceEffect.textButton(
                        btnText: LabelKeys.viewPollDetails.tr,
                        onPressed: () {
                          Get.toNamed(Routes.POLL_DETAIL,
                              arguments: [controller.tripDetailsModel, false]);
                        },
                        height: 40,
                        textStyles: primaryTextStyleMedium(),
                      )
                    : const SizedBox(),
                Obx(() => controller.lstTripDetailsCityPoll.value.length > 2
                    ? /*MasterButtonsBounceEffect.gradiantButtonWithRightIcon(
                        gradiantColors: [
                            Colors.transparent,
                            Colors.transparent
                          ],
                        width: 110,
                        height: 40,
                        svgUrl: controller.isCityPollExpanded.value
                            ? IconPath.upArrow
                            : IconPath.downArrow,
                        btnText: controller.isCityPollExpanded.value
                            ? LabelKeys.viewLess.tr
                            : LabelKeys.viewAll.tr,
                        textStyles: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha),
                        onPressed: () {
                          if (controller.isCityPollExpanded.value) {
                            controller.isCityPollExpanded.value = false;
                          } else {
                            controller.isCityPollExpanded.value = true;
                          }
                        })*/
                    GestureDetector(
                        onTap: () {
                          if (controller.isCityPollExpanded.value) {
                            controller.isCityPollExpanded.value = false;
                          } else {
                            controller.isCityPollExpanded.value = true;
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              controller.isDatePollExpanded.value
                                  ? LabelKeys.viewLess.tr
                                  : LabelKeys.viewAll.tr,
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.lightAlfa),
                            ),
                            AppDimens.paddingMedium.pw,
                            SvgPicture.asset(
                              controller.isDatePollExpanded.value
                                  ? IconPath.upArrow
                                  : IconPath.downArrow,
                            ),
                            AppDimens.paddingMedium.pw,
                          ],
                        ),
                      )
                    : const SizedBox())
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget poll1() {
    return Container(
      key: controller.listGlobalKey[1],
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.paddingMedium),
        border: Border.all(color: Get.theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Get.theme.dividerColor,
            blurRadius: AppDimens.paddingNano,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: AppDimens.paddingLarge,
                right: AppDimens.paddingMedium,
                top: AppDimens.paddingMedium),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppDimens.radiusCorner)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      LabelKeys.selectOne.tr,
                      style: onBackgroundTextStyleRegular(
                          alpha: Constants.lightAlfa),
                    ),
                  ),
                  controller.isEditable.value == 1
                      ? GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              isScrollControlled: true,
                              calendarBottomSheet(),
                            );
                          },
                          child: SvgPicture.asset(IconPath.plus))
                      : const SizedBox(),
                  AppDimens.paddingSmall.pw,
                  popupInfo(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: AppDimens.paddingMedium,
                left: AppDimens.paddingLarge,
                right: AppDimens.paddingExtraLarge),
            child: Obx(
              () => PollListView(
                isDatePollExpanded: controller.isDatePollExpanded.value,
                restorationId: controller.restorationId.value,
                lstPollModel: controller.lstTripDatePoll.value,
                onSelect: (index) {
                  if (controller.isEditable.value == 1) {
                    if (controller.lstTripDatePoll[index].isDefault != 1) {
                      for (int i = 0;
                          i < controller.lstTripDatePoll.length;
                          i++) {
                        controller.lstTripDatePoll[i].userVoted = 0;
                      }
                      controller.lstTripDatePoll[index].userVoted = 1;
                      controller.selectedDateByHost =
                          controller.lstTripDatePoll[index];
                      final arriveBy = Date.shared().getTwelveHourTime(
                          controller.selectedDateByHost!.startDate!);
                      final leaveAfter = Date.shared().getTwelveHourTime(
                          controller.selectedDateByHost!.endDate!);
                      controller.arriveByTime.value = arriveBy;
                      controller.leaveAfterTime.value = leaveAfter;
                      printMessage(
                          "arriveBy: $arriveBy -- leaveAfter $leaveAfter");
                      final startAndEndDate =
                          "${Date.shared().format(controller.selectedDateByHost!.startDate!)} to ${Date.shared().format(controller.selectedDateByHost!.endDate!)}";
                      controller.startEndDateText.value = startAndEndDate;
                      controller.restorationId.value = getRandomString();
                    }
                  } else {
                    controller.lstTripDatePoll[index].userVoted =
                        controller.lstTripDatePoll[index].userVoted == 1
                            ? 0
                            : 1;
                    if (controller.lstTripDatePoll[index].isDefault == 1) {
                      if (controller.lstTripDatePoll[index].userVoted == 1) {
                        for (int i = 0;
                            i < controller.lstTripDatePoll.length;
                            i++) {
                          if (i != index) {
                            controller.lstTripDatePoll[i].userVoted = 0;
                          }
                        }
                      }
                      controller.restorationId.value = getRandomString();
                    } else {
                      for (int i = 0;
                          i < controller.lstTripDatePoll.length;
                          i++) {
                        if (controller.lstTripDatePoll[i].isDefault == 1) {
                          controller.lstTripDatePoll[i].userVoted = 0;
                        }
                      }
                    }
                    controller.restorationId.value = getRandomString();
                  }
                },
              ),
            ),
          ),
          AppDimens.paddingSmall.ph,
          Container(
            height: AppDimens.paddingNano,
            color: Get.theme.colorScheme.outline,
            width: Get.width,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: AppDimens.paddingLarge, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.lstTripDatePoll.isNotEmpty
                    ? MasterButtonsBounceEffect.textButton(
                        btnText: LabelKeys.viewPollDetails.tr,
                        onPressed: () {
                          Get.toNamed(Routes.POLL_DETAIL,
                              arguments: [controller.tripDetailsModel, true]);
                        },
                        height: 40,
                        textStyles: primaryTextStyleMedium(),
                      )
                    : const SizedBox(),
                Obx(() => controller.lstTripDatePoll.value.length > 2
                    ? /*MasterButtonsBounceEffect.gradiantButtonWithRightIcon(
                        gradiantColors: [
                            Colors.transparent,
                            Colors.transparent
                          ],
                        svgUrl: controller.isDatePollExpanded.value
                            ? IconPath.upArrow
                            : IconPath.downArrow,
                        btnText: controller.isDatePollExpanded.value
                            ? LabelKeys.viewLess.tr
                            : LabelKeys.viewAll.tr,
                        textStyles: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha),
                        onPressed: () {
                          if (controller.isDatePollExpanded.value) {
                            controller.isDatePollExpanded.value = false;
                          } else {
                            controller.isDatePollExpanded.value = true;
                          }
                        })*/

                    GestureDetector(
                        onTap: () {
                          if (controller.isDatePollExpanded.value) {
                            controller.isDatePollExpanded.value = false;
                          } else {
                            controller.isDatePollExpanded.value = true;
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              controller.isDatePollExpanded.value
                                  ? LabelKeys.viewLess.tr
                                  : LabelKeys.viewAll.tr,
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.lightAlfa),
                            ),
                            AppDimens.paddingMedium.pw,
                            SvgPicture.asset(
                              controller.isDatePollExpanded.value
                                  ? IconPath.upArrow
                                  : IconPath.downArrow,
                            ),
                            AppDimens.paddingMedium.pw,
                          ],
                        ),
                      )
                    : const SizedBox())
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget popupInfo() => Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: PopupMenuButton<int>(
          elevation: 1,
          shadowColor: Colors.black,
          padding: const EdgeInsets.only(right: 0),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
          itemBuilder: (context) => [
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              value: 1,
              padding: const EdgeInsets.only(
                  left: AppDimens.textLarge, bottom: AppDimens.paddingTiny),
              child: itemMenu(LabelKeys.noVote.tr, Colors.grey),
            ),
            PopupMenuItem(
              height: AppDimens.paddingLarge,
              value: 2,
              padding: const EdgeInsets.only(
                  left: AppDimens.textLarge, bottom: AppDimens.paddingTiny),
              child: itemMenu(LabelKeys.allVIP.tr, Colors.green),
            ),
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              value: 3,
              padding: const EdgeInsets.only(
                  left: AppDimens.textLarge, bottom: AppDimens.paddingTiny),
              child: itemMenu(LabelKeys.noVIP.tr, Colors.red),
            ),
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              value: 4,
              padding: const EdgeInsets.only(left: AppDimens.textLarge),
              child: itemMenu(LabelKeys.atleastVIP.tr, Colors.yellow),
            ),
          ],
          child: SvgPicture.asset(IconPath.info),
        ),
      );

  Widget itemMenu(String title, Color colorName) {
    return Row(
      children: [
        Container(
          height: AppDimens.paddingMedium,
          width: AppDimens.paddingMedium,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.paddingMedium)),
              color: colorName),
        ),
        AppDimens.paddingSmall.pw,
        Text(title,
            style: onSurfaceTextStyleRegular(
                fontSize: AppDimens.textSmall, alpha: Constants.darkAlfa)),
      ],
    );
  }

  Widget calendarBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Obx(
          () => SelectDateBottomSheet(
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(controller.selectedDay, selectedDay)) {
                controller.selectedDay = selectedDay;
                controller.focusedDay = focusedDay;
                controller.rangeStart = null; // Important to clean those
                controller.rangeEnd = null;
                controller.rangeSelectionMode = RangeSelectionMode.toggledOff;
              }
              setState(() {});
            },
            onRangeSelected: (start, end, focusedDay) {
              controller.selectedDay = null;
              controller.focusedDay = focusedDay;
              controller.rangeStart = start;
              controller.rangeEnd = end;
              controller.rangeSelectionMode = RangeSelectionMode.toggledOn;
              setState(() {});
            },
            onFormatChanged: (format) {
              if (controller.calendarFormat != format) {
                controller.calendarFormat = format;
              }
              setState(() {});
            },
            onPageChanged: (focusedDay) {
              controller.focusedDay = focusedDay;
              setState(() {});
            },
            calendarFormat: controller.calendarFormat,
            rangeSelectionMode: controller.rangeSelectionMode,
            focusedDay: controller.focusedDay,
            selectedDay: controller.selectedDay,
            rangeStart: controller.rangeStart,
            rangeEnd: controller.rangeEnd,
            onAddClick: () {
              if (controller.rangeStart == null) {
                Get.snackbar("", LabelKeys.cBlankTripStartDate.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);
              } else {
                printMessage("Else Part");
                /*else*/ controller.rangeEnd ??= controller.rangeStart;
                /*else*/ if (controller.arriveTime.value == "HH:MM") {
                  controller.arriveTime.value = "00:00:00";
                  printMessage(controller.arriveTime.value);
                  /* Get.snackbar("", LabelKeys.cBlankTripArrivalTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/
                }
                /*else*/ if (controller.leaveTime.value == "HH:MM") {
                  controller.leaveTime.value = "00:00:00";
                  /*Get.snackbar("", LabelKeys.cBlankTripLeaveTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/
                }
                controller.onDateAdded();
              }
              /* */ /*else*/ /* if (controller.rangeEnd == null) {
                controller.rangeEnd = controller.rangeStart;
                */ /*Get.snackbar("", LabelKeys.cBlankTripEndDate.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/ /*
              }
              */ /*else*/ /* if (controller.arriveTime.value == "HH:MM") {
                controller.arriveTime.value == "00:00";
                */ /* Get.snackbar("", LabelKeys.cBlankTripArrivalTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/ /*
              }
              */ /*else*/ /* if (controller.leaveTime.value == "HH:MM") {
                controller.leaveTime.value == "00:00";
                */ /*Get.snackbar("", LabelKeys.cBlankTripLeaveTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/ /*
              }*/ /*else {
                controller.onDateAdded();
              }*/
              //Get.back();

              /*
              if (controller.rangeStart == null) {
                Get.snackbar("", LabelKeys.cBlankTripStartDate.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);
              } else if (controller.rangeEnd == null) {
                controller.rangeEnd = controller.rangeStart;
                */ /*Get.snackbar("", LabelKeys.cBlankTripEndDate.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/ /*
              } else if (controller.arriveTime.value == "HH:MM") {
                Get.snackbar("", LabelKeys.cBlankTripArrivalTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);
              } else if (controller.leaveTime.value == "HH:MM") {
                Get.snackbar("", LabelKeys.cBlankTripLeaveTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);
              } else {
                controller.onDateAdded();
              }*/
            },
            onCancelClick: () {
              Get.back();
            },
            onArriveTimeClick: () async {
              TimeOfDay timeOfDay;
              if (controller.arriveTime.value != "HH:MM") {
                DateTime parsedDateTime =
                    DateFormat("HH:mm").parse(controller.arriveTime.value);
                timeOfDay = TimeOfDay.fromDateTime(parsedDateTime);
              } else {
                timeOfDay = TimeOfDay.now();
              }
              final TimeOfDay? pickedTime = await timePicker(timeOfDay);
              final now = DateTime.now();
              DateTime parsedTime = DateTime(now.year, now.month, now.day,
                  pickedTime!.hour, pickedTime.minute);
              String formattedTime = DateFormat("HH:mm:ss").format(parsedTime);
              controller.arriveTime.value = formattedTime;
            },
            onLeaveAfterClick: () async {
              TimeOfDay timeOfDay;
              if (controller.leaveTime.value != "HH:MM") {
                DateTime parsedDateTime =
                    DateFormat("HH:mm").parse(controller.leaveTime.value);
                timeOfDay = TimeOfDay.fromDateTime(parsedDateTime);
              } else {
                timeOfDay = TimeOfDay.now();
              }
              final TimeOfDay? pickedTime = await timePicker(timeOfDay);
              final now = DateTime.now();
              DateTime parsedTime = DateTime(now.year, now.month, now.day,
                  pickedTime!.hour, pickedTime.minute);
              String formattedTime = DateFormat("HH:mm:ss").format(parsedTime);
              controller.leaveTime.value = formattedTime;
            },
            arriveTime: controller.arriveTime.value,
            leaveTime: controller.leaveTime.value,
            commentTextEditingController:
                controller.commentTextEditingController,
          ),
        );
      },
    );
  }

  Widget selectReminderStepper() {
    return Obx(() => controller.isSelectedReminder.value
        ? PlaceholderContainerWithIcon(
            iconPath: IconPath.reminderIcon,
            //titleName: LabelKeys.sendReminderEvery.tr,
            widget: Text(
              "${LabelKeys.sendReminderEvery.tr}"
              "${controller.noOfReminderDays.value > 0 ? "\n" : ""}"
              "${controller.noOfReminderDays.value > 0 ? controller.noOfReminderDays.value.toString() : ""} "
              "${controller.noOfReminderDays.value > 0 ? controller.noOfReminderDays.value > 1 ? "Days" : "Day" : ""}",
              style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
            ),
            endWidget: Row(
              children: [
                MasterButtonsBounceEffect.iconButton(
                    svgUrl: IconPath.decrementIcon,
                    iconSize: AppDimens.normalIconSize,
                    onPressed: () {
                      //onEventHoursMinusTapped();
                      controller.reminderDateStepper(false);
                    }),
                AppDimens.paddingSmall.pw,
                SizedBox(
                  width: AppDimens.twoDigitTextWidth,
                  child: Text(
                    controller.noOfReminderDays.value.toString(),
                    style: onBackGroundTextStyleMedium(),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppDimens.paddingSmall.pw,
                MasterButtonsBounceEffect.iconButton(
                    svgUrl: IconPath.addButtonGreyBg,
                    iconSize: AppDimens.normalIconSize,
                    onPressed: () {
                      controller.reminderDateStepper(true);
                    }),
              ],
            ),
          )
        : const SizedBox());
  }

  Widget venmoPaypalBottomSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppDimens.paddingLarge.ph,
            Text(
              LabelKeys.paypalVenmoUsername.tr,
              style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
            ),
            AppDimens.paddingLarge.ph,
            AppDimens.paddingLarge.ph,
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: AppDimens.paddingNano,
                    color: Get.theme.colorScheme.background
                        .withAlpha(Constants.veryLightAlfa),
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.paddingMedium))),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.paddingSmall,
                          top: AppDimens.paddingSmall),
                      child: SvgPicture.asset(IconPath.venmoIcon),
                    ),
                    AppDimens.paddingMedium.pw,
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LabelKeys.venmoUsername.tr,
                            style: onBackGroundTextStyleMedium(),
                          ),
                          CustomTextField(
                            controller: controller.venmoUsernameController,
                            style: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textLarge,
                                alpha: Constants.veryLightAlfa),
                            keyBoardType: TextInputType.text,
                            inputDecoration:
                                CustomTextField.prefixSuffixOnlyIcon(
                                    hintText: LabelKeys.xyz.tr,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    labelStyle: onBackgroundTextStyleRegular(
                                        alpha: Constants.transparentAlpha)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppDimens.paddingLarge.ph,
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: AppDimens.paddingNano,
                    color: Get.theme.colorScheme.background
                        .withAlpha(Constants.veryLightAlfa),
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.paddingMedium))),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.paddingSmall,
                          top: AppDimens.paddingSmall),
                      child: SvgPicture.asset(IconPath.paypalIcon),
                    ),
                    AppDimens.paddingMedium.pw,
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LabelKeys.paypalUsername.tr,
                            style: onBackGroundTextStyleMedium(),
                          ),
                          CustomTextField(
                            controller: controller.paypalUsernameController,
                            style: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textLarge,
                                alpha: Constants.veryLightAlfa),
                            keyBoardType: TextInputType.text,
                            inputDecoration:
                                CustomTextField.prefixSuffixOnlyIcon(
                                    hintText: LabelKeys.xyz.tr,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    labelStyle: onBackgroundTextStyleRegular(
                                        alpha: Constants.transparentAlpha)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppDimens.paddingLarge.ph,
            controller.isError.value
                ? Text(
                    LabelKeys.oneOfTheUsername.tr,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: AppDimens.textMedium,
                        color: Get.theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : const SizedBox(),
            AppDimens.paddingLarge.ph,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingLarge),
                      child: MasterButtonsBounceEffect.gradiantButton(
                        gradiantColors: [
                          Get.theme.disabledColor,
                          Get.theme.disabledColor,
                        ],
                        btnText: LabelKeys.skip.tr,
                        onPressed: () {
                          controller.isError.value = false;
                          controller.venmoUsernameController.clear();
                          controller.paypalUsernameController.clear();
                          Get.back();
                          Get.toNamed(Routes.EXPANSE_RESOLUTION_TABS,
                              arguments: [controller.tripDetailsModel!.id]);
                        },
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingLarge),
                    child: MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.save.tr,
                      onPressed: () {
                        if (controller.venmoUsernameController.text.isEmpty &&
                            controller.paypalUsernameController.text.isEmpty) {
                          controller.isError.value = true;
                          setState(() {});
                        } else {
                          controller.isError.value = false;
                          setState(() {});
                          Get.back();
                          controller.updatePaypalVenmoUsernameApi();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            AppDimens.padding3XLarge.ph,
          ],
        ),
      );
    });
  }

  Widget iAmOutBottomSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppDimens.paddingLarge.ph,
        Text(
          LabelKeys.rejectInvitationMsg.tr,
          textAlign: TextAlign.center,
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingLarge.ph,
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
            child: MasterButtonsBounceEffect.gradiantButton(
              btnText: LabelKeys.YesIOut.tr,
              onPressed: () {
                Get.back();
                controller.updateUserStatus(InviteStatus.declined);
              },
            )),
        AppDimens.padding3XLarge.ph,
      ],
    );
  }

  Widget deleteConfirmationBottomSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppDimens.paddingLarge.ph,
        Text(
          LabelKeys.deleteTripMsg.tr,
          textAlign: TextAlign.center,
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingMedium.ph,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: Text(
            LabelKeys.stepReversibleMsg.tr,
            style: onBackgroundTextStyleRegular(
                fontSize: AppDimens.textLarge, alpha: Constants.lightAlfa),
            textAlign: TextAlign.center,
          ),
        ),
        AppDimens.paddingLarge.ph,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: MasterButtonsBounceEffect.gradiantButton(
            btnText: LabelKeys.yesDelete.tr,
            onPressed: () {
              Get.back();
              controller.deleteTrip();
            },
          ),
        ),
        AppDimens.padding3XLarge.ph,
      ],
    );
  }

  Widget selectCityView() {
    return StatefulBuilder(
      builder: (context, setState) {
        return ScaffoldMessenger(
          key: controller.scaffoldMessengerKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                color: Get.theme.colorScheme.onPrimary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppDimens.paddingExtraLarge),
                          child: CustomAppBar.backButton(onBack: () {
                            controller.searchCityController.clear();
                            controller.lstCitySearch.value = controller.lstCity;
                            controller.refreshList.value = getRandomString();
                            Get.back();
                          }),
                        ),
                        MasterButtonsBounceEffect.textButton(
                          onPressed: () {
                            controller.searchCityController.clear();
                            controller.lstCitySearch.value = controller.lstCity;
                            controller.refreshList.value = getRandomString();
                            if (controller.lstEmptyCity.isNotEmpty) {
                              Get.focusScope?.unfocus();
                              controller.addCityToTrip();
                            } else {
                              Get.back();
                            }
                          },
                          btnText: LabelKeys.save.tr,
                          textStyles: primaryTextStyleSemiBold(),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.paddingMedium,
                          right: AppDimens.paddingMedium,
                          top: AppDimens.paddingMedium),
                      child: CustomTextField(
                        textInputAction: TextInputAction.search,
                        controller: controller.searchCityController,
                        onChanged: (value) {
                          if (controller.searchCityController.text != '') {
                            controller.startTimer();
                          } else {
                            controller.timer!.cancel();
                            controller.searchText =
                                controller.searchCityController.text;
                            controller.lstCitySearch.clear();
                            controller.getCities();
                          }
                          controller.refreshList.value = getRandomString();
                          setState(() {});
                        },
                        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            hintText: LabelKeys.searchCities.tr,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            )),
                      ),
                    ),
                    Obx(() => Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.only(
                                  top: AppDimens.paddingSmall),
                              restorationId: controller.refreshList.value,
                              itemCount: controller.lstCitySearch.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (controller
                                        .lstCitySearch[index].isSelected!) {
                                      controller.lstCitySearch[index]
                                          .isSelected = false;
                                      controller.lstEmptyCity.removeWhere(
                                          (element) =>
                                              element.id ==
                                              controller
                                                  .lstCitySearch[index].id);
                                    } else {
                                      final isAdded = controller
                                          .lstTripDetailsCityPoll
                                          .where((p0) =>
                                              p0.cityId ==
                                              controller
                                                  .lstCitySearch[index].id);
                                      if (isAdded.toString() == "()") {
                                        controller.lstCitySearch[index]
                                            .isSelected = true;
                                        controller.lstEmptyCity.add(
                                            controller.lstCitySearch[index]);
                                      } else {
                                        controller
                                            .scaffoldMessengerKey.currentState!
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                Get.theme.colorScheme.error,
                                            elevation: 8,
                                            content: Text(
                                              LabelKeys.cityAlreadyAdded.tr,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                    controller.refreshList.value =
                                        getRandomString();
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          margin:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            concatCityName(
                                                controller.lstCitySearch[index]
                                                        .cityName ??
                                                    "",
                                                controller.lstCitySearch[index]
                                                        .stateAbbr ??
                                                    "",
                                                controller.lstCitySearch[index]
                                                        .countryName ??
                                                    "",
                                                controller.lstCitySearch[index]
                                                        .timeZone ??
                                                    ""),
                                            style: onBackGroundTextStyleMedium(
                                                fontSize: AppDimens.textSmall),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: AppDimens.normalIconSize,
                                        width: AppDimens.normalIconSize,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: controller.lstCitySearch[index]
                                                .isSelected!
                                            ? SvgPicture.asset(
                                                IconPath.radioCheckGreen)
                                            : SvgPicture.asset(
                                                IconPath.radioUncheckWhite),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        )),
                    AppDimens.paddingExtraLarge.ph,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget headerImageWidget() {
    return CommonNetworkImage(
      height: 180,
      imageUrl: controller.tripDetailsModel!.tripImgUrl ?? "",
      width: Get.width,
      radius: AppDimens.radiusCorner,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(AppDimens.radiusCorner),
        bottomRight: Radius.circular(AppDimens.radiusCorner),
      ),
      errorWidget: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(AppDimens.radiusCorner),
            child: SvgPicture.asset(IconPath.placeHolderSvg, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  Widget headerImageGradiantLayer() {
    return Container(
      height: 180,
      width: Get.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Get.theme.colorScheme.scrim.withOpacity(0.4),
        Get.theme.colorScheme.scrim.withOpacity(0.4),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    );
  }

  Widget tripNameAndDateOnHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppDimens.paddingLarge),
          child: Text(
            controller.tripDetailsModel!.tripName ?? "",
            style: onPrimaryTextStyleMedium(
              fontSize: AppDimens.textExtraLarge,
              alpha: Constants.darkAlfa,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        controller.tripDetailsModel!.isTripFinalised!
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: AppDimens.paddingLarge),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      IconPath.icCalendar,
                      colorFilter: ColorFilter.mode(
                          Get.theme.colorScheme.surface, BlendMode.srcIn),
                    ),
                    AppDimens.paddingSmall.pw,
                    Text(
                        '${LabelKeys.rsvpBy.tr} ${Date.shared().format(controller.tripDetailsModel!.responseDeadline!)}',
                        style: onPrimaryTextStyleMedium(
                            fontSize: AppDimens.textMedium,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
        AppDimens.paddingSmall.ph
      ],
    );
  }

  Widget premiumTripInfo() {
    return controller.isPremiumTrip.value
        ? Column(
            children: [
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(AppDimens.paddingLarge),
                decoration: BoxDecoration(
                    color: Get.theme.colorScheme.tertiary
                        .withAlpha(Constants.lightAlfa),
                    borderRadius:
                        BorderRadius.circular(AppDimens.paddingMedium),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.dividerColor,
                        blurRadius: AppDimens.paddingNano,
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LabelKeys.premiumFeaturesTripMsg.tr,
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textSmall),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    AppDimens.paddingMedium.ph,
                    Row(
                      children: [
                        SvgPicture.asset(
                          IconPath.premiumKingIcon,
                          colorFilter: ColorFilter.mode(
                              Get.theme.colorScheme.onBackground,
                              BlendMode.srcIn),
                        ),
                        AppDimens.paddingSmall.pw,
                        Text(
                          controller.tripDetailsModel?.createdBy ==
                                  controller.tripDetailsModel?.premiumPlanBy?.id
                              ? "${controller.tripDetailsModel?.premiumPlanBy?.firstName} ${controller.tripDetailsModel?.premiumPlanBy?.lastName} (Host)"
                              : "${controller.tripDetailsModel?.premiumPlanBy?.firstName} ${controller.tripDetailsModel?.premiumPlanBy?.lastName}",
                          style: onBackGroundTextStyleMedium(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppDimens.paddingSmall.pw,
                        SvgPicture.asset(
                          IconPath.premiumKingIcon,
                          colorFilter: ColorFilter.mode(
                              Get.theme.colorScheme.onBackground,
                              BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppDimens.paddingLarge.ph,
            ],
          )
        : const SizedBox();
  }

  Widget tripFinalizingWidget() {
    return controller.tripDetailsModel!.isTripFinalised!
        ? const SizedBox()
        : controller.tCommentController.text == "" &&
                controller.isEditable.value != 1
            ? const SizedBox()
            : Container(
                key: controller.listGlobalKey[2],
                child: PlaceholderContainerWithIcon(
                    widget: CustomTextField(
                        controller: controller.tCommentController,
                        focusNode: controller.tCommentNode,
                        textInputAction: TextInputAction.newline,
                        style: onBackgroundTextStyleRegular(
                            alpha: Constants.lightAlfa),
                        maxLines: 3,
                        maxLength: 250,
                        enabled: controller.isEditable.value == 1,
                        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            hintText: '',
                            hintStyle: onBackgroundTextStyleRegular(
                                alpha: Constants.veryLightAlfa),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                        onFieldSubmitted: (v) {},
                        onChanged: (v) {},
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (v) {
                          if (controller.isTripToFinalised.value == 1) {
                            controller.isTripFinalizingCommentError = true;
                            return CustomTextField.validatorFunction(
                                v!,
                                ValidationTypes.other,
                                LabelKeys.emptyTripComment.tr);
                          } else {
                            controller.isTripFinalizingCommentError = false;
                            return null;
                          }
                        }),
                    titleName: LabelKeys.tripComment.tr),
              );
  }

  Widget tripNameTextView() {
    return controller.isEditable.value == 1
        ? Text(
            LabelKeys.eventTripName.tr,
            style: onBackGroundTextStyleMedium(
              fontSize: AppDimens.textMedium,
              alpha: Constants.darkAlfa,
            ),
            overflow: TextOverflow.ellipsis,
          )
        : const SizedBox();
  }

  Widget tripNameEditText() {
    return controller.isEditable.value == 1
        ? CustomTextField(
            controller: controller.eventNameController,
            focusNode: controller.eNameNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {},
            inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
              hintText: LabelKeys.bachelorParty.tr,
              hintStyle:
                  onBackgroundTextStyleRegular(alpha: Constants.lightAlfa),
              contentPadding: const EdgeInsets.fromLTRB(
                  0, AppDimens.paddingMedium, 0, AppDimens.paddingMedium),
              prefixRightPadding: 0,
              border: const UnderlineInputBorder(),
              isDense: true,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) {
              return CustomTextField.validatorFunction(
                  v!, ValidationTypes.other, LabelKeys.emptyEventTripName.tr);
            })
        : const SizedBox();
  }

  Widget tripDescription() {
    return controller.isEditable.value == 1
        ? Column(
            children: [
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: controller.descController,
                    focusNode: controller.descNode,
                    textInputAction: TextInputAction.done,
                    maxLength: 500,
                    style:
                        onBackgroundTextStyleRegular(alpha: Constants.darkAlfa),
                    maxLines: 3,
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        hintText: LabelKeys.addDescription.tr,
                        contentPadding: const EdgeInsets.fromLTRB(
                            0,
                            AppDimens.paddingMedium,
                            0,
                            AppDimens.paddingMedium),
                        hintStyle: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textMedium,
                            alpha: Constants.veryLightAlfa),
                        border: InputBorder.none,
                        prefixRightPadding: 0,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                    onFieldSubmitted: (v) {},
                    onChanged: (v) {
                      controller.descCount.value =
                          (500 - (v.toString().length)).toString();
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      return CustomTextField.validatorFunction(v!,
                          ValidationTypes.other, LabelKeys.emptyDescription.tr);
                    }),
                titleName: LabelKeys.addDescription.tr,
              ),
              AppDimens.paddingSmall.ph,
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${controller.descCount} ${Constants.characterCountLabel}",
                  style: onBackgroundTextStyleRegular(
                    fontSize: AppDimens.textMedium,
                    alpha: Constants.veryLightAlfa,
                  ),
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LabelKeys.tripDetail.tr,
                style: onBackGroundTextStyleMedium(
                  fontSize: AppDimens.textExtraLarge,
                  alpha: Constants.darkAlfa,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              AppDimens.paddingSmall.ph,
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(AppDimens.paddingLarge),
                decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius:
                        BorderRadius.circular(AppDimens.paddingMedium),
                    border: Border.all(color: Get.theme.dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.dividerColor,
                        blurRadius: AppDimens.paddingNano,
                      ),
                    ]),
                child: Text(controller.tripDetailsModel!.tripDescription ?? "",
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textMedium,
                        alpha: Constants.darkAlfa)),
              ),
            ],
          );
  }

  Widget arrivalTimeWidget() {
    return controller.isEditable.value == 1 &&
            controller.startEndDateText.value.isNotEmpty
        ? arriveWidget(
            controller.startEndDateText.value,
            LabelKeys.arriveBy.tr,
            LabelKeys.leaveAfter.tr,
            controller.arriveByTime.value,
            controller.leaveAfterTime.value, () async {
            hideKeyboard();
            TimeOfDay timeOfDay;
            if (controller.arriveByTime.value != "HH:MM") {
              DateTime parsedDateTime =
                  DateFormat("HH:mm").parse(controller.arriveByTime.value);
              timeOfDay = TimeOfDay.fromDateTime(parsedDateTime);
            } else {
              timeOfDay = TimeOfDay.now();
            }
            final TimeOfDay? pickedTime = await timePicker(timeOfDay);
            final now = DateTime.now();
            DateTime parsedTime = DateTime(now.year, now.month, now.day,
                pickedTime!.hour, pickedTime.minute);
            String formattedTime = DateFormat("hh:mm a").format(parsedTime);
            controller.updateTimeForFinalizingDate(true, pickedTime);
            controller.arriveByTime.value = formattedTime;
          }, () async {
            hideKeyboard();
            TimeOfDay timeOfDay;
            if (controller.leaveAfterTime.value != "HH:MM") {
              timeOfDay = TimeOfDay.fromDateTime(
                  DateFormat("HH:mm").parse(controller.leaveAfterTime.value));
            } else {
              timeOfDay = TimeOfDay.now();
            }
            final TimeOfDay? pickedTime = await timePicker(timeOfDay);
            final now = DateTime.now();
            DateTime parsedTime = DateTime(now.year, now.month, now.day,
                pickedTime!.hour, pickedTime.minute);
            String formattedTime = DateFormat("hh:mm a").format(parsedTime);
            controller.updateTimeForFinalizingDate(false, pickedTime);
            controller.leaveAfterTime.value = formattedTime;
          })
        : controller.tripDetailsModel!.isTripFinalised!
            ? arriveWidget(
                '${Date.shared().format(controller.tripDetailsModel!.tripFinalStartDate!)} to ${Date.shared().format(controller.tripDetailsModel!.tripFinalEndDate!)}',
                LabelKeys.arriveBy.tr,
                LabelKeys.leaveAfter.tr,
                //'',
                Date.shared().convertFormatToFormat(
                    controller.tripDetailsModel!.tripFinalStartDate!,
                    'yyyy-MM-dd hh:mm:ss',
                    'hh:mm a'),
                Date.shared().convertFormatToFormat(
                    controller.tripDetailsModel!.tripFinalEndDate!,
                    'yyyy-MM-dd hh:mm:ss',
                    'hh:mm a'),
                () async {},
                () async {})
            : const SizedBox();
  }

  Widget featuresTextView() {
    return Text(LabelKeys.features.tr,
        style: onBackGroundTextStyleMedium(
            fontSize: AppDimens.textExtraLarge, alpha: Constants.darkAlfa),
        overflow: TextOverflow.ellipsis);
  }

  Widget responseDeadLineDatePicker() {
    return controller.isEditable.value == 1
        ? GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await datePicker(
                firstDate: controller.isDate1BeforeDate2(
                        Date.shared().getDateTimeFromString(
                            controller.oldResponseDeadLine,
                            format: "yyyy/MM/dd"),
                        DateTime.now())
                    ? Date.shared().getDateTimeFromString(
                        controller.oldResponseDeadLine,
                        format: "yyyy/MM/dd")
                    : DateTime.now(),
              );
              pickedDate = pickedDate
                  ?.add(const Duration(hours: 23, minutes: 59, seconds: 59));
              if (pickedDate != null) {
                final String strPickedDate =
                    DateFormat("yyyy/MM/dd HH:mm:ss").format(pickedDate);
                controller.isSelectedReminder.value = true;
                controller.maxReminderDays.value = Date.shared()
                    .datesDifferenceInDay(DateTime.now(), pickedDate);
                if (controller.noOfReminderDays.value >
                    controller.maxReminderDays.value) {
                  controller.noOfReminderDays.value = 0;
                }
                controller.onDate.value = strPickedDate;
                controller.onDateUTC = DateFormat("yyyy/MM/dd HH:mm:ss")
                    .format(pickedDate.toUtc());
              }
            },
            child: PlaceholderContainerWithIcon(
              iconPath: IconPath.icCalendar,
              titleName: LabelKeys.responseDeadline.tr,
              widget: Text(
                "${DateFormat('yyyy/MM/dd').format(Date.shared().getDateTimeFromString(controller.onDate.value, format: 'yyyy/MM/dd'))}, ${Date.shared().getDayName(controller.onDate.value, 'yyyy/MM/dd')}",
                style: onBackgroundTextStyleRegular(
                    alpha: Constants.veryLightAlfa),
              ),
              endWidget: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(IconPath.downArrow),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget displayImageWidget() {
    return controller.isEditable.value == 1
        ? GestureDetector(
            onTap: () async {
              final result =
                  await Get.toNamed(Routes.SELECT_TRIP_IMAGE, arguments: [
                controller.selectedTripImageURL.value.isNotEmpty
                    ? controller.selectedTripImageURL.value
                    : "",
                1
              ]);
              if (result != null) {
                controller.selectedTripImageURL.value = result;
              }
              Get.focusScope?.unfocus();
            },
            child: PlaceholderContainerWithIcon(
              iconPath: IconPath.galleryMix,
              titleName: LabelKeys.selectDisplayImage.tr,
              widget: Text(
                getFileNameFromURL(controller.selectedTripImageURL.value),
                style: onBackgroundTextStyleRegular(
                    alpha: Constants.veryLightAlfa),
              ),
              endWidget: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(IconPath.forwardArrow),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget groupChatGridItem() {
    return GestureDetector(
      onTap: () {
        if (controller.tripDetailsModel!.isPaid == 0 ||
            controller.tripDetailsModel!.isPaid == null) {
          for (int i = 0; i < controller.lstSingleTripPlanModel.length; i++) {
            controller.lstSingleTripPlanModel[i].isSelected = false;
          }
          controller.lstSingleTripPlanModel[0].isSelected = true;
          controller.openSubscriptionBottomSheet(
              singleTripPlanModel: controller.lstSingleTripPlanModel[0]);
        } else {
          Get.toNamed(Routes.CHAT_DETAILS_SCREEN,
              arguments: [controller.tripId, 'groupChat']);
        }
      },
      child: gridItem(controller.getWidth(), IconPath.chatIconMixPremium,
          LabelKeys.groupChat.tr, true),
    );
  }

  Widget activitiesGridItem() {
    return GestureDetector(
      onTap: () {
        if (controller.tripDetailsModel!.isPaid == 0 ||
            controller.tripDetailsModel!.isPaid == null) {
          for (int i = 0; i < controller.lstSingleTripPlanModel.length; i++) {
            controller.lstSingleTripPlanModel[i].isSelected = false;
          }
          controller.lstSingleTripPlanModel[2].isSelected = true;
          controller.openSubscriptionBottomSheet(
              singleTripPlanModel: controller.lstSingleTripPlanModel[2]);
        } else {
          gc.resetActivityFilters();
          Get.toNamed(Routes.ACTIVITIES_DETAIL,
              arguments: [controller.tripDetailsModel!.id!]);
        }
      },
      child: gridItem(controller.getWidth(), IconPath.menuMixPremium,
          LabelKeys.activities.tr, true),
    );
  }

  Widget groupExpenseGridItem() {
    return GestureDetector(
      onTap: () {
        if (controller.tripDetailsModel!.isPaid == 0 ||
            controller.tripDetailsModel!.isPaid == null) {
          for (int i = 0; i < controller.lstSingleTripPlanModel.length; i++) {
            controller.lstSingleTripPlanModel[i].isSelected = false;
          }
          controller.lstSingleTripPlanModel[1].isSelected = true;
          controller.openSubscriptionBottomSheet(
              singleTripPlanModel: controller.lstSingleTripPlanModel[1]);
        } else {
          gc.loginData.value.paypalUsername == "" &&
                  gc.loginData.value.venmoUsername == ""
              ? Get.bottomSheet(
                  isScrollControlled: true,
                  BottomSheetWithClose(
                    widget: venmoPaypalBottomSheet(),
                  ),
                )
              : Get.toNamed(Routes.EXPANSE_RESOLUTION_TABS,
                  arguments: [controller.tripDetailsModel!.id]);
        }
      },
      child: gridItem(controller.getWidth(), IconPath.walletMixPremium,
          LabelKeys.groupExpenses.tr, true),
    );
  }

  Widget guestListGridItem() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.ADDED_GUEST_LIST, arguments: [
          controller.tripDetailsModel,
          Constants.fromTripDetail,
          controller.tripDetailsModel?.createdBy
        ])?.then((value) {
          controller.getTripDetails(true);
        });
      },
      child: gridItem(
          controller.getWidth(),
          IconPath.userMix,
          "${LabelKeys.guestList.tr} (${controller.tripDetailsModel!.guestCount!})",
          false),
    );
  }

  Widget tripPhotosGridItem() {
    return GestureDetector(
      onTap: () async {
        if (controller.tripDetailsModel!.isPaid == 0 ||
            controller.tripDetailsModel!.isPaid == null) {
          for (int i = 0; i < controller.lstSingleTripPlanModel.length; i++) {
            controller.lstSingleTripPlanModel[i].isSelected = false;
          }
          controller.lstSingleTripPlanModel[4].isSelected = true;
          controller.openSubscriptionBottomSheet(
              singleTripPlanModel: controller.lstSingleTripPlanModel[4]);
        } else {
          await Get.toNamed(Routes.TRIP_MEMORIES_SCREEN, arguments: [
            controller.tripDetailsModel!.id,
            controller.tripDetailsModel!.role,
            controller.tripDetailsModel!.dropboxUrl ?? ""
          ]);
          controller.getTripDetails(true);
        }
      },
      child: gridItem(controller.getWidth(), IconPath.cameraMixPremium,
          LabelKeys.tripPhotos.tr, true),
    );
  }

  Widget documentsGridItem() {
    return GestureDetector(
      onTap: () {
        if (controller.tripDetailsModel!.isPaid == 0 ||
            controller.tripDetailsModel!.isPaid == null) {
          for (int i = 0; i < controller.lstSingleTripPlanModel.length; i++) {
            controller.lstSingleTripPlanModel[i].isSelected = false;
          }
          controller.lstSingleTripPlanModel[3].isSelected = true;
          controller.openSubscriptionBottomSheet(
              singleTripPlanModel: controller.lstSingleTripPlanModel[3]);
        } else {
          Get.toNamed(Routes.DOCUMENTS,
              arguments: controller.tripDetailsModel!.id);
        }
      },
      child: gridItem(controller.getWidth(), IconPath.copyMixPremium,
          LabelKeys.documents.tr, true),
    );
  }

  Widget addToCalenderGridItem() {
    return controller.tripDetailsModel!.isTripFinalised!
        ? GestureDetector(
            onTap: () {
              controller.tripDetailsModel!.isTripFinalised!
                  ? controller.createCalendar()
                  : RequestManager.getSnackToast(
                      message: LabelKeys.tripIsNotFinalized.tr);
            },
            child: gridItem(controller.getWidth(), IconPath.calendarMix,
                LabelKeys.addEvent.tr, false),
          )
        : const SizedBox();
  }

  Widget saveOrFinalizeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: MasterButtonsBounceEffect.gradiantButton(
            btnText: LabelKeys.finalize.tr,
            onPressed: () {
              controller.finalizeButtonClick();
            },
          ),
        ),
        AppDimens.paddingLarge.pw,
        Expanded(
          flex: 1,
          child: MasterButtonsBounceEffect.gradiantButton(
            btnText: LabelKeys.save.tr,
            onPressed: () {
              controller.saveButtonClicked();
            },
          ),
        ),
      ],
    );
  }

  Widget inOutButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: MasterButtonsBounceEffect.gradiantButton(
            btnText: LabelKeys.imOut.tr,
            gradiantColors: [
              Get.theme.colorScheme.error,
              Get.theme.colorScheme.error
            ],
            onPressed: () {
              Get.bottomSheet(
                isScrollControlled: true,
                BottomSheetWithClose(widget: iAmOutBottomSheet()),
              );
            },
          ),
        ),
        AppDimens.paddingLarge.pw,
        Expanded(
          flex: 1,
          child: MasterButtonsBounceEffect.gradiantButton(
            btnText: controller.tripDetailsModel!.inviteStatus ==
                    LabelKeys.approved.tr
                ? LabelKeys.save.tr
                : LabelKeys.imIn.tr,
            onPressed: () {
              /// Check if any of city or date option selected
              controller.updateUserStatus(InviteStatus.approved);
            },
          ),
        ),
      ],
    );
  }

  Widget deleteTripActionMenu() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          isScrollControlled: true,
          BottomSheetWithClose(
            widget: deleteConfirmationBottomSheet(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingSmall),
        child: SvgPicture.asset(
          IconPath.deleteIcon,
          colorFilter: ColorFilter.mode(
              Get.theme.colorScheme.onPrimary, BlendMode.srcIn),
        ),
      ),
    );
  }

  Widget groupChatActionMenu() {
    return GestureDetector(
      onTap: () {
        if (controller.tripDetailsModel!.isPaid == 0 ||
            controller.tripDetailsModel!.isPaid == null) {
          for (int i = 0; i < controller.lstSingleTripPlanModel.length; i++) {
            controller.lstSingleTripPlanModel[i].isSelected = false;
          }
          controller.lstSingleTripPlanModel[0].isSelected = true;
          controller.openSubscriptionBottomSheet(
              singleTripPlanModel: controller.lstSingleTripPlanModel[0]);
        } else {
          Get.toNamed(Routes.CHAT_DETAILS_SCREEN,
              arguments: [controller.tripDetailsModel!.id, 'groupChat']);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        child: SvgPicture.asset(
          IconPath.chatIconMix,
          colorFilter: ColorFilter.mode(
              Get.theme.colorScheme.onPrimary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
