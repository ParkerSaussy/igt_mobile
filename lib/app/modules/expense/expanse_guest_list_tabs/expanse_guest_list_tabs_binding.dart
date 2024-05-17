import 'package:get/get.dart';

import 'expanse_guest_list_tabs_controller.dart';

class ExpanseGuestListTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpanseGuestListTabsController>(
        () => ExpanseGuestListTabsController(),
        fenix: true);
  }
}
