import 'package:get/get.dart';

import 'trip_detail_controller.dart';

class TripDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripDetailController>(() => TripDetailController(),
        fenix: true);
  }
}
