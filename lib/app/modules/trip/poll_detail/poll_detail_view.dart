import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/trip/poll_detail/city_poll_details/city_poll_details_view.dart';
import 'package:lesgo/app/modules/trip/poll_detail/date_poll_details/date_poll_details_view.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import 'poll_detail_controller.dart';

class PollDetailView extends GetView<PollDetailController> {
  const PollDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          isCustomTitle: true,
          customTitleWidget: CustomAppBar.backButton(),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              top: AppDimens.padding3XLarge,
              child: ContainerTopRoundedCorner(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.paddingMedium),
                  child: Column(
                    children: [
                      TabBar(
                        controller: controller.tabBarController,
                        labelColor: Get.theme.colorScheme.primary,
                        indicatorColor: Get.theme.colorScheme.primary,
                        unselectedLabelColor: Get.theme.colorScheme.background,
                        labelStyle: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                        ),
                        unselectedLabelStyle: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textMedium,
                        ),
                        tabs: [
                          Tab(
                            text: LabelKeys.date.tr,
                          ),
                          Tab(
                            text: LabelKeys.city.tr,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingMedium),
                          child: TabBarView(
                            controller: controller.tabBarController,
                            children: const [
                              DatePollDetailsView(),
                              CityPollDetailsView(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingExtraLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LabelKeys.pollDetails.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textExtraLarge,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
