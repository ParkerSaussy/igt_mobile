import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';

import '../../common_widgets/bottomsheet_with_close.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: onBackgroundTextStyleRegular(),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          color: Get.theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingLarge),
            child: Text(
                "${LabelKeys.version.tr} ${Preference.getVersionCode()}",
                style:
                    onBackgroundTextStyleRegular(alpha: Constants.lightAlfa)),
          )),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: Text(LabelKeys.settings.tr,
                  style: onBackGroundTextStyleMedium(
                      fontSize: AppDimens.textExtraLarge,
                      alpha: Constants.darkAlfa),
                  overflow: TextOverflow.ellipsis),
            ),
            AppDimens.paddingMedium.ph,
            Expanded(
              child: ContainerTopRoundedCorner(
                child: ScrollViewRoundedCorner(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDimens.paddingXXLarge.ph,
                      InkWell(
                          onTap: () {
                            Get.toNamed(Routes.MYPROFILE,
                                arguments: Constants.fromSettings);
                          },
                          child: SizedBox(
                              width: Get.width,
                              child: buildText(LabelKeys.profile.tr))),
                      dividerLine(),
                      buildText(LabelKeys.notifications.tr),
                      //AppDimens.paddingMedium.ph,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            buildToggle(
                                LabelKeys.allNotifications.tr,
                                controller.isAllNotifications.value,
                                onBackGroundTextStyleMedium(
                                    alpha: Constants.veryLightAlfa),
                                onChanged: (value) {
                              controller.isAllNotifications.value = value;
                              controller.updateNotificationStatus();
                            }),
                            AppDimens.paddingMedium.ph,
                            buildToggle(
                                LabelKeys.chatNotifications.tr,
                                controller.isChatNotifications.value,
                                onBackGroundTextStyleMedium(
                                    alpha: Constants.veryLightAlfa),
                                onChanged: (value) {
                              controller.isChatNotifications.value = value;
                              controller.updateNotificationStatus();
                              if (value) {
                                FirebaseFirestore.instance
                                    .collection(
                                        FireStoreCollection.usersCollection)
                                    .doc(gc.loginData.value.id.toString())
                                    .update({
                                  FireStoreParams.fcmToken:
                                      Preference.getFirebaseToken()
                                });
                              } else {
                                FirebaseFirestore.instance
                                    .collection(
                                        FireStoreCollection.usersCollection)
                                    .doc(gc.loginData.value.id.toString())
                                    .update({FireStoreParams.fcmToken: ''});
                              }
                            }),
                          ],
                        ),
                      ),
                      dividerLine(),
                      InkWell(
                          onTap: () {
                            Get.toNamed(Routes.SUBSCRIPTION_PLAN_SCREEN);
                          },
                          child: SizedBox(
                              width: Get.width,
                              child: buildText(LabelKeys.subscription.tr))),
                      dividerLine(),
                      InkWell(
                          onTap: () {
                            Get.toNamed(Routes.HELP_SCREEN);
                          },
                          child: SizedBox(
                              width: Get.width,
                              child: buildText(LabelKeys.help.tr))),
                      dividerLine(),
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            isScrollControlled: true,
                            BottomSheetWithClose(widget: successBottomSheet()),
                          );
                        },
                        child: SizedBox(
                            width: Get.width,
                            child: buildText(LabelKeys.signOut.tr)),
                      ),
                      dividerLine(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildToggle(String title, bool isSelected, TextStyle? textStyle,
      {required Function onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildText(title, textStyle: textStyle),
        CupertinoSwitch(
          value: isSelected,
          onChanged: (value) {
            onChanged(value);
          },
        )
        /*isSelected
            ? SvgPicture.asset(IconPath.toggleOnIcon)
            : SvgPicture.asset(IconPath.toggleIcon)*/
      ],
    );
  }

  Widget dividerLine() {
    return Divider(color: Get.theme.colorScheme.outline);
  }

  Widget buildText(String title, {TextStyle? textStyle}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimens.paddingLarge.ph,
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingExtraLarge),
          child: Text(title,
              style: textStyle ??
                  onBackGroundTextStyleMedium(
                      fontSize: AppDimens.textLarge, alpha: Constants.darkAlfa),
              overflow: TextOverflow.ellipsis),
        ),
        AppDimens.paddingLarge.ph,
      ],
    );
  }

  Widget successBottomSheet() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppDimens.paddingLarge.ph,
          SvgPicture.asset(IconPath.logoutIcon),
          AppDimens.paddingLarge.ph,
          Text(
            LabelKeys.logoutConformationMessage.tr,
            style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
          ),
          AppDimens.paddingLarge.ph,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingLarge),
                    child: MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.yes.tr,
                      onPressed: () {
                        Get.back();
                        controller.logoutApi();
                      },
                    )),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingLarge),
                  child: MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.no.tr,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ],
          ),
          AppDimens.padding3XLarge.ph,
        ],
      ),
    );
  }
}
