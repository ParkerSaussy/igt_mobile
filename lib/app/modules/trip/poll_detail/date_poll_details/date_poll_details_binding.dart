import 'package:get/get.dart';

import 'date_poll_details_controller.dart';

class DatePollDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatePollDetailsController>(() => DatePollDetailsController(),
        fenix: true);
  }
}
