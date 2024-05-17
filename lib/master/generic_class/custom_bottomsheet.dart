import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/constants.dart';
import '../general_utils/images_path.dart';
import '../general_utils/label_key.dart';
import '../general_utils/text_styles.dart';
import 'master_buttons_bounce_effect.dart';

class CustomBottomSheet {
  /*
     customBottomSheet : This view is used for display bottom action UI with dynamic list/icons.
     Arguments:
      - context: (Required)
      - data: list for text message and icon (Required)
      - title: Bottom sheet title (default blank)
      - isDismiss: when false then sheet not closed outside clicked (default - true)
      - onPressed: Callback of bottomSheet item clicked (Required)
      NOTE - shape: it is used for curve of topLeft and topRight corner
           - barrierColor: outside sheet color
  */

  static show(
      {required BuildContext context,
      String title = '',
      String desc = '',
      bool isDismiss = true,
      required Function onPressed}) {
    return showModalBottomSheet(
        elevation: 0,
        useSafeArea: true,
        isDismissible: isDismiss,
        backgroundColor: context.theme.colorScheme.surface,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radiusCircle),
            topRight: Radius.circular(AppDimens.radiusCircle),
          ),
        ),
        context: context,
        builder: (context) {
          return Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppDimens.paddingXXLarge.ph,
              Container(
                width: AppDimens.buttonHeightMedium,
                height: 4,
                decoration: BoxDecoration(
                    color: Get.theme.dividerColor.withAlpha(Constants.limit),
                    borderRadius:
                        BorderRadius.circular(AppDimens.paddingExtraLarge),
                    border: Border.all(
                        color:
                            Get.theme.dividerColor.withAlpha(Constants.limit)),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.dividerColor,
                        blurRadius: AppDimens.paddingTiny,
                      ),
                    ]),
              ),
              AppDimens.paddingLarge.ph,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: AppDimens.paddingExtraLarge),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        IconPath.closeRoundedIcon,
                        width: AppDimens.paddingExtraLarge,
                        height: AppDimens.paddingExtraLarge,
                      )),
                ),
              ),
              AppDimens.paddingLarge.ph,
              SvgPicture.asset(IconPath.contactusImg),
              AppDimens.songStickerSize.ph,
              Text(
                desc,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              AppDimens.paddingXXLarge.ph,
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingExtraLarge),
                  child: MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.ok.tr,
                    onPressed: () {
                      Get.back();
                    },
                  )),
            ],
          );
        });
  }

  static showBottomList(
      {required BuildContext context,
      String title = '',
      String desc = '',
      bool isDismiss = true,
      required Widget data,
      required Function onPressed}) {
    return showModalBottomSheet(
        elevation: 0,
        useSafeArea: true,
        isDismissible: isDismiss,
        backgroundColor: context.theme.colorScheme.surface,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radiusCircle),
            topRight: Radius.circular(AppDimens.radiusCircle),
          ),
        ),
        context: context,
        builder: (context) {
          return Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppDimens.paddingXXLarge.ph,
              Container(
                width: AppDimens.buttonHeightMedium,
                height: 4,
                decoration: BoxDecoration(
                    color: Get.theme.dividerColor.withAlpha(Constants.limit),
                    borderRadius:
                        BorderRadius.circular(AppDimens.paddingExtraLarge),
                    border: Border.all(
                        color:
                            Get.theme.dividerColor.withAlpha(Constants.limit)),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.dividerColor,
                        blurRadius: AppDimens.paddingTiny,
                      ),
                    ]),
              ),
              AppDimens.paddingLarge.ph,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: AppDimens.paddingExtraLarge),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        IconPath.closeRoundedIcon,
                        width: AppDimens.paddingExtraLarge,
                        height: AppDimens.paddingExtraLarge,
                      )),
                ),
              ),
              AppDimens.paddingLarge.ph,
              data,
            ],
          );
        });
  }
}
