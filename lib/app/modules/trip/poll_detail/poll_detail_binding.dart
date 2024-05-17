import 'package:get/get.dart';
import 'package:lesgo/app/modules/trip/poll_detail/city_poll_details/city_poll_details_controller.dart';
import 'package:lesgo/app/modules/trip/poll_detail/date_poll_details/date_poll_details_controller.dart';

import 'poll_detail_controller.dart';

class PollDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PollDetailController>(() => PollDetailController(),
        fenix: true);
    Get.lazyPut<CityPollDetailsController>(
      () => CityPollDetailsController(),
    );
    Get.lazyPut<DatePollDetailsController>(
      () => DatePollDetailsController(),
    );
  }
}
