import 'package:get/get.dart';

import 'search_contact_screen_controller.dart';

class SearchContactScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchContactScreenController>(
        () => SearchContactScreenController(),
        fenix: true);
  }
}
