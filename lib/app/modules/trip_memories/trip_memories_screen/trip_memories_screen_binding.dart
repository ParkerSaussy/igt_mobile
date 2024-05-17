import 'package:get/get.dart';

import 'trip_memories_screen_controller.dart';

class TripMemoriesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripMemoriesScreenController>(
        () => TripMemoriesScreenController(),
        fenix: true);
  }
}
