import 'package:get/get.dart';

import 'chat_details_screen_controller.dart';

class ChatDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatDetailsScreenController>(
        () => ChatDetailsScreenController(),
        fenix: true);
  }
}
