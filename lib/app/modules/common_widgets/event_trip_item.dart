import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_list_model.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../master/general_utils/common_stuff.dart';
import '../../../master/general_utils/constants.dart';
import '../../../master/general_utils/date.dart';
import '../../../master/generic_class/common_network_image_banner.dart';
import '../../../master/generic_class/common_widgets.dart';

class EventTripItem extends StatelessWidget {
  const EventTripItem(
      {Key? key, required this.onTap, required this.tripListModel})
      : super(key: key);

  final Function onTap;
  final TripListModel tripListModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(AppDimens.radiusCorner))),
              padding: const EdgeInsets.all(AppDimens.paddingNano),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      const CommonNetworkImageBanner(
                        height:
                            /*bannerHeight ??*/ AppDimens.tripCardImageHeight,
                        errorImage: ImagesPath.placeHolderPng,
                        radius: /*bannerCornerRadius ??*/
                            AppDimens.radiusCorner,
                        imageUrl: /*model.eventPhotos![0].eventPhotos*/
                            ImagesPath.sampleImageUrl,
                      ),
                      Positioned.fill(child: CommonWidgets.overlayGradient()),
                      tripListModel.isTripFinalised!
                          ? Positioned(
                              top: AppDimens.paddingMedium,
                              left: AppDimens.paddingMedium,
                              child:
                                  dateWidget() /*Container(
                          padding: const EdgeInsets.only(
                              left: AppDimens.paddingMedium,
                              right: AppDimens.paddingMedium,
                              top: AppDimens.paddingTiny,
                              bottom: AppDimens.paddingTiny),
                          decoration: BoxDecoration(
                              color: Get.theme.colorScheme.onPrimary,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppDimens.radiusCorner))),
                          child: Text(
                            "2 - 4 Days",
                            style: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textSmall),
                          ),
                        )*/
                              ,
                            )
                          : const SizedBox(),
                      tripListModel.isTripFinalised!
                          ? Positioned(
                              left: AppDimens.paddingMedium,
                              bottom: AppDimens.paddingExtraLarge,
                              child: CommonWidgets.textWithPrefixIcon(
                                  svgImagePath: IconPath.locationWhite,
                                  textStyle: onPrimaryTextStyleMedium(),
                                  labelName: concatCityName(
                                      tripListModel.cityNameDetails?.cityName ??
                                          "",
                                      '',
                                      tripListModel
                                              .cityNameDetails?.countryName ??
                                          "",
                                      tripListModel.cityNameDetails?.timeZone ??
                                          "")),
                            )
                          : const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: AppDimens.paddingSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tripListModel.tripName ?? "",
                          style: onBackGroundTextStyleMedium(),
                        ),
                        const SizedBox(
                          height: AppDimens.paddingSmall,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  CommonNetworkImage(
                                    imageUrl:
                                        "${tripListModel.hostDetail!.profileImage}",
                                    height: AppDimens.largeIconSize,
                                    width: AppDimens.largeIconSize,
                                    radius: AppDimens.paddingMedium,
                                  ),
                                  const SizedBox(
                                    width: AppDimens.paddingSmall,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${tripListModel.hostDetail!.firstName ?? ""} ${tripListModel.hostDetail!.lastName ?? ""}",
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
                                      textStyle:
                                          onBackgroundTextStyleSemiBold(),
                                      labelName: gc.loginData.value.id ==
                                              tripListModel.createdBy
                                          ? LabelKeys.eventHost.tr
                                          : LabelKeys.guest.tr),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppDimens.paddingLarge,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            getDays(tripListModel.tripFinalStartDate!,
                tripListModel.tripFinalEndDate!),
            style: onBackgroundTextStyleRegular(fontSize: AppDimens.textMedium),
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
