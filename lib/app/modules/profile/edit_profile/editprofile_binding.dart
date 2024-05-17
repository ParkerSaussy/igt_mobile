import 'package:get/get.dart';

import 'editprofile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController(),
        fenix: true);
  }
}
