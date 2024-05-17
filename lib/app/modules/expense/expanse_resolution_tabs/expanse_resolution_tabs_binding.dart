import 'package:get/get.dart';

import 'expanse_activities/expanse_activities_controller.dart';
import 'expanse_resolution_tabs_controller.dart';
import 'expanse_resolutions/expanse_resolutions_controller.dart';

class ExpanseResolutionTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpanseResolutionTabsController>(
        () => ExpanseResolutionTabsController(),
        fenix: true);
    Get.lazyPut<ExpanseResolutionsController>(
        () => ExpanseResolutionsController(),
        fenix: true);
    Get.lazyPut<ExpanseActivitiesController>(
        () => ExpanseActivitiesController(),
        fenix: true);
  }
}
