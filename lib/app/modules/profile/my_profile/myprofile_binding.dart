import 'package:get/get.dart';

import 'myprofile_controller.dart';

class MyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyProfileController>(() => MyProfileController(), fenix: true);
  }
}
