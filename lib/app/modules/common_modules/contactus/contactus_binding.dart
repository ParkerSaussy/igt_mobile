import 'package:get/get.dart';

import 'contactus_controller.dart';

class ContactusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactusController>(() => ContactusController(), fenix: true);
  }
}
