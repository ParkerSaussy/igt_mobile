import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import 'onboarding_screen_controller.dart';

class OnboardingScreenView extends GetView<OnboardingScreenController> {
  const OnboardingScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: CustomAppBar.buildAppBar(backgroundColor: Colors.transparent),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.lstSlides.length,
                restorationId: controller.restorationId.value,
                onPageChanged: (index) {
                  controller.currentIndex.value = index;
                },
                itemBuilder: (BuildContext context, int index) {
                  return buildStoryPage(index);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMedium,
                  vertical: AppDimens.paddingSmall),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Get.theme.colorScheme.inverseSurface,
                    Get.theme.colorScheme.inverseSurface
                        .withAlpha(Constants.mediumAlfa),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppDimens.paddingMedium.ph,
                  onBoardingTitle(controller.currentIndex.value),
                  AppDimens.paddingMedium.ph,
                  onBoardingSubTitle(controller.currentIndex.value),
                  //AppDimens.paddingXXLarge.ph,
                  AppDimens.paddingLarge.ph,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int dotIndex = 0;
                          dotIndex < controller.lstSlides.length;
                          dotIndex++)
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            height: AppDimens.bulletSize,
                            width: AppDimens.bulletSize,
                            decoration: BoxDecoration(
                              color: dotIndex == controller.currentIndex.value
                                  ? Get.theme.colorScheme.primary
                                  : Get.theme.colorScheme.onPrimary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(AppDimens.radiusCornerLarge),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: MasterButtonsBounceEffect.textButton(
                            textStyles: onPrimaryTextStyleMedium(
                                alpha: Constants.lightAlfa),
                            btnText: LabelKeys.skip.tr,
                            onPressed: () => controller.onSkip(),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: AppDimens.onBoardingNextButtonWidth,
                            margin: const EdgeInsets.symmetric(
                                horizontal: AppDimens.paddingLarge),
                            child: MasterButtonsBounceEffect.gradiantButton(
                              height: AppDimens.buttonHeightMedium,
                              btnText: controller.currentIndex.value !=
                                      controller.lstSlides.length - 1
                                  ? LabelKeys.next.tr
                                  : LabelKeys.itsGoTime.tr,
                              onPressed: () => controller.onNext(),
                            ),
                          ),
                        ),
                        AppDimens.paddingExtraLarge.pw
                      ],
                    ),
                  ),
                  AppDimens.paddingExtraLarge.ph,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildStoryPage(int index) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      child: /*!controller.isVideoPlaying.value
            ? */
          GestureDetector(
        onTap: () {
          if (controller.youTubeVideoUrls.isNotEmpty) {
            if (controller.youTubeVideoUrls[index].value != "") {
              controller.showYouTubePlayerDialog(
                  Get.context!, controller.youTubeVideoUrls[index].value!);
              //controller.isVideoPlaying.value = true;
              //controller.restorationId.value = getRandomString();
            }
          }
        },
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(
            controller.lstSlides[index],
            fit: BoxFit.fill,
          ),
          controller.youTubeVideoUrls.isNotEmpty
              ? controller.youTubeVideoUrls[index].value != ""
                  ? Positioned(
                      bottom: 5,
                      right: 5,
                      child: Column(
                        children: [
                          SvgPicture.asset(IconPath.youtubeIcon),
                          //Video Guide
                          Stack(
                            children: [
                              // Text without border
                              Text(
                                'Video Guide',
                                  style: onPrimaryTextStyleSemiBold(fontSize: AppDimens.textSmall).copyWith(color: Colors.black),
                              ),
                              // Text with border
                              // Text with border
                              Positioned(
                                top: 0.5, // Adjust the offset to control the border thickness
                                left: 0.5, // Adjust the offset to control the border thickness
                                child: Text(
                                  'Video Guide',
                                 style: onPrimaryTextStyleSemiBold(fontSize: AppDimens.textSmall).copyWith(color: Get.theme.colorScheme.primary),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
        ]),
      ),
      /*controller.youtubeLinks[index] != ""
                ? Positioned(
                    bottom: 5,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        controller.showYouTubePlayerDialog(
                            Get.context!, controller.youtubeLinks[index]);
                        //controller.isVideoPlaying.value = true;
                        //controller.restorationId.value = getRandomString();
                      },
                      child: Center(
                        child: SvgPicture.asset(
                          IconPath.youtubeIcon,
                          height: AppDimens.buttonHeight,
                          width: AppDimens.buttonHeight,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()*/
      /*],
        )*/
      /*: YoutubePlayer(
                controller: YoutubePlayerController(
                  flags: const YoutubePlayerFlags(
                      autoPlay: true, // You can customize autoplay behavior
                      controlsVisibleAtStart: true,
                      disableDragSeek: true,
                      showLiveFullscreenButton: false),
                  initialVideoId: controller.youtubeLinks[index],
                ),
                onEnded: (youtubeMetaData) {
                  controller.isVideoPlaying.value = false;
                  controller.restorationId.value = getRandomString();
                },
              )*/
    );
  }

  Widget onBoardingTitle(int index) {
    switch (index) {
      case 0:
        return Text(
          controller.onBoardingTitles[controller.currentIndex.value],
          textAlign: TextAlign.center,
          style: onPrimaryTextStyleSemiBold(fontSize: AppDimens.text2XLarge),
        );
      case 1:
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: LabelKeys.hitThe.tr,
                style:
                    onPrimaryTextStyleSemiBold(fontSize: AppDimens.text2XLarge),
              ),
              TextSpan(
                text: "CREATE EVENT/TRIP ",
                style:
                    primaryTextStyleSemiBold(fontSize: AppDimens.text2XLarge),
              ),
              TextSpan(
                text: LabelKeys.buttonAnd.tr,
                style:
                    onPrimaryTextStyleSemiBold(fontSize: AppDimens.text2XLarge),
              ),
              TextSpan(
                text: LabelKeys.writeUpYourEvent.tr,
                style:
                    onPrimaryTextStyleSemiBold(fontSize: AppDimens.text2XLarge),
              ),
            ],
          ),
        );
      default:
        return Text(
          controller.onBoardingTitles[controller.currentIndex.value],
          textAlign: TextAlign.center,
          style: onPrimaryTextStyleSemiBold(fontSize: AppDimens.text2XLarge),
        );
    }
  }
}

