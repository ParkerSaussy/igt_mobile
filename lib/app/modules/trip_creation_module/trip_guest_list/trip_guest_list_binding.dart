import 'package:get/get.dart';

import 'trip_guest_list_controller.dart';

class TripGuestListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripGuestListController>(() => TripGuestListController(),
        fenix: true);
  }
}
