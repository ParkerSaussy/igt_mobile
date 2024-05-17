import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/expense/expanse_resolution_tabs/expanse_activities/expanse_activities_view.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/session/preference.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import 'expanse_resolution_tabs_controller.dart';
import 'expanse_resolutions/expanse_resolutions_view.dart';

class ExpanseResolutionTabsView
    extends GetView<ExpanseResolutionTabsController> {
  const ExpanseResolutionTabsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (Preference.isGetNotification()) {
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            Get.back();
          }
          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar.buildAppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              isCustomTitle: true,
              customTitleWidget: CustomAppBar.backButton(onBack: () {
                if (Preference.isGetNotification()) {
                  Get.offAllNamed(Routes.DASHBOARD);
                } else {
                  Get.back();
                }
              }),
              actionWidget: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingMedium),
                    child: controller.tabBarIndex.value == 1
                        ? Bounce(
                            duration: const Duration(
                                milliseconds: Constants.bounceDuration),
                            onPressed: () {
                              controller.shareExpanseReport();
                            },
                            child: SvgPicture.asset(IconPath.shareIcon))
                        : const SizedBox(),
                  ),
                )
              ]),
          body: ContainerTopRoundedCorner(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: AppDimens.paddingExtraLarge,
                  right: AppDimens.paddingExtraLarge),
              child: Column(
                children: [
                  AppDimens.paddingMedium.ph,
                  TabBar(
                    controller: controller.tabController,
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
                        text: LabelKeys.activities.tr,
                      ),
                      Tab(
                        text: LabelKeys.resolution.tr,
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: const [
                        ExpanseActivitiesView(),
                        ExpanseResolutionsView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
