import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/city_poll_detail_list.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

import 'city_poll_details_controller.dart';

class CityPollDetailsView extends GetView<CityPollDetailsController> {
  const CityPollDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.onPrimary,
      body: SafeArea(
        child: Obx(() => controller.isTripDetailsLoaded.value
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDimens.paddingMedium.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.tripDetailsModelObject!.tripName ?? "",
                            style: onBackGroundTextStyleMedium(
                                fontSize: AppDimens.textLarge,
                                alpha: Constants.darkAlfa)),
                        popupInfo(),
                      ],
                    ),
                    Divider(
                      color: Get.theme.colorScheme.outline
                          .withAlpha(Constants.lightAlfa),
                      thickness: AppDimens.paddingNano,
                    ),
                    Obx(() => controller.lstTripDetailsCityPoll.value.isNotEmpty
                        ? CityPollDetailList(
                            lstPollDetailCity:
                                controller.lstTripDetailsCityPoll.value,
                          )
                        : const SizedBox())
                  ],
                ))
            : const SizedBox()),
      ),
    );
  }

  Widget popupInfo() => Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: PopupMenuButton<int>(
          elevation: 1,
          shadowColor: Colors.black,
          padding: const EdgeInsets.all(5),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
          itemBuilder: (context) => [
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              value: 1,
              padding: const EdgeInsets.only(
                  left: AppDimens.textLarge, bottom: AppDimens.paddingTiny),
              child: itemMenu(LabelKeys.noVote.tr, Colors.grey),
            ),
            PopupMenuItem(
              height: AppDimens.paddingLarge,
              value: 2,
              padding: const EdgeInsets.only(
                  left: AppDimens.textLarge, bottom: AppDimens.paddingTiny),
              child: itemMenu(LabelKeys.allVIP.tr, Colors.green),
            ),
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              value: 3,
              padding: const EdgeInsets.only(
                  left: AppDimens.textLarge, bottom: AppDimens.paddingTiny),
              child: itemMenu(LabelKeys.noVIP.tr, Colors.red),
            ),
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              value: 4,
              padding: const EdgeInsets.only(left: AppDimens.textLarge),
              child: itemMenu(LabelKeys.atleastVIP.tr, Colors.yellow),
            ),
          ],
          child: SvgPicture.asset(IconPath.info),
        ),
      );

  Widget itemMenu(String title, Color colorName) {
    return Row(
      children: [
        Container(
          height: AppDimens.paddingMedium,
          width: AppDimens.paddingMedium,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.paddingMedium)),
              color: colorName),
        ),
        AppDimens.paddingSmall.pw,
        Text(title,
            style: onSurfaceTextStyleRegular(
                fontSize: AppDimens.textSmall, alpha: Constants.darkAlfa)),
      ],
    );
  }
}
