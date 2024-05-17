import 'package:get/get.dart';

import 'add_guest_import_controller.dart';

class AddGuestImportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddGuestImportController>(() => AddGuestImportController(),
        fenix: true);
  }
}
