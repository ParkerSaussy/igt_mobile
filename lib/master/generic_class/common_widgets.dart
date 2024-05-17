import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/constants.dart';
import '../general_utils/images_path.dart';
import '../general_utils/label_key.dart';
import '../general_utils/text_styles.dart';
import 'common_network_image.dart';
import 'master_buttons_bounce_effect.dart';

class CommonWidgets {
  static Widget gradientContainer({
    required Widget child,
    double? borderRadius,
    Function? onPressed,
    double? elevation,
    Color? borderColor,
    double? borderWidth,
    List<Color>? gradiantColors,
    double? height,
    double? width,
  }) {
    return Bounce(
      duration:
          const Duration(milliseconds: Constants.bounceDurationIconButtons),
      onPressed: () => (onPressed != null ? {onPressed()} : {}),
      child: SizedBox(
        height: height ?? 50,
        width: width ?? 50,
        child: Card(
          color: borderColor ?? Get.theme.colorScheme.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
          ),
          elevation: elevation ?? 0,
          child: Padding(
            padding: EdgeInsets.all(borderWidth ?? 1.0),
            child: Container(
              height: height ?? 50,
              width: width ?? 50,
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 0)),
                gradient: LinearGradient(
                    colors: gradiantColors ??
                        [
                          Get.theme.colorScheme.primary,
                          Get.theme.colorScheme.secondary,
                        ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  // Bottom bar active index view
  static Widget activeIndex(String path) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.theme.colorScheme.onPrimary,
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingLarge),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              Get.theme.colorScheme.primary,
              Get.theme.colorScheme.secondary,
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        child: SvgPicture.asset(
          path,
          colorFilter: ColorFilter.mode(
              Get.theme.colorScheme.onPrimary, BlendMode.srcIn),
        ),
      ),
    );
  }

  // Bottom bar inactive index view
  static Widget inactiveIndex(String path) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
          Get.theme.colorScheme.onPrimary.withAlpha(Constants.lightAlfa),
          BlendMode.srcIn),
    );
  }

  // Avatar image with border
  static Widget avatarWithBorder({
    required String imageUrl,
    double? size,
    double? borderWidth,
    Color? borderColor,
    Color? backGroundColor,
    double? borderRadius,
  }) {
    return Container(
      height: size ?? 100,
      width: size ?? 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? AppDimens.radiusCorner)),
        color: borderColor ?? Get.theme.colorScheme.onPrimary,
      ),
      padding: EdgeInsets.all(borderWidth ?? 2),
      child: CommonNetworkImage(
        imageUrl: imageUrl,
        errorImage: ImagesPath.profileImage,
        width: size ?? 100,
        height: size ?? 100,
        radius: borderRadius ?? AppDimens.radiusCorner,
      ),
    );
  }

  // Text with prefix icon
  static textWithPrefixIcon(
      {required String svgImagePath,
      required String labelName,
      TextStyle? textStyle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(svgImagePath),
        AppDimens.paddingSmall.pw,
        Flexible(
          child: Text(
            labelName,
            style: textStyle ??
                onBackgroundTextStyleRegular(fontSize: AppDimens.textTiny),
            maxLines: 1, // Limit the text to one line
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Text with suffix icon
  static textWithSuffixIcon(
      {required String svgImagePath,
      required String labelName,
      TextStyle? textStyle,
      Function? onSuffixIconPressed}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          labelName,
          overflow: TextOverflow.ellipsis,
          style: textStyle ?? onBackgroundTextStyleSemiBold(),
        ),
        AppDimens.paddingSmall.pw,
        Bounce(
            duration: const Duration(milliseconds: Constants.bounceDuration),
            onPressed: () =>
                (onSuffixIconPressed != null ? {onSuffixIconPressed()} : {}),
            child: SvgPicture.asset(svgImagePath)),
      ],
    );
  }

  // Overlay gradient
  static overlayGradient() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppDimens.radiusCorner)),
        gradient: LinearGradient(
          colors: [
            Get.theme.colorScheme.scrim.withOpacity(0.35),
            Get.theme.colorScheme.scrim.withOpacity(0.35),
          ],
          //begin: Alignment(0.00, -1.00),
          //end: Alignment(0, 1),
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          //stops: const [0, 1]
        ),
      ),
    );
  }

  // Rounded image with Play/Playing Button on bottom right
  static Widget imageWithPlayPlayingIconButton(
      {required bool isPlaying,
      double? size,
      double? borderRadius,
      String? imageUrl}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimens.paddingSmall),
          child: CommonWidgets.avatarWithBorder(
              imageUrl: imageUrl ?? "",
              size: size ?? AppDimens.paddingHuge,
              borderRadius: borderRadius ?? AppDimens.paddingHuge,
              backGroundColor: Colors.transparent),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => {},
            child: SvgPicture.asset(
              isPlaying ? IconPath.tempIconSvg : IconPath.tempIconSvg,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }

  // Play list with rounded image, title and subtitle
  static Widget playlistWithTitleSubTitle(
      {required String title,
      required String subTitle,
      required bool isPlaying,
      String? imageUrl,
      double? radius,
      bool showIcon = true}) {
    return Row(
      children: [
        if (showIcon)
          imageWithPlayPlayingIconButton(
            isPlaying: isPlaying,
            imageUrl: imageUrl ?? '',
          )
        else
          CommonNetworkImage(
            imageUrl: imageUrl ?? '',
            height: AppDimens.avatarHeight,
            width: AppDimens.avatarHeight,
            radius: radius ?? AppDimens.radiusCorner,
          ),
        AppDimens.paddingSmall.pw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: onBackgroundTextStyleSemiBold(
                  fontSize: AppDimens.textMedium, alpha: Constants.darkAlfa),
            ),
            Text(
              subTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: onBackgroundTextStyleRegular(fontSize: AppDimens.textTiny),
            ),
          ],
        ),
      ],
    );
  }

  // Play list with rounded image, title and subtitle
  static Widget avatarWithName({
    String? imageUrl,
    double? size,
    double? borderRadius,
    required String title,
  }) {
    return Row(
      children: [
        CommonWidgets.avatarWithBorder(
            imageUrl: imageUrl ?? "",
            size: size ?? 50,
            borderRadius: borderRadius ?? 50,
            backGroundColor: Colors.transparent),
        AppDimens.paddingMedium.pw,
        Text(
          title,
          style: onBackgroundTextStyleSemiBold(
              fontSize: AppDimens.textMedium, alpha: Constants.darkAlfa),
        ),
      ],
    );
  }

  // Shows live event badge
  static liveEventBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLarge, vertical: AppDimens.paddingSmall),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60), bottomLeft: Radius.circular(60)),
          gradient: LinearGradient(colors: [
            Get.theme.colorScheme.primary,
            Get.theme.colorScheme.secondary,
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              IconPath.tempIconSvg,
              height: AppDimens.smallIconSize,
              width: AppDimens.smallIconSize,
            ),
            AppDimens.paddingSmall.pw,
            Text(
              LabelKeys.live.tr,
              style: onPrimaryTextStyleSemiBold(fontSize: AppDimens.textSmall),
            ),
          ],
        ),
      ),
    );
  }

  // For indoor and outdoor badge on event list
  static indoorOutdoorBadge(
      {required String text,
      double? paddingHorizontal,
      double? paddingVertical,
      Color? backgroundColor,
      double? borderRadius,
      TextStyle? textStyle}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? AppDimens.paddingMedium,
          vertical: paddingVertical ?? AppDimens.paddingSmall),
      decoration: BoxDecoration(
          color: backgroundColor ??
              Get.theme.colorScheme.surface.withAlpha(Constants.lightAlfa),
          borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? AppDimens.radiusCorner))),
      child: Center(
          child: Text(
        text,
        style: textStyle ??
            onBackgroundTextStyleSemiBold(fontSize: AppDimens.textTiny),
      )),
    );
  }

  //Live event with ratting
  static liveEventNameWithRatting(
      {required String title,
      required String ratting,
      required String imageUrl,
      String? iconPath,
      bool rateMeText = true,
      bool isRatingShow = true,
      Function? onItemClicked,
      VoidCallback? onTap,
      double? iconSize,
      Color? iconBg,
      bool isShowTrail = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Bounce(
          duration: const Duration(milliseconds: Constants.bounceDuration),
          onPressed: () => {onItemClicked!()},
          child: Row(
            children: [
              CommonWidgets.avatarWithBorder(
                  imageUrl: imageUrl,
                  size: 50,
                  borderRadius: AppDimens.radiusCircle,
                  backGroundColor: Colors.transparent),
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: onBackgroundTextStyleSemiBold(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.darkAlfa),
                    ),
                    AppDimens.paddingTiny.ph,
                    isRatingShow
                        ? Row(
                            children: [
                              SvgPicture.asset(
                                IconPath.tempIconSvg,
                                width: AppDimens.smallIconSize,
                                height: AppDimens.smallIconSize,
                              ),
                              AppDimens.paddingSmall.pw,
                              Text(
                                "$ratting Rating",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textTiny),
                              ),
                              AppDimens.paddingExtraLarge.pw,
                              Column(
                                children: [
                                  Text(rateMeText ? LabelKeys.rateMe.tr : "",
                                      style: onPrimaryTextStyleSemiBold(
                                          fontSize: AppDimens.textTiny)),
                                ],
                              )
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        isShowTrail
            ? GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.paddingSmall),
                  decoration: BoxDecoration(
                    color: iconBg ??
                        Get.theme.colorScheme.surface
                            .withAlpha(Constants.darkAlfa),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingSmall),
                    child: SvgPicture.asset(
                      iconPath ?? IconPath.tempIconSvg,
                      height: iconSize ?? AppDimens.smallIconSize,
                      width: iconSize ?? AppDimens.smallIconSize,
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  static liveEventNameWithRattingandButton(
      {required String title,
      required String ratting,
      required String imageUrl,
      required String btnText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonWidgets.avatarWithBorder(
            imageUrl: imageUrl,
            size: 50,
            borderRadius: 50,
            backGroundColor: Colors.transparent),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: onBackgroundTextStyleSemiBold(
                    fontSize: AppDimens.textMedium, alpha: Constants.darkAlfa),
              ),
              AppDimens.paddingTiny.ph,
              Row(
                children: [
                  SvgPicture.asset(IconPath.tempIconSvg,
                      width: AppDimens.paddingExtraLarge,
                      height: AppDimens.paddingExtraLarge),
                  AppDimens.paddingSmall.pw,
                  Text(
                    "$ratting Ratting",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textTiny),
                  ),
                ],
              )
            ],
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 1,
          child: MasterButtonsBounceEffect.gradiantButton(
              btnText: btnText, height: 40),
        )
      ],
    );
  }

  //My Ticket with count
  static myTicketCard(
      {required String title,
      required String totalTicket,
      required String imageUrl,
      String? iconPath,
      Function? onItemClicked,
      VoidCallback? onTap,
      double? iconSize,
      Color? iconBg,
      bool isShowTrail = true,
      bool isShowLeading = true,
      String? date}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Bounce(
          duration: const Duration(milliseconds: Constants.bounceDuration),
          onPressed: () => {onItemClicked!()},
          child: Row(
            children: [
              isShowLeading
                  ? CommonWidgets.avatarWithBorder(
                      imageUrl: imageUrl,
                      size: 50,
                      borderRadius: AppDimens.radiusCircle,
                      backGroundColor: Colors.transparent)
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: onBackgroundTextStyleSemiBold(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.darkAlfa),
                    ),
                    AppDimens.paddingTiny.ph,
                    Text(
                      totalTicket,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textTiny),
                    ),
                    AppDimens.paddingTiny.ph,
                    Text(
                      date ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textTiny),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        isShowTrail
            ? GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.paddingSmall),
                  decoration: BoxDecoration(
                    color: iconBg ??
                        Get.theme.colorScheme.surface
                            .withAlpha(Constants.darkAlfa),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingSmall),
                    child: SvgPicture.asset(
                      iconPath ?? IconPath.tempIconSvg,
                      height: iconSize ?? AppDimens.smallIconSize,
                      width: iconSize ?? AppDimens.smallIconSize,
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  static Widget transactionChargesBottomSheet({
    String? title,
    String? requestPrice,
    required String totalAmount,
    required String transCharges,
    required String finalAmount,
    Function? onApply,
  }) {
    return Container(
      color: Get.theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                height: Get.height * 0.62,
                width: Get.width * 0.9,
              ),
              Positioned(
                bottom: 0,
                child: CommonWidgets.gradientContainer(
                    height: Get.height * 0.52,
                    width: Get.width * 0.9,
                    borderRadius: AppDimens.radiusCorner,
                    borderColor: Get.theme.disabledColor,
                    gradiantColors: [
                      Get.theme.colorScheme.surface,
                      Get.theme.colorScheme.surface
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppDimens.padding3XLarge.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(title ?? "",
                                  style: onPrimaryTextStyleSemiBold(
                                      fontSize: AppDimens.textLarge),
                                  textAlign: TextAlign.justify),
                            ),
                            AppDimens.paddingExtraLarge.pw,
                            Container(
                                height: AppDimens.avatarHeight,
                                width: AppDimens.avatarWidth,
                                padding: const EdgeInsets.all(
                                    AppDimens.paddingSmall),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          AppDimens.radiusCornerLarge)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Get.theme.colorScheme.primary,
                                        Get.theme.colorScheme.secondary,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                ),
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      "\$ $finalAmount",
                                      style: onPrimaryTextStyleSemiBold(),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        AppDimens.paddingLarge.ph,
                        const Divider(),
                        AppDimens.paddingXLarge.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Amount",
                                style: onPrimaryTextStyleSemiBold()),
                            AppDimens.paddingMedium.ph,
                            Text("\$ $totalAmount",
                                style: onPrimaryTextStyleMedium(
                                    fontSize: AppDimens.textLarge))
                          ],
                        ),
                        AppDimens.paddingXLarge.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Transaction Charges:",
                                style: onPrimaryTextStyleSemiBold()),
                            AppDimens.paddingMedium.ph,
                            Text("\$ $transCharges",
                                style: onPrimaryTextStyleMedium(
                                    fontSize: AppDimens.textLarge))
                          ],
                        ),
                        AppDimens.paddingXLarge.ph,
                        const Divider(),
                        AppDimens.paddingXLarge.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Final Amount",
                                style: onPrimaryTextStyleSemiBold()),
                            AppDimens.paddingMedium.ph,
                            Text("\$ $finalAmount",
                                style: onPrimaryTextStyleMedium(
                                    fontSize: AppDimens.textLarge))
                          ],
                        ),
                        AppDimens.paddingXLarge.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MasterButtonsBounceEffect.colorButton(
                                btnText: LabelKeys.cancel.tr,
                                onPressed: () => Get.back(),
                              ),
                            ),
                            AppDimens.paddingExtraLarge.pw,
                            Expanded(
                              child: MasterButtonsBounceEffect.gradiantButton(
                                  height: AppDimens.largeIconSize,
                                  btnText: "Proceed",
                                  onPressed: onApply),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              Positioned(
                  left: Get.width * 0.45 - (AppDimens.userCardButtonWidth / 2),
                  child: SizedBox(
                      height: AppDimens.userCardButtonWidth,
                      width: AppDimens.userCardButtonWidth,
                      child: SvgPicture.asset(IconPath.tempIconSvg)))
            ],
          ),
        ),
      ),
    );
  }

  static Widget transactionChargesHost({
    String? title,
    String? requestPrice,
    required String totalAmount,
    required String transCharges,
    required String finalAmount,
    Function? onApply,
  }) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Get.theme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SvgPicture.asset(
              ImagesPath.lesGoLogoSvg,
              height: AppDimens.imageCardHeight,
              width: AppDimens.imageCardHeight,
            ),
          ),
          AppDimens.paddingMedium.ph,
          SizedBox(
            child: Text(
              title ?? "",
              style: onPrimaryTextStyleSemiBold(fontSize: AppDimens.textSmall),
            ),
          ),
          AppDimens.paddingMedium.ph,
          const Divider(),
          AppDimens.paddingMedium.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Plan Price", style: onPrimaryTextStyleSemiBold()),
              AppDimens.paddingMedium.ph,
              Text("\$ $totalAmount",
                  style:
                      onPrimaryTextStyleMedium(fontSize: AppDimens.textLarge))
            ],
          ),
          AppDimens.paddingMedium.ph,
          const Divider(),
          AppDimens.paddingMedium.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transaction Charges:", style: onPrimaryTextStyleSemiBold()),
              AppDimens.paddingMedium.ph,
              Text("\$ $transCharges",
                  style:
                      onPrimaryTextStyleMedium(fontSize: AppDimens.textLarge))
            ],
          ),
          AppDimens.paddingMedium.ph,
          const Divider(),
          AppDimens.paddingMedium.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Obtained Points", style: onPrimaryTextStyleSemiBold()),
              AppDimens.paddingMedium.ph,
              Text(finalAmount,
                  style:
                      onPrimaryTextStyleMedium(fontSize: AppDimens.textLarge))
            ],
          ),
          AppDimens.paddingMedium.ph,
          MasterButtonsBounceEffect.gradiantButton(
              height: AppDimens.largeIconSize,
              btnText: "Proceed",
              onPressed: onApply)
        ],
      ),
    );
  }
}
