import 'package:get/get.dart';
import 'package:lesgo/app/modules/lrf/signup/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
      () => SignupController(),
    );
  }
}
