import 'package:get/get.dart';

import 'add_activities_screen_controller.dart';

class AddActivitiesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddActivitiesScreenController>(
        () => AddActivitiesScreenController(),
        fenix: true);
  }
}
