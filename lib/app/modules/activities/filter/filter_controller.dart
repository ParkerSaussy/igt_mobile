import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/constants.dart';

import '../../../../master/networking/request_manager.dart';

class FilterController extends GetxController {
  //TODO: Implement FilterController

  List<String> filter = <String>[].obs;
  RxString sortByFilter = ShortBy.upcoming.obs;

  void resetAll() {
    gc.isOne.value = false;
    gc.isTwo.value = false;
    gc.isThree.value = false;
    gc.isFour.value = false;
    gc.sortBy.value = "0";
  }

  void apply() {
    if (gc.isOne.value) {
      filter.add("dining");
    }
    if (gc.isTwo.value) {
      filter.add("flight");
    }
    if (gc.isThree.value) {
      filter.add("event");
    }
    if (gc.isFour.value) {
      filter.add("hotel");
    }

    if (gc.sortBy.value == "0") {
      sortByFilter.value = ShortBy.upcoming;
    } else {
      sortByFilter.value = ShortBy.hidePast;
    }
  }
}
