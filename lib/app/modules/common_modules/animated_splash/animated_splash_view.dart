import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/lrf/biomateric_auth.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/session/preference.dart';

import '../../../routes/app_pages.dart';
import 'animated_splash_controller.dart';

class AnimatedSplashView extends GetView<AnimatedSplashController> {
  const AnimatedSplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(51, 177, 112, 1),
      body:

          //Raj
          /* Center(
          child: Obx(
            () => PaperFold(
              mainAxis: PaperFoldMainAxis.horizontal,
              strips: 6,
              foldValue: controller.foldValue.value,
              pixelRatio:
                  1, //works best if you query the device pixel ration with MediaQuery.of
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width / 4),
                  // height: 150,
                  child: SvgPicture.asset(ImagesPath.lesGoLogoSvg),
                ),
              ),
            ),
          ),
        )*/

          Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              top: controller.topMargin.value,
              right: controller.rightMargin.value,
              left: controller.leftMargin.value,
              duration: const Duration(milliseconds: 1000),
              curve: controller.logoAnimationCurve.value,
              onEnd: () {
                if (!Preference.isGetNotification()) {
                  if (Preference.getIsLogin()) {
                    Get.offAll(BiomatericAuth());
                    //Get.offAllNamed(Routes.DASHBOARD);
                  } else {
                    if (Preference.getIsSkipOnBoarding()) {
                      Get.offAllNamed(Routes.LOGIN);
                    } else {
                      Get.offAllNamed(Routes.ONBOARDING_SCREEN,
                          arguments: false);
                    }
                  }
                } else {
                  Preference.isSetNotification(true);
                }
              },
              child: //Image.asset("assets/images/splash_logo.png"),
                  SvgPicture.asset(ImagesPath.lesGoLogoSvgLarge),
            ),
          ),
        ],
      ),
    );
  }
}
