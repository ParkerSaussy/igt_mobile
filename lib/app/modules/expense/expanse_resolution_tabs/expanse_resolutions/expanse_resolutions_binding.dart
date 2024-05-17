import 'package:get/get.dart';

import 'expanse_resolutions_controller.dart';

class ExpanseResolutionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpanseResolutionsController>(
      () => ExpanseResolutionsController(),
    );
  }
}
