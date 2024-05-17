import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
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
import 'package:lesgo/master/generic_class/payment_configurations.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';
import 'package:pay/pay.dart';

import 'subscription_plan_screen_controller.dart';

class SubscriptionPlanScreenView
    extends GetView<SubscriptionPlanScreenController> {
  const SubscriptionPlanScreenView({Key? key}) : super(key: key);

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
              })
              /*InkWell(
              onTap: () {
                if (Preference.isGetNotification()) {
                  Get.offAllNamed(Routes.DASHBOARD);
                } else {
                  Get.back();
                }
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
            ),*/
              ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingExtraLarge),
                child: Text(LabelKeys.subscription.tr,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textExtraLarge,
                        alpha: Constants.darkAlfa),
                    overflow: TextOverflow.ellipsis),
              ),
              AppDimens.paddingMedium.ph,
              Expanded(
                child: ContainerTopRoundedCorner(
                  child: ScrollViewRoundedCorner(
                    child: Obx(() => controller.planFatch.value
                        ? controller.singlePlanModel != null &&
                                controller.singlePlanModel!.isPlanPurchased!
                            ? controller.purchasedRestorationId.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppDimens.paddingExtraLarge,
                                        right: AppDimens.paddingExtraLarge,
                                        top: AppDimens.paddingVerySmall),
                                    child: planPurchased(),
                                  )
                                : const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: AppDimens.paddingExtraLarge,
                                    right: AppDimens.paddingExtraLarge,
                                    top: AppDimens.paddingVerySmall),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppDimens.paddingXXLarge.ph,
                                    Text(LabelKeys.getAccessPremiumFeatures.tr,
                                        style: onBackgroundTextStyleSemiBold(
                                            fontSize: AppDimens.textLarge,
                                            alpha: Constants.darkAlfa),
                                        overflow: TextOverflow.ellipsis),
                                    AppDimens.paddingXLarge.ph,
                                    /*Text(LabelKeys.loremMsg.tr,
                                        maxLines: 2,
                                        style: onBackgroundTextStyleRegular(
                                            fontSize: AppDimens.textMedium,
                                            alpha: Constants.veryLightAlfa),
                                        overflow: TextOverflow.ellipsis),
                                    AppDimens.paddingXLarge.ph,*/
                                    planDetailText(IconPath.planTick,
                                        LabelKeys.unlimitedTripsEvents.tr),
                                    AppDimens.paddingMedium.ph,
                                    planDetailText(
                                        IconPath.planTick, "Group Chat"),
                                    AppDimens.paddingMedium.ph,
                                    planDetailText(
                                        IconPath.planTick, "Trip Memories"),
                                    AppDimens.paddingMedium.ph,
                                    planDetailText(
                                        IconPath.planTick, "Group Expenses"),
                                    AppDimens.paddingMedium.ph,
                                    planDetailText(
                                        IconPath.planTick, "Activities"),
                                    AppDimens.paddingMedium.ph,
                                    planDetailText(
                                        IconPath.planTick, "Documents"),
                                    AppDimens.paddingXLarge.ph,
                                    Obx(
                                      () => controller.lstSinglePlan.isNotEmpty
                                          ? Text(LabelKeys.chooseYourPlan.tr,
                                              style:
                                                  onBackgroundTextStyleSemiBold(
                                                      fontSize:
                                                          AppDimens.textLarge,
                                                      alpha:
                                                          Constants.darkAlfa),
                                              overflow: TextOverflow.ellipsis)
                                          : Container(),
                                    ),
                                    AppDimens.paddingXLarge.ph,
                                    Obx(
                                        () =>
                                            controller.planRestorationId.value
                                                    .isEmpty
                                                ? const SizedBox()
                                                : controller.lstSinglePlan
                                                        .isNotEmpty
                                                    ? ListView.builder(
                                                        itemCount: controller
                                                            .lstSinglePlan
                                                            .length,
                                                        physics:
                                                            const ClampingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        restorationId: controller
                                                            .planRestorationId
                                                            .value,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .paymentItems
                                                                  .clear();
                                                              controller
                                                                  .selectedIndex
                                                                  .value = index;
                                                              controller
                                                                  .paymentItems
                                                                  .add(
                                                                PaymentItem(
                                                                    amount: controller
                                                                        .lstSinglePlan[
                                                                            index]
                                                                        .discountedPrice!,
                                                                    label:
                                                                        'ItsGoTime',
                                                                    status: PaymentItemStatus
                                                                        .final_price),
                                                              );
                                                              controller
                                                                      .planRestorationId
                                                                      .value =
                                                                  getRandomString();
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .only(
                                                                  bottom: AppDimens
                                                                      .paddingExtraLarge),
                                                              child: Container(
                                                                height: 125,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            32),
                                                                    border: Border.all(
                                                                        color: controller.selectedIndex.value == index
                                                                            ? Get
                                                                                .theme.colorScheme.primary
                                                                            : Get
                                                                                .theme.colorScheme.secondary,
                                                                        width:
                                                                            1.0,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                    color: controller.selectedIndex.value ==
                                                                            index
                                                                        ? Get
                                                                            .theme
                                                                            .colorScheme
                                                                            .primary
                                                                        : Colors
                                                                            .white),
                                                                child: Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                AppDimens.paddingLarge,
                                                                            right: AppDimens.paddingLarge),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(controller.yearCalculate(index), style: controller.selectedIndex.value == index ? onPrimaryTextStyleRegular() : onBackgroundTextStyleRegular(alpha: Constants.lightAlfa)),
                                                                                RichText(
                                                                                  text: TextSpan(
                                                                                    children: [
                                                                                      TextSpan(
                                                                                        text: "\$${controller.lstSinglePlan[index].discountedPrice}/",
                                                                                        style: controller.selectedIndex.value == index ? onPrimaryTextStyleSemiBold(fontSize: AppDimens.text2XLarge) : onBackgroundTextStyleSemiBold(fontSize: AppDimens.text2XLarge),
                                                                                      ),
                                                                                      TextSpan(
                                                                                        text: "\$${controller.lstSinglePlan[index].price}",
                                                                                        style: controller.selectedIndex.value == index ? onPrimaryTextStyleMedium(fontSize: AppDimens.textSmall).copyWith(decoration: TextDecoration.lineThrough) : onBackGroundTextStyleMedium(fontSize: AppDimens.textSmall).copyWith(decoration: TextDecoration.lineThrough),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            CachedNetworkImage(
                                                                              imageUrl: controller.lstSinglePlan[index].imageUrl ?? "",
                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                height: 60,
                                                                                width: 60,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: const BorderRadius.all(Radius.circular(AppDimens.radiusCornerLarge)),
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              placeholder: (context, url) => const SizedBox(),
                                                                              errorWidget: (context, url, error) => const SizedBox(),
                                                                              fit: BoxFit.cover,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top:
                                                                            -12,
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets.only(
                                                                              left: AppDimens.paddingSmall,
                                                                              right: AppDimens.paddingSmall),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(32),
                                                                              border: Border.all(color: controller.selectedIndex.value == index ? Get.theme.colorScheme.primary : Get.theme.colorScheme.secondary, width: 1.0, style: BorderStyle.solid),
                                                                              color: controller.selectedIndex.value == index ? const Color(0xffC2FFE1) : Get.theme.colorScheme.tertiary),
                                                                          child:
                                                                              Text(
                                                                            "${controller.percentageCalculate(index).toStringAsFixed(0)}${LabelKeys.offBestValue.tr}",
                                                                            style:
                                                                                onBackGroundTextStyleMedium(alpha: Constants.mediumAlfa),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : Text(LabelKeys
                                                        .noPlanFound.tr)),
                                    AppDimens.paddingXLarge.ph,
                                    Obx(() => controller
                                            .lstSinglePlan.isNotEmpty
                                        ? Platform.isAndroid
                                            ? MasterButtonsBounceEffect
                                                .gradiantButton(
                                                btnText:
                                                    LabelKeys.subscribeNow.tr,
                                                onPressed: () {
                                                  if (controller.selectedIndex
                                                          .value ==
                                                      -1) {
                                                    RequestManager.getSnackToast(
                                                        message: LabelKeys
                                                            .pleaseSelectPlan
                                                            .tr);
                                                  } else {
                                                    controller.makePayment();
                                                  }
                                                },
                                              )
                                            : controller.selectedIndex.value !=
                                                    -1
                                                ? ApplePayButton(
                                                    paymentConfiguration:
                                                        PaymentConfiguration
                                                            .fromJsonString(
                                                                defaultApplePay),
                                                    paymentItems:
                                                        controller.paymentItems,
                                                    style: ApplePayButtonStyle
                                                        .automatic,
                                                    type: ApplePayButtonType
                                                        .subscribe,
                                                    height: AppDimens
                                                        .buttonHeightMedium,
                                                    width: Get.width,
                                                    onPaymentResult: controller
                                                        .onApplePayResult,
                                                    loadingIndicator:
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  )
                                                : Container()
                                        : Container()),
                                    AppDimens.paddingXLarge.ph,
                                  ],
                                ),
                              )
                        : const SizedBox()),
                  ),
                ),
              )
            ],
          )),
    );
  }

  planDetailText(String image, String s) {
    return Row(
      children: [
        SvgPicture.asset(image),
        AppDimens.paddingMedium.pw,
        Text(s,
            style: onBackgroundTextStyleRegular(
                fontSize: AppDimens.textMedium, alpha: Constants.darkAlfa),
            overflow: TextOverflow.ellipsis)
      ],
    );
  }

  Widget planPurchased() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimens.paddingXLarge.ph,
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                  color: Get.theme.colorScheme.primary,
                  width: 1.0,
                  style: BorderStyle.solid),
              color: const Color(0xffBCE4D0).withOpacity(0.15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimens.paddingExtraLarge),
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32)),
                      border: Border.all(
                          color: Get.theme.colorScheme.primary,
                          width: 1.0,
                          style: BorderStyle.solid),
                      color: Get.theme.colorScheme.primary),
                  child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppDimens.paddingLarge,
                              right: AppDimens.paddingLarge),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      controller.activatedYearCalculate(
                                          int.parse(controller
                                              .singlePlanModel!.duration!
                                              .toString())),
                                      style: onPrimaryTextStyleRegular()),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                "\$${controller.singlePlanModel!.discountedPrice!}/",
                                            style: onPrimaryTextStyleSemiBold(
                                                fontSize:
                                                    AppDimens.text2XLarge)),
                                        TextSpan(
                                          text:
                                              "\$${controller.singlePlanModel!.price!}",
                                          style: onPrimaryTextStyleMedium(
                                                  fontSize: AppDimens.textSmall)
                                              .copyWith(
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(
                                      "${LabelKeys.expiredOn.tr} ${Date.shared().getDateFromUtc(gc.loginData.value.planEndDate!)}",
                                      style: onPrimaryTextStyleRegular(
                                          fontSize: AppDimens.textSmall)),
                                ],
                              ),
                              CachedNetworkImage(
                                imageUrl:
                                    controller.singlePlanModel!.imageUrl!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            AppDimens.radiusCornerLarge)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const SizedBox(),
                                errorWidget: (context, url, error) =>
                                    const SizedBox(),
                                fit: BoxFit.cover,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: -12,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: AppDimens.paddingSmall,
                                right: AppDimens.paddingSmall),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(
                                    color: Get.theme.colorScheme.primary,
                                    width: 1.0,
                                    style: BorderStyle.solid),
                                color: const Color(0xffC2FFE1)),
                            child: Text(
                              LabelKeys.activated.tr,
                              style: onBackGroundTextStyleMedium(
                                  alpha: Constants.mediumAlfa),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LabelKeys.getAccessPremiumFeatures.tr,
                        style: onBackgroundTextStyleSemiBold(
                            fontSize: AppDimens.textLarge,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                    AppDimens.paddingXLarge.ph,
                    Text(
                        removeHtmlTag(controller.singlePlanModel!.description!),
                        maxLines: 2,
                        style: onBackgroundTextStyleRegular(
                            fontSize: AppDimens.textMedium,
                            alpha: Constants.veryLightAlfa),
                        overflow: TextOverflow.ellipsis),
                    AppDimens.paddingXLarge.ph,
                    planDetailText(
                        IconPath.planTick, LabelKeys.unlimitedTripsEvents.tr),
                    AppDimens.paddingMedium.ph,
                    planDetailText(IconPath.planTick, "Group Chat"),
                    AppDimens.paddingMedium.ph,
                    planDetailText(IconPath.planTick, "Trip Memories"),
                    AppDimens.paddingMedium.ph,
                    planDetailText(IconPath.planTick, "Group Expenses"),
                    AppDimens.paddingMedium.ph,
                    planDetailText(IconPath.planTick, "Activities"),
                    AppDimens.paddingMedium.ph,
                    planDetailText(IconPath.planTick, "Documents"),
                    AppDimens.paddingXLarge.ph,
                  ],
                ),
              )
            ],
          ),
        ),
        AppDimens.paddingXLarge.ph,
        Obx(
          () => controller.lstSinglePlan.isNotEmpty
              ? Text(LabelKeys.chooseYourPlan.tr,
                  style: onBackgroundTextStyleSemiBold(
                      fontSize: AppDimens.textLarge, alpha: Constants.darkAlfa),
                  overflow: TextOverflow.ellipsis)
              : Container(),
        ),
        AppDimens.paddingXLarge.ph,
        Obx(() => controller.planRestorationId.value.isEmpty
            ? Container()
            : controller.lstSinglePlan.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.lstSinglePlan.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    restorationId: controller.planRestorationId.value,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          controller.paymentItems.clear();
                          controller.selectedIndex.value = index;
                          controller.paymentItems.add(
                            PaymentItem(
                                amount: controller
                                    .lstSinglePlan[index].discountedPrice!,
                                label: 'ItsGoTime',
                                status: PaymentItemStatus.final_price),
                          );
                          controller.planRestorationId.value =
                              getRandomString();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppDimens.paddingExtraLarge),
                          child: Container(
                            height: 125,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(
                                    color:
                                        controller.selectedIndex.value == index
                                            ? Get.theme.colorScheme.primary
                                            : Get.theme.colorScheme.secondary,
                                    width: 1.0,
                                    style: BorderStyle.solid),
                                color: controller.selectedIndex.value == index
                                    ? Get.theme.colorScheme.primary
                                    : Colors.white),
                            child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: AppDimens.paddingLarge,
                                        right: AppDimens.paddingLarge),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                controller.yearCalculate(index),
                                                style: controller.selectedIndex
                                                            .value ==
                                                        index
                                                    ? onPrimaryTextStyleRegular()
                                                    : onBackgroundTextStyleRegular(
                                                        alpha: Constants
                                                            .lightAlfa)),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "\$${controller.lstSinglePlan[index].discountedPrice}/",
                                                    style: controller
                                                                .selectedIndex
                                                                .value ==
                                                            index
                                                        ? onPrimaryTextStyleSemiBold(
                                                            fontSize: AppDimens
                                                                .text2XLarge)
                                                        : onBackgroundTextStyleSemiBold(
                                                            fontSize: AppDimens
                                                                .text2XLarge),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "\$${controller.lstSinglePlan[index].price}",
                                                    style: controller
                                                                .selectedIndex
                                                                .value ==
                                                            index
                                                        ? onPrimaryTextStyleMedium(
                                                                fontSize: AppDimens
                                                                    .textSmall)
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough)
                                                        : onBackGroundTextStyleMedium(
                                                                fontSize: AppDimens
                                                                    .textSmall)
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        /*SvgPicture.asset(
                                                      IconPath.planStar)*/
                                        CachedNetworkImage(
                                          imageUrl: controller
                                                  .lstSinglePlan[index]
                                                  .imageUrl ??
                                              "",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(AppDimens
                                                          .radiusCornerLarge)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const SizedBox(),
                                          errorWidget: (context, url, error) =>
                                              const SizedBox(),
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -12,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: AppDimens.paddingSmall,
                                          right: AppDimens.paddingSmall),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          border: Border.all(
                                              color: controller.selectedIndex
                                                          .value ==
                                                      index
                                                  ? Get
                                                      .theme.colorScheme.primary
                                                  : Get.theme.colorScheme
                                                      .secondary,
                                              width: 1.0,
                                              style: BorderStyle.solid),
                                          color: controller
                                                      .selectedIndex.value ==
                                                  index
                                              ? const Color(0xffC2FFE1)
                                              : Get.theme.colorScheme.tertiary),
                                      child: Text(
                                        "${controller.percentageCalculate(index).toStringAsFixed(0)}${LabelKeys.offBestValue.tr}",
                                        style: onBackGroundTextStyleMedium(
                                            alpha: Constants.mediumAlfa),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    },
                  )
                : Text(LabelKeys.noPlanFound.tr)),
        AppDimens.paddingXLarge.ph,
        Obx(() => controller.lstSinglePlan.isNotEmpty
            ? Platform.isAndroid
                ? MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.changePlan.tr,
                    onPressed: () {
                      if (controller.selectedIndex.value == -1) {
                        RequestManager.getSnackToast(
                            message: LabelKeys.pleaseSelectPlan.tr);
                      } else {
                        controller.makePayment();
                      }
                    },
                  )
                : controller.selectedIndex.value != -1
                    ? ApplePayButton(
                        paymentConfiguration:
                            PaymentConfiguration.fromJsonString(
                                defaultApplePay),
                        paymentItems: controller.paymentItems,
                        style: ApplePayButtonStyle.automatic,
                        type: ApplePayButtonType.subscribe,
                        height: AppDimens.buttonHeightMedium,
                        width: Get.width,
                        onPaymentResult: controller.onApplePayResult,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox()
            : const SizedBox()),
        AppDimens.paddingLarge.ph,
      ],
    );
  }
}
