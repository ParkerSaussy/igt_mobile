import 'package:get/get.dart';

import 'animated_splash_controller.dart';

class AnimatedSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnimatedSplashController>(() => AnimatedSplashController(),
        fenix: true);
  }
}