onBoardingSubTitle(int index) {
  switch (index) {
    case 0:
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
        child: Text(
          LabelKeys.getMaximumGuestsEvent.tr,
          textAlign: TextAlign.center,
          style: onPrimaryTextStyleMedium(fontSize: AppDimens.textMedium),
        ),
      );
    case 1:
      return IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bulletListString(LabelKeys.details.tr),
                bulletListString(LabelKeys.uploadAPicture.tr),
              ],
            ),
          ],
        ),
      );
    case 2:
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
        child: Text(
          LabelKeys.giveYourInviteesMsg.tr,
          textAlign: TextAlign.center,
          style: onPrimaryTextStyleMedium(fontSize: AppDimens.textMedium),
        ),
      );
    case 3:
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
        child: Text(
          LabelKeys.markVipMsg.tr,
          textAlign: TextAlign.center,
          style: onPrimaryTextStyleMedium(fontSize: AppDimens.textMedium),
        ),
      );
    case 4:
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bulletListString(LabelKeys.groupChat.tr),
                  bulletListString(LabelKeys.expenseTracker.tr),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //bulletListString('Party Location Tracking'),
                  bulletListString(LabelKeys.activityPlanners.tr),
                ],
              )
            ],
          ),
        ),
      );
  }
}

bulletListString(String text) {
  return Row(
    children: [
      Container(
        height: AppDimens.paddingSmall,
        width: AppDimens.paddingSmall,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Get.theme.colorScheme.onPrimary),
      ),
      AppDimens.paddingMedium.pw,
      Text(
        text,
        style: onPrimaryTextStyleMedium(fontSize: AppDimens.textMedium),
      )
    ],
  );
}
