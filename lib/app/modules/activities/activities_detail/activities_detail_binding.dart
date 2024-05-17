import 'package:get/get.dart';

import 'activities_detail_controller.dart';

class ActivitiesDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivitiesDetailController>(() => ActivitiesDetailController(),
        fenix: true);
  }
}
