import 'package:get/get.dart';

import '../models/user_data.dart';

class GeneralController extends GetxController {
  var selectedIndex = 0.obs;
  var bottomRefresher = ''.obs;
  Rx<UserData> loginData = UserData().obs;
  RxString chatTripId = "".obs;

  //TODO filters used in Activity Details Screen
  var isOne = false.obs;
  var isTwo = false.obs;
  var isThree = false.obs;
  var isFour = false.obs;
  var sortBy = "0".obs;

  setLoginData(UserData loginResponse) {
    loginData.value = loginResponse;
  }

  resetActivityFilters() {
    isOne.value = false;
    isTwo.value = false;
    isThree.value = false;
    isFour.value = false;
    sortBy.value = "0";
  }
}
