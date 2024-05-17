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

class ActivityDiningWidget extends StatelessWidget {
  const ActivityDiningWidget({super.key, required this.activityDetailsModel});

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
                      LabelKeys.diningDetails.tr,
                      style: onBackgroundTextStyleSemiBold(
                          fontSize: AppDimens.textLarge),
                    ),
                  ),
                  AppDimens.paddingExtraLarge.ph,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingExtraLarge,
                        right: AppDimens.paddingExtraLarge),
                    child: Text(
                      LabelKeys.diningName.tr,
                      style: onBackGroundTextStyleMedium(),
                    ),
                  ),
                  AppDimens.paddingMedium.ph,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingExtraLarge,
                        right: AppDimens.paddingExtraLarge),
                    child: Text(
                      activityDetailsModel.name ?? "",
                      style: onBackgroundTextStyleRegular(
                          alpha: Constants.veryLightAlfa),
                    ),
                  ),
                  AppDimens.paddingMedium.ph,
                  const Divider(),
                  AppDimens.paddingMedium.ph,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingExtraLarge,
                        right: AppDimens.paddingExtraLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LabelKeys.diningLocation.tr,
                            style: onBackgroundTextStyleRegular(),
                            overflow: TextOverflow.ellipsis),
                        Text(activityDetailsModel.address!,
                            maxLines: 2,
                            style: onBackgroundTextStyleRegular(
                                alpha: Constants.veryLightAlfa),
                            overflow: TextOverflow.ellipsis)
                      ],
                    ),
                  ),
                  AppDimens.paddingMedium.ph,
                  const Divider(),
                  activityHotelText(
                      LabelKeys.date.tr,
                      DateFormat("MMM dd, yyyy").format(DateTime.parse(
                          activityDetailsModel.eventDate.toString()))),
                  AppDimens.paddingLarge.ph,
                  activityHotelText(
                      LabelKeys.time.tr,
                      DateFormat('hh:mm a').format(DateFormat('HH:mm:ss')
                          .parse(activityDetailsModel.eventTime!))),
                  AppDimens.paddingLarge.ph,
                  activityHotelText(LabelKeys.costPerson.tr,
                      "\$ ${activityDetailsModel.cost.toString()}"),
                  AppDimens.paddingLarge.ph,
                  activityHotelText(LabelKeys.hoursToBeSpent.tr,
                      "${activityDetailsModel.spentHours.toString()} Hours"),
                  AppDimens.paddingMedium.ph,
                  const Divider(),
                  AppDimens.paddingXLarge.ph,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingExtraLarge,
                        right: AppDimens.paddingExtraLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LabelKeys.diningDescription.tr,
                            style: onBackgroundTextStyleRegular(),
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
              style: onBackgroundTextStyleRegular(),
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
