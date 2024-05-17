import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/notification_list.dart';
import 'package:lesgo/app/modules/common_widgets/bottomsheet_with_close.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        gc.loginData.value.notificationCount = 0;
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
            leadingWidth: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            isCustomTitle: true,
            customTitleWidget: InkWell(
              onTap: () {
                gc.loginData.value.notificationCount = 0;
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
            actionWidget: [
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    isScrollControlled: true,
                    BottomSheetWithClose(widget: successBottomSheet()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: AppDimens.paddingExtraLarge,
                      top: AppDimens.paddingMedium),
                  child: Text(LabelKeys.clearAll.tr,
                      style: generalTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                          color: Get.theme.primaryColor),
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppDimens.paddingExtraLarge,
                      right: AppDimens.paddingSmall),
                  child: Text(LabelKeys.notifications.tr,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textExtraLarge,
                          alpha: Constants.darkAlfa),
                      overflow: TextOverflow.ellipsis),
                ),
                Obx(() => gc.loginData.value.notificationCount == 0
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.all(AppDimens.paddingSmall),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Get.theme.colorScheme.onBackground),
                          color: Get.theme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                            gc.loginData.value.notificationCount == null ||
                                    controller.rNotId.value.isEmpty
                                ? ""
                                : gc.loginData.value.notificationCount
                                    .toString(),
                            style: generalTextStyleMedium(
                                fontSize: AppDimens.textSmall,
                                color: Get.theme.colorScheme.background),
                            overflow: TextOverflow.ellipsis),
                      ))
              ],
            ),
            AppDimens.paddingMedium.ph,
            Expanded(
                child: ContainerTopRoundedCorner(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingExtraLarge),
                child: Obx(() => controller.notificationFetch.value
                    ? SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: false,
                        header: WaterDropMaterialHeader(
                          backgroundColor: Get.theme.colorScheme.primary,
                        ),
                        controller: controller.notificationController,
                        onRefresh: controller.onRefresh,
                        onLoading: controller.onLoading,
                        child: ListView.builder(
                            itemCount: controller.newList!.length,
                            restorationId: controller.rNotId.value,
                            shrinkWrap: true,
                            itemBuilder: (context, indexFirst) {
                              String? category = controller.newList!.keys
                                  .elementAt(indexFirst);
                              final dateTime =
                                  Date.shared().dateConverter(category!);
                              List<NotificationList> itemsInCategory =
                                  controller.newList![category]!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: AppDimens.paddingMedium),
                                      child: Text(
                                        dateTime,
                                        style: onBackGroundTextStyleMedium(
                                            alpha: Constants.veryLightAlfa),
                                      )),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: itemsInCategory.length,
                                    restorationId: controller.rNotId.value,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return itemBuild(
                                          context, index, itemsInCategory);
                                    },
                                  )
                                ],
                              );
                            }),
                      )
                    : controller.isDataLoading.value
                        ? SizedBox(
                            width: Get.width,
                          )
                        : const NoRecordFound()),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget itemBuild(
      BuildContext context, int index, List<NotificationList> itemsInCategory) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deleteNotification(itemsInCategory[index].id!, index);
      },
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
        alignment: AlignmentDirectional.centerEnd,
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.paddingLarge)),
          color:
              Get.theme.colorScheme.error.withAlpha(Constants.bounceDuration),
        ),
        child: Container(
            padding: const EdgeInsets.all(AppDimens.paddingSmall),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.paddingSmall)),
              color: Get.theme.colorScheme.error
                  .withAlpha(Constants.bounceDuration),
            ),
            child: SvgPicture.asset(IconPath.delIcon)),
      ),
      key: UniqueKey(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(AppDimens.paddingLarge),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.paddingLarge)),
                    color: Get.theme.colorScheme.primary,
                  ),
                  child: SvgPicture.asset(IconPath.notificationIcon)),
              AppDimens.paddingMedium.pw,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemsInCategory[index].title ?? "",
                          textAlign: TextAlign.center,
                          style: itemsInCategory[index].isRead == 0
                              ? onBackgroundTextStyleSemiBold(
                                  fontSize: AppDimens.textSmall,
                                  alpha: Constants.darkAlfa)
                              : onBackGroundTextStyleMedium(
                                  fontSize: AppDimens.textSmall,
                                  alpha: Constants.darkAlfa),
                        ),
                        Text(
                          Date.shared()
                              .convertToAgo(itemsInCategory[index].createdAt!),
                          textAlign: TextAlign.center,
                          style: itemsInCategory[index].isRead == 0
                              ? onBackgroundTextStyleSemiBold(
                                  fontSize: AppDimens.textTiny,
                                  alpha: Constants.darkAlfa)
                              : onBackgroundTextStyleRegular(
                                  fontSize: AppDimens.textTiny,
                                  alpha: Constants.veryLightAlfa),
                        ),
                      ],
                    ),
                    AppDimens.paddingSmall.ph,
                    Text(
                      itemsInCategory[index].message!,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: itemsInCategory[index].isRead == 0
                          ? onBackgroundTextStyleSemiBold(
                              fontSize: AppDimens.textSmall,
                              alpha: Constants.darkAlfa)
                          : onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textSmall,
                              alpha: Constants.veryLightAlfa),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Get.theme.colorScheme.onBackground
                .withAlpha(Constants.bounceDuration),
          )
        ],
      ),
    );
  }

  successBottomSheet() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LabelKeys.areYouSureWantDelete.tr,
            style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
          ),
          AppDimens.paddingLarge.ph,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingLarge),
                    child: MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.yes.tr,
                      onPressed: () {
                        Get.back();
                        controller.clearAllNotification();
                      },
                    )),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingLarge),
                  child: MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.no.tr,
                    onPressed: () {
                      Get.back();
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
  }
}
