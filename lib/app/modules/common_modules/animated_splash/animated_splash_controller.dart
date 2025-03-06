import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

import '../../../../master/general_utils/common_stuff.dart';

class AnimatedSplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //Aanand
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOutCubicEmphasized,
  );
  var refreshString = "".obs;
  RxDouble topMargin = 10.0.obs;
  RxDouble rightMargin = (Get.width / 2).obs;
  RxDouble leftMargin = (Get.width / 2).obs;
  Rx<Curve> logoAnimationCurve = Curves.fastOutSlowIn.obs;
  late String initialLink;
  StreamSubscription? sub;

  //Raj
  //RxDouble foldValue = 0.001.obs;

  @override
  /// This function is called when the widget is initialized.
  /// It initializes the UniLink library and sets up the
  /// animation of the logo.
  ///
  /// It first moves the logo to the middle of the screen
  /// and then makes it bigger and smaller in a loop.
  /// When the animation is done, it sets the position of the
  /// logo to the top of the screen and makes it smaller.
  void onInit() {
    super.onInit();
    initUniLinks();
    //Raj
    /*Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (foldValue.value < 0.98) {
        foldValue.value = foldValue.value + 0.001;
        print(foldValue.value);
      } else {
        foldValue.value = 1;
        timer.cancel();
      }
    });*/

    // Aanand
    Future.delayed(const Duration(milliseconds: 400), () {
      printMessage("FIRST");
      topMargin(Get.height / 3.5);
      leftMargin(20);
      rightMargin(20);
    }).whenComplete(
      () => Future.delayed(const Duration(milliseconds: 600), () {
        printMessage("SECOND");
        logoAnimationCurve(Curves.fastOutSlowIn);
        topMargin(Get.height / 5);
        leftMargin(Get.width / 4);
        rightMargin(Get.width / 4);
      }),
    );
  }

  /// Initialize the universal links listener
  ///
  /// The listener listens for universal links and prints the link to the
  /// console. If an error occurs, it prints the error to the console.
  ///
  /// The listener is not canceled when the widget is disposed, so it must be
  /// manually canceled when it is no longer needed.
  Future<void> initUniLinks() async {
    sub = uriLinkStream.listen((Uri? link) {
      printMessage("initialLink: $link");
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }
}
