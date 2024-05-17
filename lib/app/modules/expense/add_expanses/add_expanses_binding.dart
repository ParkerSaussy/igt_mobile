import 'package:get/get.dart';

import 'add_expanses_controller.dart';

class AddExpansesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddExpansesController>(() => AddExpansesController(),
        fenix: true);
  }
}
