import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_city_poll_model.dart';
import 'package:lesgo/app/modules/common_widgets/date_poll_item.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CityPollDetailItem extends StatelessWidget {
  const CityPollDetailItem({super.key, required this.tripDetailsCityPollModel});

  final TripDetailsCityPollModel tripDetailsCityPollModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimens.paddingSmall.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                tripDetailsCityPollModel.cityNameDetails?.isDefault == 1
                    ? "I can't make any of these locations"
                    : concatCityName(
                        tripDetailsCityPollModel.cityNameDetails?.cityName ??
                            "",
                        '',
                        tripDetailsCityPollModel.cityNameDetails?.countryName ??
                            "",
                        tripDetailsCityPollModel.cityNameDetails?.timeZone ??
                            ""),
                style: onBackGroundTextStyleMedium(
                    fontSize: AppDimens.textMedium, alpha: Constants.darkAlfa)),
            Text('${tripDetailsCityPollModel.totalVoted} ${LabelKeys.vote.tr}',
                style: primaryTextStyleMedium(
                    fontSize: AppDimens.textMedium, alpha: Constants.darkAlfa)),
          ],
        ),
        AppDimens.paddingSmall.ph,
        Text(
            '${tripDetailsCityPollModel.totalVoted} ${LabelKeys.of.tr} ${tripDetailsCityPollModel.totalGuest} ${LabelKeys.participantsVoted.tr}',
            style: onBackGroundTextStyleMedium(
                fontSize: AppDimens.textMedium,
                alpha: Constants.veryLightAlfa)),
        AppDimens.paddingSmall.ph,
        tripDetailsCityPollModel.totalGuest != 0
            ? StepProgressIndicator(
                totalSteps: tripDetailsCityPollModel.totalGuest!,
                currentStep: tripDetailsCityPollModel.totalVoted!,
                size: 6,
                padding: 0,
                selectedColor: IndicatorColor.indicatorColor(
                    tripDetailsCityPollModel.totalVip!,
                    tripDetailsCityPollModel.vipVoted!),
                unselectedColor: Get.theme.colorScheme.onBackground
                    .withAlpha(Constants.transparentAlpha),
                roundedEdges: const Radius.circular(AppDimens.radiusCorner),
              )
            : Container(),
        AppDimens.paddingMedium.ph,
        ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: tripDetailsCityPollModel.tripCityPolls!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return listItemProfile(
                tripDetailsCityPollModel.tripCityPolls![index]);
          },
        ),
        AppDimens.paddingMedium.ph,
        Divider(
          color:
              Get.theme.colorScheme.outline.withAlpha(Constants.veryLightAlfa),
        )
      ],
    );
  }

  Widget listItemProfile(TripCityPoll tripDatePoll) {
    final votedDate = Date.shared().convertFormatToFormat(
        tripDatePoll.createdAt!, 'yyyy-MM-dd hh:mm:ss.sss', 'yyyy-MM-dd hh:mm');
    final votedTime = Date.shared().convertFormatToFormat(
        tripDatePoll.createdAt!, 'yyyy-MM-dd hh:mm:ss.sss', 'hh:mm a');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CommonNetworkImage(
            imageUrl: tripDatePoll
                    .guestDetails!.usersDetailProfileImage?.profileImage ??
                '',
            height: AppDimens.songStickerSize,
            width: AppDimens.buttonHeightMedium,
            radius: AppDimens.radiusCorner,
          ),
          //Image.asset(ImagesPath.user3, fit: BoxFit.cover),
          AppDimens.paddingMedium.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      tripDatePoll.guestDetails!.firstName ?? "",
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textLarge),
                    ),
                    const SizedBox(
                      width: AppDimens.paddingMedium,
                    ),
                    Row(
                      children: [
                        tripDatePoll.guestDetails!.role == "Guest"
                            ? Container()
                            : Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffDFDBF8),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimens.radiusCircle))),
                                padding: const EdgeInsets.fromLTRB(
                                    AppDimens.paddingXLarge,
                                    AppDimens.paddingVerySmall,
                                    AppDimens.paddingXLarge,
                                    AppDimens.paddingVerySmall),
                                child: Text(
                                  tripDatePoll.guestDetails!.role ?? "",
                                  style: TextStyle(
                                      color: const Color(0xff22279F), // TODO
                                      fontSize: AppDimens.textSmall,
                                      fontFamily: Font.poppins500Medium),
                                ),
                              ),
                        AppDimens.paddingVerySmall.pw,
                        tripDatePoll.guestDetails!.isCoHost!
                            ? Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffDFDBF8),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppDimens.radiusCircle))),
                                padding: const EdgeInsets.fromLTRB(
                                    AppDimens.paddingXLarge,
                                    AppDimens.paddingVerySmall,
                                    AppDimens.paddingXLarge,
                                    AppDimens.paddingVerySmall),
                                child: Text(
                                  LabelKeys.coHost.tr,
                                  style: TextStyle(
                                      color: const Color(0xff22279F), // TODO
                                      fontSize: AppDimens.textSmall,
                                      fontFamily: Font.poppins500Medium),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              //AppDimens.paddingMedium.ph,
              Text(
                  "${Date.shared().dateConverter(votedDate, format: 'yyyy-MM-dd hh:mm')} $votedTime" /*'Today, 12:03 pm'*/,
                  style: onBackgroundTextStyleRegular(
                      fontSize: AppDimens.textMedium,
                      alpha: Constants.veryLightAlfa),
                  overflow: TextOverflow.ellipsis),
              AppDimens.paddingMedium.ph,
            ],
          ),
        ],
      ),
    );
  }

  /*String concatCityName(String cityName, String countryName, String timezone) {
    String finalCityName;
    finalCityName = cityName;
    if (countryName != "") {
      finalCityName = "$finalCityName, $countryName";
    }
    if (timezone != "") {
      finalCityName = "$finalCityName ($timezone)";
    }
    return finalCityName;
  }*/
}
