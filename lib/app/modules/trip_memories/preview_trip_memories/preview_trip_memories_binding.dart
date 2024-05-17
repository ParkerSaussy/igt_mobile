import 'package:get/get.dart';

import 'preview_trip_memories_controller.dart';

class PreviewTripMemoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreviewTripMemoriesController>(
        () => PreviewTripMemoriesController(),
        fenix: true);
  }
}
