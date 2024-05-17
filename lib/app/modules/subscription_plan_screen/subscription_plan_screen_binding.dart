import 'package:get/get.dart';

import 'subscription_plan_screen_controller.dart';

class SubscriptionPlanScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionPlanScreenController>(
        () => SubscriptionPlanScreenController(),
        fenix: true);
  }
}
