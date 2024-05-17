import 'package:get/get.dart';

import 'select_trip_image_controller.dart';

class SelectTripImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectTripImageController>(() => SelectTripImageController(),
        fenix: true);
  }
}
