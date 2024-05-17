import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import 'about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          isCustomTitle: true,
          customTitleWidget: Padding(
            padding: const EdgeInsets.only(
                top: AppDimens.paddingMedium,
                bottom: AppDimens.paddingMedium,
                right: AppDimens.paddingMedium),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, right: AppDimens.paddingMedium),
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
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => controller.requestType.value == LabelKeys.aboutus.tr
                      ? Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            ImagesPath.lesGoLogoSvg,
                            height: 50,
                            width: 140,
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Column(
                  children: [
                    controller.requestType.value == LabelKeys.aboutus.tr
                        ? AppDimens.paddingExtraLarge.ph
                        : 0.ph,
                    controller.requestType.value == LabelKeys.aboutus.tr
                        ? Stack(
                            children: [
                              Image.asset(
                                ImagesPath.imgAboutUs,
                              ),
                              Container(
                                height: 173,
                                width: Get.width,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Get.theme.colorScheme.scrim
                                          .withOpacity(0.4),
                                      Get.theme.colorScheme.scrim
                                          .withOpacity(0.4),
                                    ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter)),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              AppDimens.paddingExtraLarge.ph,
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingExtraLarge),
                child: Text(controller.requestType.value,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textExtraLarge,
                        alpha: Constants.darkAlfa),
                    overflow: TextOverflow.ellipsis),
              ),
              AppDimens.paddingSmall.ph,
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppDimens.radiusCircle),
                      topRight: Radius.circular(AppDimens.radiusCircle)),
                  child: ContainerTopRoundedCorner(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: AppDimens.paddingExtraLarge,
                        right: AppDimens.paddingExtraLarge,
                      ),
                      child: controller.termscond.value.isEmpty
                          ? Container()
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  AppDimens.paddingExtraLarge.ph,
                                  Html(
                                      data: controller.termscond.value,
                                      onLinkTap: (url, attributes, document) {
                                        printMessage(url!);
                                        launchUrl(Uri.parse(url));
                                        //open URL in webview, or launch URL in browser, or any other logic here
                                      }),
                                  AppDimens.paddingLarge.ph,

                                  // I AGREE BUTTON
                                  MasterButtonsBounceEffect.gradiantButton(
                                      onPressed: () {
                                        Get.back(result: {
                                          "requestType":
                                              controller.requestType.value,
                                          "status": true
                                        });
                                      },
                                      btnText: controller.from.value ==
                                              Constants.fromSignUp
                                          ? LabelKeys.iAgree.tr
                                          : LabelKeys.goToHome.tr),
                                  controller.from.value == Constants.fromSignUp
                                      ?
                                      // CANCEL BUTTON
                                      MasterButtonsBounceEffect.textButton(
                                          onPressed: () {
                                            Get.back(result: {
                                              "requestType":
                                                  controller.requestType.value,
                                              "status": false
                                            });
                                          },
                                          textStyles:
                                              onBackgroundTextStyleRegular(),
                                          btnText: LabelKeys.cancel.tr)
                                      : const SizedBox(),
                                  AppDimens.paddingExtraLarge.ph,
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
