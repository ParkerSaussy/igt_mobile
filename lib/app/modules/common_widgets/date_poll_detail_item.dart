import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_date_poll_model.dart';
import 'package:lesgo/app/modules/common_widgets/date_poll_item.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DatePollDetailsItem extends StatelessWidget {
  const DatePollDetailsItem(
      {super.key, required this.tripDetailsDatePollModel});

  final TripDetailsDatePollModel tripDetailsDatePollModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      tripDetailsDatePollModel.isDefault == 1
                          ? "I can't make any of these days"
                          : Date.shared()
                              .format(tripDetailsDatePollModel.startDate!),
                      overflow: TextOverflow.ellipsis,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.darkAlfa)),
                  Text(
                      Date.shared().getTwelveHourTime(
                          tripDetailsDatePollModel.startDate!),
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.veryLightAlfa)),
                ],
              ),
            ),
            Flexible(child: SvgPicture.asset(IconPath.arrowLong)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(Date.shared().format(tripDetailsDatePollModel.endDate!),
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.darkAlfa)),
                  Text(
                      Date.shared()
                          .getTwelveHourTime(tripDetailsDatePollModel.endDate!),
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.veryLightAlfa)),
                ],
              ),
            ),
          ],
        ),
        AppDimens.paddingMedium.ph,
        Text(
            '${tripDetailsDatePollModel.totalVoted} ${LabelKeys.of.tr} ${tripDetailsDatePollModel.totalGuest} ${LabelKeys.participantsVoted.tr}',
            style: onBackGroundTextStyleMedium(
                fontSize: AppDimens.textMedium,
                alpha: Constants.veryLightAlfa)),
        AppDimens.paddingMedium.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: tripDetailsDatePollModel.totalGuest != 0
                  ? StepProgressIndicator(
                      totalSteps: tripDetailsDatePollModel.totalGuest!,
                      currentStep: tripDetailsDatePollModel.totalVoted!,
                      size: 6,
                      padding: 0,
                      selectedColor: IndicatorColor.indicatorColor(
                          tripDetailsDatePollModel.totalVip!,
                          tripDetailsDatePollModel.vipVoted!),
                      unselectedColor: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.transparentAlpha),
                      roundedEdges:
                          const Radius.circular(AppDimens.radiusCorner),
                    )
                  : const SizedBox(),
            ),
            AppDimens.paddingMedium.pw,
            Text('${tripDetailsDatePollModel.totalVoted} ${LabelKeys.vote.tr}',
                style: primaryTextStyleMedium(
                    fontSize: AppDimens.textMedium, alpha: Constants.darkAlfa)),
          ],
        ),
        tripDetailsDatePollModel.tripDatePolls!.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: tripDetailsDatePollModel.tripDatePolls!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return tripDetailsDatePollModel.tripDatePolls != []
                      ? listItemProfile(
                          tripDetailsDatePollModel.tripDatePolls![index])
                      : SizedBox();
                },
              )
            : const SizedBox(),
        AppDimens.paddingMedium.ph,
        Container(
          width: Get.width,
          decoration: BoxDecoration(
              border: Border.all(
                width: AppDimens.paddingNano,
                color: Get.theme.colorScheme.background
                    .withAlpha(Constants.veryLightAlfa),
              ),
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.paddingMedium))),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LabelKeys.comments.tr,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textMedium,
                        alpha: Constants.darkAlfa)),
                Text(tripDetailsDatePollModel.comment ?? "",
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textMedium,
                        alpha: Constants.veryLightAlfa)),
              ],
            ),
          ),
        ),
        AppDimens.paddingMedium.ph,
        Divider(
          color: Get.theme.colorScheme.outline.withAlpha(Constants.darkAlfa),
        ),
        AppDimens.paddingMedium.ph,
      ],
    );
  }

  Widget listItemProfile(TripDatePoll tripDatePoll) {
    final votedDate = Date.shared().convertFormatToFormat(
        tripDatePoll.createdAt! as DateTime,
        'yyyy-MM-dd hh:mm:ss.sss',
        'yyyy-MM-dd hh:mm');
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
                            ? const SizedBox()
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
                            : const SizedBox(),
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
}
