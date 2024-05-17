import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/models/activity_details_model.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

class ActivityFlightWidget extends StatelessWidget {
  const ActivityFlightWidget({super.key, required this.activityDetailsModel});

  final ActivityDetailsModel activityDetailsModel;

  @override
  Widget build(BuildContext context) {
    return ContainerTopRoundedCorner(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: AppDimens.paddingLarge,
                right: AppDimens.paddingExtraLarge,
                left: AppDimens.paddingExtraLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(
                  height: 2.5,
                  width: 35,
                  color: const Color(0xffDEDEDE),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    IconPath.closeRoundedIcon,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDimens.paddingExtraLarge.ph,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingExtraLarge,
                        right: AppDimens.paddingExtraLarge),
                    child: Text(
                      LabelKeys.flightDetails.tr,
                      style: onBackgroundTextStyleSemiBold(
                          fontSize: AppDimens.textLarge),
                    ),
                  ),
                  AppDimens.paddingExtraLarge.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: AppDimens.paddingExtraLarge,
                            right: AppDimens.paddingExtraLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activityDetailsModel.name ?? "",
                              style: onBackGroundTextStyleMedium(),
                            ),
                            AppDimens.paddingMedium.ph,
                            Text(
                              activityDetailsModel.arrivalFlightNumber ?? "",
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.veryLightAlfa),
                            ),
                            AppDimens.paddingMedium.ph,
                            Text(
                              DateFormat("MMM dd, yyyy").format(DateTime.parse(
                                  activityDetailsModel.eventDate.toString())),
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.veryLightAlfa),
                            ),
                            AppDimens.paddingMedium.ph,
                            Text(
                              DateFormat('hh:mm a').format(
                                  DateFormat('HH:mm:ss')
                                      .parse(activityDetailsModel.eventTime!)),
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.veryLightAlfa),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(IconPath.flightIcon),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: AppDimens.paddingExtraLarge,
                            right: AppDimens.paddingExtraLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              activityDetailsModel.name ?? "",
                              style: onBackGroundTextStyleMedium(),
                            ),
                            AppDimens.paddingMedium.ph,
                            Text(
                              activityDetailsModel.departureFlightNumber ?? "",
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.veryLightAlfa),
                            ),
                            AppDimens.paddingMedium.ph,
                            Text(
                              DateFormat("MMM dd, yyyy").format(DateTime.parse(
                                  activityDetailsModel.departureDate
                                      .toString())),
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.veryLightAlfa),
                            ),
                            AppDimens.paddingMedium.ph,
                            Text(
                              DateFormat('hh:mm a').format(
                                  DateFormat('HH:mm:ss').parse(
                                      activityDetailsModel.checkoutTime!)),
                              style: onBackgroundTextStyleRegular(
                                  alpha: Constants.veryLightAlfa),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  AppDimens.paddingExtraLarge.ph,
                  const Divider(),
                  AppDimens.paddingXLarge.ph,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingExtraLarge,
                        right: AppDimens.paddingExtraLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LabelKeys.flightDescription.tr,
                            style: onBackGroundTextStyleMedium(),
                            overflow: TextOverflow.ellipsis),
                        Text(activityDetailsModel.discription!,
                            maxLines: 2,
                            style: onBackgroundTextStyleRegular(
                                alpha: Constants.veryLightAlfa),
                            overflow: TextOverflow.ellipsis)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  activityHotelText(String image, String s) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimens.paddingExtraLarge,
          right: AppDimens.paddingExtraLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(image,
              style: onBackGroundTextStyleMedium(),
              overflow: TextOverflow.ellipsis),
          AppDimens.paddingMedium.pw,
          Text(s,
              style:
                  onBackgroundTextStyleRegular(alpha: Constants.veryLightAlfa),
              overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}
