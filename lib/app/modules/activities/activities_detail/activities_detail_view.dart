import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/models/activity_details_model.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/session/preference.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/networking/request_manager.dart';
import 'activities_detail_controller.dart';

class ActivitiesDetailView extends GetView<ActivitiesDetailController> {
  const ActivitiesDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: WillPopScope(
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
              leadingWidth: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              isCustomTitle: true,
              customTitleWidget: CustomAppBar.backButton(onBack: () {
                if (Preference.isGetNotification()) {
                  Get.offAllNamed(Routes.DASHBOARD);
                } else {
                  Get.back();
                }
              }),
              actionWidget: [
                GestureDetector(
                    onTap: () {
                      controller.toggleSearchView();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingMedium),
                      child: SvgPicture.asset(
                        IconPath.searchIcon,
                        colorFilter: ColorFilter.mode(
                            Get.theme.colorScheme.onBackground,
                            BlendMode.srcIn),
                      ),
                    )),
                GestureDetector(
                  onTap: () async {
                    var data = await Get.toNamed(Routes.FILTER);
                    controller.filters = data['value1'].value;
                    controller.sortBy = data['value2'].value;
                    controller.filters.isNotEmpty
                        ? controller.isFilterApplied.value = true
                        : controller.isFilterApplied.value = false;
                    controller.callActivitiesListApi(true);
                  },
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingMedium),
                      child: Stack(children: [
                        SvgPicture.asset(IconPath.filterIcon),
                        controller.isFilterApplied.value
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: SvgPicture.asset(IconPath.badgeIcon),
                              )
                            : const SizedBox()
                      ]),
                    ),
                  ),
                ),
              ]),
          body: Obx(
            () => controller.isDataLoaded.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.isSearchViewVisible.value) {
                          return openSearchView(controller.getFilters(),
                              controller.getSortByFilter());
                        } else {
                          return const SizedBox(); // Return an empty SizedBox if not visible
                        }
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingLarge),
                        child: Text(controller.tripDetailsModel.tripName!,
                            style: onBackGroundTextStyleMedium(
                                fontSize: AppDimens.textExtraLarge,
                                alpha: Constants.darkAlfa),
                            overflow: TextOverflow.ellipsis),
                      ),
                      AppDimens.paddingSmall.ph,
                      controller.tripDetailsModel.isTripFinalised!
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.paddingLarge),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    IconPath.icCalendar,
                                    colorFilter: ColorFilter.mode(
                                        Get.theme.colorScheme.primary,
                                        BlendMode.srcIn),
                                  ),
                                  AppDimens.paddingSmall.pw,
                                  Text(
                                      "${Date.shared().convertFormatToFormat(controller.tripDetailsModel.tripFinalStartDate!, "yyyy-MM-dd hh:mm:ss", "MMM dd")} - ${Date.shared().convertFormatToFormat(controller.tripDetailsModel.tripFinalEndDate!, "yyyy-MM-dd hh:mm:ss", "MMM dd")}",
                                      style: onBackGroundTextStyleMedium(
                                          fontSize: AppDimens.textMedium,
                                          alpha: Constants.darkAlfa),
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      AppDimens.paddingLarge.ph,
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(AppDimens.radiusCircle),
                                topRight:
                                    Radius.circular(AppDimens.radiusCircle)),
                          ),
                          color: Get.theme.colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: AppDimens.paddingLarge,
                                right: AppDimens.paddingLarge,
                                top: AppDimens.paddingMedium),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TabBar(
                                  controller: controller.tabController,
                                  labelColor: Get.theme.colorScheme.primary,
                                  unselectedLabelColor:
                                      Get.theme.colorScheme.background,
                                  indicatorColor: Get.theme.colorScheme.primary,
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  labelStyle: onBackGroundTextStyleMedium(
                                    fontSize: AppDimens.textMedium,
                                  ),
                                  onTap: (index) {
                                    if (controller.isSearchViewVisible.value) {
                                      controller.toggleSearchView();
                                    }
                                    controller.searchTextEditController.text =
                                        "";

                                    controller.selectedTab = selectedTab(index);
                                    controller.activitiesList.value.clear();
                                    controller.isListAvailable.value = true;
                                    controller.getFilters();
                                    controller.getSortByFilter();
                                    controller.callActivitiesListApi(true);
                                  },
                                  unselectedLabelStyle:
                                      onBackgroundTextStyleRegular(
                                          fontSize: AppDimens.textMedium,
                                          alpha: Constants.darkAlfa),
                                  tabs: [
                                    Tab(
                                      text: LabelKeys.tripItinerary.tr,
                                    ),
                                    Tab(
                                      text: LabelKeys.others.tr,
                                    ),
                                    Tab(
                                      text: LabelKeys.ideas.tr,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  color: Get.theme.colorScheme.onBackground
                                      .withAlpha(Constants.limit),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: controller.tabController,
                                    children: [
                                      // Trip Itinerary Tab
                                      Obx(() {
                                        return controller.isListAvailable.value
                                            ? Obx(() => trip())
                                            : const NoRecordFound();
                                      }),

                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Obx(
                                            () =>
                                                controller.isListAvailable.value
                                                    ? Obx(() => others())
                                                    : const NoRecordFound(),
                                          ),
                                          Positioned(
                                            bottom: 25,
                                            left: 0,
                                            right: 0,
                                            child: MasterButtonsBounceEffect
                                                .gradiantButton(
                                              btnText:
                                                  LabelKeys.addActivities.tr,
                                              onPressed: () async {
                                                await Get.toNamed(
                                                    Routes
                                                        .ADD_ACTIVITIES_SCREEN,
                                                    arguments: [
                                                      "",
                                                      controller.tripID.value,
                                                      null
                                                    ]);
                                                controller.selectedTab =
                                                    "others";
                                                //controller.filters = data['value1'];
                                                controller.sortBy =
                                                    ShortBy.upcoming;
                                                controller
                                                    .callActivitiesListApi(
                                                        true);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Obx(
                                            () =>
                                                controller.isListAvailable.value
                                                    ? Obx(
                                                        () => ideas(),
                                                      )
                                                    : const NoRecordFound(),
                                          ),
                                          Positioned(
                                            bottom: 25,
                                            left: 0,
                                            right: 0,
                                            child: addActivityButton(),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget openSearchView(List<String> filters, String sortByFilter) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimens.paddingLarge, right: AppDimens.paddingLarge),
      child: CustomTextField(
        controller: controller.searchTextEditController,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          controller.customDebouncer.run(() {
            if (controller.searchText != value) {
              controller.searchText = value;
              controller.filters = filters;
              controller.sortBy = sortByFilter;
              controller.callActivitiesListApi(true);
            }
          });
        },
        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
          hintText: LabelKeys.searchActivities.tr,
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Get.theme.colorScheme.onBackground
                    .withAlpha(Constants.limit)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Get.theme.colorScheme.onBackground
                    .withAlpha(Constants.limit)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Get.theme.colorScheme.onBackground
                    .withAlpha(Constants.limit)),
          ),
          contentPadding: const EdgeInsets.all(AppDimens.paddingMedium),
          isDense: false,
          prefixIconConstraints: const BoxConstraints(maxHeight: 60),
          suffixIconConstraints: const BoxConstraints(maxHeight: 60),
          suffixIcon: GestureDetector(
            onTap: () {
              controller.searchTextEditController.text = "";
              controller.searchText = "";
              controller.isSearchViewVisible.value = false;
              controller.filters = filters;
              controller.sortBy = sortByFilter;
              controller.callActivitiesListApi(true);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                IconPath.closeRoundedIcon,
              ),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              IconPath.searchIcon,
              height: AppDimens.normalIconSize,
              width: AppDimens.normalIconSize,
              colorFilter: ColorFilter.mode(
                  Get.theme.colorScheme.outline, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }

  String selectedTab(int index) {
    String type;
    if (index == 0) {
      type = "itineary";
    } else if (index == 1) {
      type = "others";
    } else {
      type = "ideas";
    }
    return type;
  }

  Widget trip() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(
              backgroundColor: Get.theme.colorScheme.primary,
            ),
            controller: controller.itineraryController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.paddingLarge,
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.activitiesList.value.length,
                restorationId: controller.restorationId.value,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return itemTrip(index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget others() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(
              backgroundColor: Get.theme.colorScheme.primary,
            ),
            controller: controller.othersController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.padding90),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.activitiesList.value.length,
                restorationId: controller.restorationId.value,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return itemOthers(index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ideas() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(
              backgroundColor: Get.theme.colorScheme.primary,
            ),
            controller: controller.ideasController,
            onRefresh: controller.onRefresh,
            onLoading: controller.onLoading,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.padding90),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.activitiesList.value.length,
                restorationId: controller.restorationId.value,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return itemIdeas(index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemTrip(int index) {
    return GestureDetector(
      onTap: () {
        controller.openOthersBottomSheet(
            activityDetailsModel: controller.activitiesList[index]);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        margin: const EdgeInsets.only(top: AppDimens.paddingLarge),
        decoration: BoxDecoration(
            border: Border.all(
              width: AppDimens.paddingNano,
              color: Get.theme.colorScheme.background
                  .withAlpha(Constants.veryLightAlfa),
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.paddingMedium))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.activitiesList[index].name!,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textMedium,
                        alpha: Constants.darkAlfa),
                    overflow: TextOverflow.ellipsis),
                //checkActivityCreatedBy(index)
                controller.tripDetailsModel.role == Role.host ||
                        controller.tripDetailsModel.isCoHost == 1
                    ? popupMenu(
                        "itineary", controller.activitiesList[index], index)
                    : const SizedBox(),
              ],
            ),
            AppDimens.paddingTiny.ph,
            Text(
                DateFormat("MMM dd, yyyy").format(DateTime.parse(
                    controller.activitiesList[index].eventDate.toString())),
                style: onBackgroundTextStyleRegular(
                    fontSize: AppDimens.textMedium,
                    alpha: Constants.veryLightAlfa),
                overflow: TextOverflow.ellipsis),
            AppDimens.paddingMedium.ph,
            Padding(
              padding:
                  const EdgeInsets.only(right: AppDimens.paddingExtraLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(
                          controller.activitiesList[index].eventTime
                              .toString())),
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.veryLightAlfa),
                      overflow: TextOverflow.ellipsis),
                  SvgPicture.asset(IconPath.arrowLong),
                  Text(
                      DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(
                          controller.activitiesList[index].checkoutTime
                              .toString())),
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.veryLightAlfa),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            AppDimens.paddingMedium.ph,
          ],
        ),
      ),
    );
  }

  Widget itemOthers(int index) {
    return GestureDetector(
      onTap: () {
        controller.openOthersBottomSheet(
            activityDetailsModel: controller.activitiesList[index]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingMedium,
            horizontal: AppDimens.paddingMedium),
        margin: const EdgeInsets.only(top: AppDimens.paddingLarge),
        decoration: BoxDecoration(
            border: Border.all(
              width: AppDimens.paddingNano,
              color: Get.theme.colorScheme.background
                  .withAlpha(Constants.veryLightAlfa),
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.paddingMedium))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      IconPath.icCalendar,
                      colorFilter: ColorFilter.mode(
                          Get.theme.colorScheme.onBackground, BlendMode.srcIn),
                    ),
                    AppDimens.paddingSmall.pw,
                    Text(
                        DateFormat("MMM dd, yyyy").format(DateTime.parse(
                            controller.activitiesList[index].eventDate
                                .toString())),
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textMedium,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
                AppDimens.paddingMedium.ph,
                Padding(
                  padding: const EdgeInsets.only(left: AppDimens.paddingSmall),
                  child: Text(controller.activitiesList[index].createdBy!,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.darkAlfa),
                      overflow: TextOverflow.ellipsis),
                ),
                AppDimens.paddingMedium.ph,
                Padding(
                  padding: const EdgeInsets.only(left: AppDimens.paddingSmall),
                  child: Text(controller.activitiesList[index].name!,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textSmall,
                          alpha: Constants.darkAlfa),
                      overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: AppDimens.paddingSmall),
                  child: controller.activitiesList[index].activityType! ==
                          'hotel'
                      ? Text(
                          '${LabelKeys.checkInActivity.tr} ${DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(controller.activitiesList[index].eventTime.toString()))}\nVia ${controller.activitiesList[index].address}',
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textSmall,
                              alpha: Constants.darkAlfa),
                          overflow: TextOverflow.ellipsis)
                      : Text(
                          '${LabelKeys.arrivalTimeActivity.tr} ${DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(controller.activitiesList[index].eventTime.toString()))}',
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textSmall,
                              alpha: Constants.darkAlfa),
                          overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            checkActivityCreatedBy(index)
                ? popupMenu("other", controller.activitiesList[index], index)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget itemIdeas(int index) {
    return GestureDetector(
      onTap: () {
        controller.openOthersBottomSheet(
            activityDetailsModel: controller.activitiesList[index]);
      },
      child: Container(
        margin: const EdgeInsets.only(top: AppDimens.paddingLarge),
        decoration: BoxDecoration(
            border: Border.all(
              width: AppDimens.paddingNano,
              color: Get.theme.colorScheme.background
                  .withAlpha(Constants.veryLightAlfa),
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.paddingMedium))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDimens.paddingExtraLarge.ph,
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.activitiesList[index].name!,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.darkAlfa),
                      overflow: TextOverflow.ellipsis),
                  Row(
                    children: [
                      SvgPicture.asset(IconPath.smileyKeyIcon),
                      AppDimens.paddingMedium.pw,
                      checkActivityCreatedBy(index)
                          ? popupMenu(
                              "ideas", controller.activitiesList[index], index)
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: Text(
                  DateFormat("MMM dd, yyyy").format(DateTime.parse(
                      controller.activitiesList[index].eventDate.toString())),
                  style: onBackgroundTextStyleRegular(
                      fontSize: AppDimens.textMedium,
                      alpha: Constants.veryLightAlfa),
                  overflow: TextOverflow.ellipsis),
            ),
            AppDimens.paddingMedium.ph,
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(
                          controller.activitiesList[index].eventTime
                              .toString())),
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.veryLightAlfa),
                      overflow: TextOverflow.ellipsis),
                  SvgPicture.asset(IconPath.arrowLong),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: AppDimens.onBoardingTitleHeight),
                    child: Text(
                        DateFormat('hh:mm a').format(DateFormat('HH:mm:ss')
                            .parse(controller.activitiesList[index].checkoutTime
                                .toString())),
                        style: onBackgroundTextStyleRegular(
                            fontSize: AppDimens.textMedium,
                            alpha: Constants.veryLightAlfa),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            AppDimens.paddingMedium.ph,
            Divider(
              thickness: 1,
              color: Get.theme.dividerColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controller.tripDetailsModel.role == Role.host ||
                          controller.tripDetailsModel.isCoHost == 1
                      ? GestureDetector(
                          onTap: () {
                            controller.makeItineary(
                                controller.activitiesList[index].id.toString(),
                                "1",
                                index);
                          },
                          child: Text(LabelKeys.moveToTrip.tr,
                              style: generalTextStyleMedium(
                                  fontSize: AppDimens.textMedium,
                                  color: Get.theme.primaryColor
                                      .withAlpha(Constants.mediumAlfa)),
                              overflow: TextOverflow.ellipsis),
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.likeDislikeIdeas(
                              controller.activitiesList[index].id.toString(),
                              "1",
                              index); //LIKE IDEAS
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.paddingSmall),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        AppDimens.paddingExtraLarge)),
                                color: Get.theme.colorScheme.primary
                                    .withAlpha(Constants.bounceDuration)),
                            child: Obx(() => Row(
                                  children: [
                                    controller.activitiesList[index]
                                                .likeCount ==
                                            0
                                        ? SvgPicture.asset(
                                            IconPath.thumbupWhiteIcon)
                                        : SvgPicture.asset(
                                            IconPath.thumbsupGreen),
                                    Text(
                                        controller
                                            .activitiesList[index].likeCount
                                            .toString(),
                                        style: primaryTextStyleMedium(
                                            fontSize: AppDimens.textMedium,
                                            alpha: Constants.darkAlfa),
                                        overflow: TextOverflow.ellipsis),
                                    AppDimens.paddingSmall.pw,
                                  ],
                                ))),
                      ),
                      AppDimens.paddingSmall.pw,
                      GestureDetector(
                        onTap: () {
                          controller.likeDislikeIdeas(
                              controller.activitiesList[index].id.toString(),
                              "0",
                              index);
                          //DISLIKE IDEA
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingSmall),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppDimens.paddingExtraLarge)),
                              color: Get.theme.colorScheme.error
                                  .withAlpha(Constants.bounceDuration)),
                          child: Obx(
                            () => Row(
                              children: [
                                controller.activitiesList[index].dislikeCount ==
                                        0
                                    ? SvgPicture.asset(IconPath.thumbdownIcon)
                                    : SvgPicture.asset(IconPath.thumbdownRed),
                                Text(
                                    controller
                                        .activitiesList[index].dislikeCount
                                        .toString(),
                                    style: generalTextStyleMedium(
                                        fontSize: AppDimens.textMedium,
                                        color: Get.theme.colorScheme.error),
                                    overflow: TextOverflow.ellipsis),
                                AppDimens.paddingSmall.pw,
                              ],
                            ),
                          ),
                        ),
                      ),
                      //SvgPicture.asset(IconPath.thumbdownRed),
                    ],
                  )
                ],
              ),
            ),
            AppDimens.paddingMedium.ph,
          ],
        ),
      ),
    );
  }

  Widget popupMenu(
          String type, ActivityDetailsModel activityDetailsModel, int index) =>
      Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: PopupMenuButton<int>(
          elevation: 1,
          padding: EdgeInsets.zero,
          shadowColor: Get.theme.colorScheme.onBackground,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
          itemBuilder: (context) => [
            PopupMenuItem(
              height: AppDimens.padding3XLarge,
              value: 1,
              onTap: () {
                SchedulerBinding.instance.addPostFrameCallback((_) async {
                  Get.toNamed(Routes.ADD_ACTIVITIES_SCREEN, arguments: [
                    controller.activitiesList[index].id.toString(),
                    activityDetailsModel.toJson()["trip_id"],
                    activityDetailsModel.toJson()
                  ])?.then((value) => controller.callActivitiesListApi(true));
                });
              },
              child: itemMenu(LabelKeys.edit.tr, IconPath.edit),
            ),
            PopupMenuItem(
              height: AppDimens.padding3XLarge,
              value: 2,
              onTap: () {
                controller.deleteActivity(
                    controller.activitiesList[index].id.toString(), index);
              },
              child: itemMenu(LabelKeys.delete.tr, IconPath.deleteIcon),
            ),
          ],
          child: SvgPicture.asset(IconPath.moreIcon),
        ),
      );

  Widget itemMenu(String title, String icon) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        AppDimens.paddingSmall.pw,
        Text(title,
            style: generalTextStyleMedium(
                color: Get.theme.colorScheme.onBackground
                    .withAlpha(Constants.darkAlfa),
                fontSize: AppDimens.textSmall)),
      ],
    );
  }

  checkActivityCreatedBy(int index) {
    /*String fullName =
        '${gc.loginData.value.firstName} ${gc.loginData.value.lastName}';
    if (fullName == controller.activitiesList[index].createdBy) {
      return true;
    } else {
      return false;
    }*/
    if (gc.loginData.value.id == controller.activitiesList[index].userId) {
      return true;
    } else {
      return false;
    }
  }

  Widget addActivityButton() {
    return MasterButtonsBounceEffect.gradiantButton(
      btnText: LabelKeys.addActivities.tr,
      onPressed: () async {
        await Get.toNamed(Routes.ADD_ACTIVITIES_SCREEN,
            arguments: ["", controller.tripID.value, null]);
        controller.selectedTab = "ideas";
        controller.sortBy = ShortBy.upcoming;
        controller.callActivitiesListApi(true);
      },
    );
  }
}
