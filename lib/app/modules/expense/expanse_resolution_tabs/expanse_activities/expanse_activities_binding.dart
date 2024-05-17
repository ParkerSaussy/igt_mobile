import 'package:get/get.dart';

import 'expanse_activities_controller.dart';

class ExpanseActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpanseActivitiesController>(
        () => ExpanseActivitiesController(),
        fenix: true);
  }
}
