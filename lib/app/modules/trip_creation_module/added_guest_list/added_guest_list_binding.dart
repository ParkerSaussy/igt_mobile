import 'package:get/get.dart';

import 'added_guest_list_controller.dart';

class AddedGuestListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddedGuestListController>(() => AddedGuestListController(),
        fenix: true);
  }
}
