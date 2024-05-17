import 'package:get/get.dart';

import 'city_poll_details_controller.dart';

class CityPollDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CityPollDetailsController>(() => CityPollDetailsController(),
        fenix: true);
  }
}
