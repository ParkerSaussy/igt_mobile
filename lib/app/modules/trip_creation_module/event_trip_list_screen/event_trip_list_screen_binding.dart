import 'package:get/get.dart';

import 'event_trip_list_screen_controller.dart';

class EventTripListScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventTripListScreenController>(
        () => EventTripListScreenController(),
        fenix: true);
  }
}
