import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_date_poll_model.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:signed_spacing_flex/signed_spacing_flex.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PollItem extends StatelessWidget {
  const PollItem(
      {Key? key,
      required this.pollModel,
      required this.index,
      required this.onSelect})
      : super(key: key);

  final TripDetailsDatePollModel pollModel;
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
                          pollModel.isDefault == 1
                              ? "I can't make any of these days"
                              : "${Date.shared().convertFormatToFormat(pollModel.startDate!, "yyyy-MM-dd hh:mm:ss", "dd MMM")}, "
                                  "${Date.shared().getDayNameFromDateTime(pollModel.startDate!)} ${LabelKeys.to.tr} "
                                  "${Date.shared().convertFormatToFormat(pollModel.endDate!, "yyyy-MM-dd hh:mm:ss", "dd MMM")}, "
                                  "${Date.shared().getDayNameFromDateTime(pollModel.endDate!)}",
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
                  AppDimens.paddingSmall.ph,
                  pollModel.totalGuest != 0
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

class IndicatorColor {
  static Color indicatorColor(totalVip, vipVoted) {
    if (totalVip == 0) {
      return Get.theme.colorScheme.error;
    } else if (vipVoted == 0) {
      return Get.theme.colorScheme.error;
    } else if (totalVip == vipVoted) {
      return Get.theme.colorScheme.primary;
    } else if (vipVoted < totalVip) {
      return Get.theme.colorScheme.secondary;
    } else {
      return Get.theme.colorScheme.onBackground
          .withAlpha(Constants.transparentAlpha);
    }
  }
}

/*VIEW FILE*/

/*
Padding(
padding: const EdgeInsets.only(left: AppDimens.paddingExtraLarge, right: AppDimens.paddingExtraLarge,bottom: AppDimens.paddingMedium),
child: Container(
decoration: const BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(AppDimens.radiusCorner)),
color: Colors.white,
),
child: Column(
children: [
Padding(
padding: const EdgeInsets.only(left: AppDimens.paddingExtraLarge, right: AppDimens.paddingExtraLarge, top: AppDimens.paddingMedium),
child: Column(
children: [
Row(
children: [
Expanded(
child: Text(
"Select one or more date",
style: onBackgroundTextStyleRegular(
alpha: Constants.lightAlfa
),
),
),
SvgPicture.asset(IconPath.infoIcon)
],
),
AppDimens.paddingMedium.ph,
Obx(() => AnimatedContainer(
duration: const Duration(milliseconds: 300),
curve: Curves.easeIn,
height: controller.isDatePollExpanded.value ? 200 : 80,
child: PollListView(
isDatePollExpanded: controller.isDatePollExpanded.value,
lstPollModel: controller.lstPollModel,
),
)),
],
),
),
AppDimens.paddingMedium.ph,
Container(
height: 1,
width: Get.width,
color: Get.theme.colorScheme.onBackground.withAlpha(Constants.limit),
),
Padding(
padding: const EdgeInsets.only(left: AppDimens.paddingExtraLarge, right: AppDimens.paddingExtraLarge),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
MasterButtonsBounceEffect.textButton(
btnText: "View Poll Details",
textStyles: primaryTextStyleMedium()
),
Obx(() => MasterButtonsBounceEffect.textButtonWithRightIcon(
iconPath: controller.isDatePollExpanded.value ? IconPath.upArrow : IconPath.downArrow,
btnText: "View All",
textStyles: onBackgroundTextStyleRegular(
alpha: Constants.transparentAlpha
),
onPressed: (){
if(controller.isDatePollExpanded.value){
controller.isDatePollExpanded.value = false;
}else{
controller.isDatePollExpanded.value = true;
}
}
))
],
),
)
],
),
),
),*/

/*Controller Code*/

/*

RxBool isDatePollExpanded = false.obs;

RxList<PollModel> lstPollModel = <PollModel>[].obs;

lstPollModel.add(PollModel(date: "16 to 18 Jun", totalPoll: 5, totalPolled: 60, groupValue: "0", indicatorColor: const Color(0xffE59B0B)));
lstPollModel.add(PollModel(date: "25 to 27 Jun", totalPoll: 5, totalPolled: 40, groupValue: "1", indicatorColor: const Color(0xffCC0E36)));
lstPollModel.add(PollModel(date: "01 to 07 July", totalPoll: 5, totalPolled: 80, groupValue: "1", indicatorColor: const Color(0xffE59B0B)));
lstPollModel.add(PollModel(date: "08 to 12 July", totalPoll: 5, totalPolled: 70, groupValue: "1", indicatorColor: const Color(0xffCC0E36)));
lstPollModel.add(PollModel(date: "13 to 19 July", totalPoll: 5, totalPolled: 20, groupValue: "1", indicatorColor: const Color(0xffE59B0B)));
*/
