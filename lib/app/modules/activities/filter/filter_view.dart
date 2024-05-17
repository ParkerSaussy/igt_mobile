import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_radio_button.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../master/networking/request_manager.dart';
import 'filter_controller.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
            leadingWidth: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            isCustomTitle: true,
            customTitleWidget: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: AppDimens.paddingMedium,
                    bottom: AppDimens.paddingMedium,
                    right: AppDimens.paddingMedium),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(IconPath.backArrow),
                    const SizedBox(
                      width: AppDimens.paddingMedium,
                    ),
                    Text(
                      LabelKeys.back.tr,
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textLarge),
                    )
                  ],
                ),
              ),
            ),
            actionWidget: [
              GestureDetector(
                  onTap: () {
                    controller.resetAll();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: Text(
                      LabelKeys.resetAll.tr,
                      style: generalTextStyleMedium(
                          color: Get.theme.colorScheme.onSecondary,
                          fontSize: AppDimens.textLarge),
                    ),
                  )),
            ]),
        body: Obx(
          () => Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingXXLarge),
                    child: Text(LabelKeys.filter.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textExtraLarge,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                  ),
                  AppDimens.paddingMedium.ph,
                  Expanded(
                    child: ContainerTopRoundedCorner(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingXXLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  gc.isOne.value = !gc.isOne.value;
                                },
                                child: itemCheckBox(
                                    gc.isOne.value, LabelKeys.dining.tr)),
                            AppDimens.paddingLarge.ph,
                            GestureDetector(
                                onTap: () {
                                  gc.isTwo.value = !gc.isTwo.value;
                                },
                                child: itemCheckBox(
                                    gc.isTwo.value, LabelKeys.flight.tr)),
                            AppDimens.paddingLarge.ph,
                            GestureDetector(
                                onTap: () {
                                  gc.isThree.value = !gc.isThree.value;
                                },
                                child: itemCheckBox(
                                    gc.isThree.value, LabelKeys.general.tr)),
                            AppDimens.paddingLarge.ph,
                            GestureDetector(
                                onTap: () {
                                  gc.isFour.value = !gc.isFour.value;
                                },
                                child: itemCheckBox(
                                    gc.isFour.value, LabelKeys.hotel.tr)),
                            AppDimens.paddingExtraLarge.ph,
                            Text(
                              LabelKeys.sortBy.tr,
                              style: onBackGroundTextStyleMedium(
                                  fontSize: AppDimens.textExtraLarge,
                                  alpha: Constants.darkAlfa),
                            ),
                            AppDimens.paddingSmall.ph,
                            MyRadioListTile<int>(
                              value: "0",
                              groupValue: gc.sortBy.value,
                              title: Text(LabelKeys.upcomingToLatest.tr,
                                  style: onBackGroundTextStyleMedium(
                                      fontSize: AppDimens.textLarge)),
                              onChanged: (value) {
                                gc.sortBy.value = value!;
                              },
                            ),
                            MyRadioListTile<int>(
                              value: "1",
                              groupValue: gc.sortBy.value,
                              title: Text(LabelKeys.hidePastEvents.tr,
                                  style: onBackGroundTextStyleMedium(
                                      fontSize: AppDimens.textLarge)),
                              onChanged: (value) {
                                gc.sortBy.value = value!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: AppDimens.paddingExtraLarge,
                  left: AppDimens.paddingExtraLarge,
                  right: AppDimens.paddingExtraLarge,
                  child: MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.apply.tr,
                    onPressed: () {
                      controller.apply();
                      Map<String, dynamic> result = {
                        'value1': controller.filter,
                        'value2': controller.sortByFilter,
                      };
                      Get.back(result: result);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemCheckBox(bool isEnable, String title) {
    return Row(
      children: [
        isEnable
            ? SvgPicture.asset(IconPath.checkBoxChecked,
                colorFilter: ColorFilter.mode(
                    Get.theme.colorScheme.primary, BlendMode.srcIn))
            : SvgPicture.asset(
                IconPath.unCheck,
              ),
        AppDimens.paddingLarge.pw,
        Text(
          title,
          style: onBackGroundTextStyleMedium(
              fontSize: AppDimens.textLarge, alpha: Constants.darkAlfa),
        ),
      ],
    );
  }
}
