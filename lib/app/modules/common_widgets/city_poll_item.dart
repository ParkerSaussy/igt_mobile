import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_city_poll_model.dart';
import 'package:lesgo/app/modules/common_widgets/date_poll_item.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CityPollItem extends StatelessWidget {
  const CityPollItem(
      {Key? key,
      required this.pollModel,
      required this.index,
      required this.onSelect})
      : super(key: key);

  final TripDetailsCityPollModel pollModel;
  final int index;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pollModel.userVoted! == 1
                ? SvgPicture.asset(
                    IconPath.radioCheckedGreen,
                    height: AppDimens.smallIconSize,
                  )
                : SvgPicture.asset(
                    IconPath.radioUncheckWhite,
                    height: AppDimens.smallIconSize,
                  ),
            AppDimens.paddingLarge.pw,
            Flexible(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pollModel.cityNameDetails?.isDefault == 1
                              ? "I can't make any of these locations"
                              : concatCityName(
                                  pollModel.cityNameDetails?.cityName ?? "",
                                  '',
                                  pollModel.cityNameDetails?.countryName ?? "",
                                  pollModel.cityNameDetails?.timeZone ?? ""),
                          style: onBackGroundTextStyleMedium(
                              fontSize: AppDimens.textSmall),
                        ),
                      ),
                      SignedSpacingFlex(
                        direction: Axis.horizontal,
                        spacing: -10,
                        stackingOrder: StackingOrder.lastOnTop,
                        children: [
                          for (int i = 0; i < pollModel.userImage!.length; i++)
                            CommonNetworkImage(
                              height: AppDimens.smallIconSize,
                              width: AppDimens.smallIconSize,
                              imageUrl: pollModel.userImage![i],
                            )
                        ],
                      ),
                      AppDimens.paddingMedium.pw,
                      Text(
                        pollModel.totalVoted!.toString(),
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textSmall),
                      )
                    ],
                  ),
                  pollModel.totalGuest! > 0 ? AppDimens.paddingSmall.ph : 0.ph,
                  pollModel.totalGuest! > 0
                      ? StepProgressIndicator(
                          totalSteps: pollModel.totalGuest!,
                          currentStep: pollModel.totalVoted!,
                          size: 6,
                          padding: 0,
                          selectedColor: IndicatorColor.indicatorColor(
                              pollModel.totalVip!, pollModel.vipVoted!),
                          unselectedColor: Get.theme.colorScheme.onBackground
                              .withAlpha(Constants.transparentAlpha),
                          roundedEdges:
                              const Radius.circular(AppDimens.radiusCorner),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
