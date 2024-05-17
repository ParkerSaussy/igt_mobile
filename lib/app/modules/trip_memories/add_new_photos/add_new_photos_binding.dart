import 'package:get/get.dart';

import 'add_new_photos_controller.dart';

class AddNewPhotosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddNewPhotosController>(() => AddNewPhotosController(),
        fenix: true);
  }
}
