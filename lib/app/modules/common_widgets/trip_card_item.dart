import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/constants.dart';
import '../../../master/general_utils/images_path.dart';
import '../../../master/general_utils/text_styles.dart';
import '../../../master/generic_class/common_network_image_banner.dart';
import '../../../master/generic_class/common_widgets.dart';
import '../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../models/trip_details_model.dart';

class TripCardItem extends StatelessWidget {
  final double? bannerHeight;
  final double? bannerCornerRadius;
  final double childWidth;
  final EdgeInsetsGeometry margin;
  final TripDetailsModel model;
  final Function onChatTap;
  final Function onBarChartTap;
  final int index;
  final bool? showStatus;
  final bool isPastTrip;

  const TripCardItem({
    Key? key,
    this.bannerHeight,
    this.bannerCornerRadius,
    required this.childWidth,
    required this.margin,
    required this.model,
    required this.index,
    this.showStatus = false,
    required this.onChatTap,
    required this.onBarChartTap,
    required this.isPastTrip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: childWidth,
          margin: margin,
          child: Material(
            color: isPastTrip
                ? Get.theme.colorScheme.inversePrimary
                : model.role == Role.host || model.isCoHost == 1
                    ? Get.theme.colorScheme.tertiary
                        .withAlpha(Constants.mediumAlfa)
                    : Get.theme.colorScheme.onPrimary,
            elevation: 4.0,
            borderRadius: BorderRadius.circular(AppDimens.radiusCorner),
            shadowColor:
                Get.theme.colorScheme.surface.withAlpha(Constants.lightAlfa),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: bannerHeight ?? AppDimens.tripCardImageHeight,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.radiusCorner),
                    ),
                    child: Stack(
                      children: [
                        CommonNetworkImageBanner(
                          height: bannerHeight ?? AppDimens.tripCardImageHeight,
                          errorImage: IconPath.placeHolderSvg,
                          radius: bannerCornerRadius ?? AppDimens.radiusCorner,
                          imageUrl: "${model.tripImgUrl}",
                        ),
                        Positioned.fill(child: CommonWidgets.overlayGradient()),
                        Positioned(
                          top: AppDimens.paddingMedium,
                          left: AppDimens.paddingMedium,
                          right: AppDimens.paddingMedium,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              model.isTripFinalised!
                                  ? dateWidget()
                                  : const SizedBox(),
                              model.isPaid! == 1
                                  ? premiumTripWidget()
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: AppDimens.paddingMedium,
                          right: AppDimens.paddingMedium,
                          left: AppDimens.paddingMedium,
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                model.isTripFinalised!
                                    ? Flexible(
                                        child: CommonWidgets.textWithPrefixIcon(
                                          svgImagePath: IconPath.locationWhite,
                                          textStyle: onPrimaryTextStyleMedium(),
                                          labelName: concatCityName(
                                              model.cityNameDetails?.cityName ??
                                                  "",
                                              '',
                                              model.cityNameDetails
                                                      ?.countryName ??
                                                  "",
                                              model.cityNameDetails?.timeZone ??
                                                  ""),
                                        ),
                                      )
                                    : const SizedBox(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    model.isTripFinalised!
                                        ? const SizedBox()
                                        : MasterButtonsBounceEffect.iconButton(
                                            bgColor:
                                                Get.theme.colorScheme.primary,
                                            svgUrl: IconPath.icBarChart,
                                            iconPadding: AppDimens.paddingSmall,
                                            iconSize: AppDimens.normalIconSize,
                                            iconColor: Get
                                                .theme.colorScheme.onBackground,
                                            onPressed: onBarChartTap,
                                          ),
                                    AppDimens.paddingSmall.pw,
                                    MasterButtonsBounceEffect.iconButton(
                                      bgColor: Get.theme.colorScheme.primary,
                                      svgUrl: IconPath.icChat,
                                      iconPadding: AppDimens.paddingSmall,
                                      iconSize: AppDimens.normalIconSize,
                                      iconColor:
                                          Get.theme.colorScheme.onBackground,
                                      onPressed: onChatTap,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AppDimens.paddingSmall.ph,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingMedium),
                  child: Text(
                    model.tripName ?? "",
                    style: onBackgroundTextStyleSemiBold(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingMedium,
                      vertical: AppDimens.paddingSmall),
                  child: Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            CommonNetworkImage(
                              imageUrl: "${model.hostDetail!.profileImage}",
                              height: AppDimens.largeIconSize,
                              width: AppDimens.largeIconSize,
                              radius: AppDimens.paddingMedium,
                            ),
                            AppDimens.paddingSmall.pw,
                            Flexible(
                              child: Text(
                                "${model.hostDetail!.firstName ?? ""} ${model.hostDetail!.lastName ?? ""}",
                                style: onBackGroundTextStyleMedium(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CommonWidgets.textWithPrefixIcon(
                                svgImagePath: IconPath.icUserLine,
                                textStyle: onBackgroundTextStyleSemiBold(),
                                labelName: model.role == Role.host
                                    ? LabelKeys.eventHost.tr
                                    : model.isCoHost == 1
                                        ? LabelKeys.tripCoHost.tr
                                        : model.role ?? LabelKeys.guest.tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dateWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLarge, vertical: AppDimens.paddingTiny),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onPrimary.withAlpha(Constants.lightAlfa),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimens.radiusCorner),
        ),
      ),
      child: Text(
        getDays(model.tripFinalStartDate!, model.tripFinalEndDate!),
        style: onBackgroundTextStyleRegular(fontSize: AppDimens.textMedium),
      ),
    );
  }

  Widget premiumTripWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingLarge, vertical: AppDimens.paddingTiny),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffFDD239),
            Color(0xffF3AB1C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimens.radiusCorner),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(IconPath.icCrown),
          AppDimens.paddingSmall.pw,
          Flexible(
            child: Text(
              LabelKeys.premium.tr,
              style: onBackgroundTextStyleRegular(),
              maxLines: 1, // Limit the text to one line
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String getDays(DateTime startDate, DateTime endDate) {
    DateTime sDate = getDateOnly(startDate);
    DateTime eDate = getDateOnly(endDate);
    int days = Date.shared().datesDifferenceInDay(sDate, eDate);
    return days > 1
        ? '$days ${LabelKeys.days.tr}'
        : '$days ${LabelKeys.day.tr}';
  }

  DateTime getDateOnly(DateTime originalDateTime) {
    return DateTime(
        originalDateTime.year, originalDateTime.month, originalDateTime.day);
  }
}
