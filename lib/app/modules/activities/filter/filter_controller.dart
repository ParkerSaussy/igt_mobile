import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/constants.dart';

import '../../../../master/networking/request_manager.dart';

class FilterController extends GetxController {
  //TODO: Implement FilterController

  List<String> filter = <String>[].obs;
  RxString sortByFilter = ShortBy.upcoming.obs;

  /// Resets all the filter options to their default values.
  /// 
  /// The default values are:
  /// - All categories deselected.
  /// - The sorting order set to "Upcoming".
  void resetAll() {
    gc.isOne.value = false;
    gc.isTwo.value = false;
    gc.isThree.value = false;
    gc.isFour.value = false;
    gc.sortBy.value = "0";
  }

  /// Updates the filter list based on the selected categories and sets the sorting order.
  /// 
  /// Adds the corresponding filter strings ("dining", "flight", "event", "hotel") 
  /// to the `filter` list if the related flags (`isOne`, `isTwo`, `isThree`, `isFour`) 
  /// are set to true in the global controller (`gc`). Also, updates the `sortByFilter` 
  /// based on the `gc.sortBy` value, setting it to `ShortBy.upcoming` if the value is "0", 
  /// otherwise setting it to `ShortBy.hidePast`.

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
