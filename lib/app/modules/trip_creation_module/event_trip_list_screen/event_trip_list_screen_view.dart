import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/event_trip_list.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';

import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import 'event_trip_list_screen_controller.dart';

class EventTripListScreenView extends GetView<EventTripListScreenController> {
  const EventTripListScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          backgroundColor: Get.theme.colorScheme.primary,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          automaticallyImplyLeading: false,
          isCustomTitle: true,
          customTitleWidget: CustomAppBar.backButton(
              iconColor: Get.theme.colorScheme.onPrimary,
              textStyle: onPrimaryTextStyleMedium()),
        ),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppDimens.radiusCircle),
                        bottomRight: Radius.circular(AppDimens.radiusCircle))),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LabelKeys.eventTripList.tr,
                      style: onPrimaryTextStyleMedium(
                          fontSize: AppDimens.textLarge),
                    ),
                    const SizedBox(
                      height: AppDimens.paddingLarge,
                    ),
                    CustomTextField(
                      onChanged: (value) {
                        controller.lstTripSearch.value = controller.lstTrip
                            .where((element) => element.tripName
                                .toString()
                                .toLowerCase()
                                .contains(value.toString().toLowerCase()))
                            .toList();
                        controller.restorationId.value = getRandomString();
                      },
                      textInputAction: TextInputAction.search,
                      inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.radiusCorner))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.radiusCorner))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppDimens.radiusCorner))),
                        contentPadding: const EdgeInsets.fromLTRB(
                            0, 18, AppDimens.paddingExtraLarge, 15),
                        hintText: LabelKeys.search.tr,
                        isFilled: true,
                        fillColor: Get.theme.colorScheme.onPrimary,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              //top: AppDimens.paddingLarge,
                              //right: AppDimens.paddingLarge,
                              //bottom: AppDimens.paddingLarge,
                              left: AppDimens.paddingMedium),
                          child: SvgPicture.asset(IconPath.searchIcon),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppDimens.paddingExtraLarge,
                    ),
                    Expanded(
                      child: Obx(() => controller.isTripFetch.value
                          ? controller.lstTripSearch.isNotEmpty
                              ? EventTripList(
                                  restorationId: controller.restorationId.value,
                                  lstTrip: controller.lstTripSearch.value,
                                  onTap: (index) {
                                    Get.toNamed(Routes.TRIP_GUEST_LIST,
                                        arguments: [
                                          controller.lstTripSearch[index],
                                          controller.tripId,
                                          controller.isHostOrCoHost.value,
                                          controller.isTripFinalized.value
                                        ]);
                                  },
                                )
                              : const NoRecordFound()
                          : controller.isDataLoading.value
                              ? const SizedBox()
                              : const NoRecordFound()),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
