import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/app/modules/trip/poll_detail/city_poll_details/city_poll_details_controller.dart';
import 'package:lesgo/app/modules/trip/poll_detail/date_poll_details/date_poll_details_controller.dart';
import 'package:lesgo/app/services/firestore_services.dart';

class PollDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabBarController;
  TripDetailsModel? tripDetailsModel;
  RxInt tabBarIndex = 0.obs;
  RxInt currentTabIndex = 0.obs;
  RxBool isDateTab = true.obs;

  @override
  void onInit() {
    super.onInit();
    tripDetailsModel = Get.arguments[0];
    FireStoreServices.checkIfTripExists(
        tripId: tripDetailsModel!.id.toString());
    isDateTab.value = Get.arguments[1];
    if (isDateTab.value) {
      tabBarIndex.value = 0;
    } else {
      tabBarIndex.value = 1;
    }

    tabBarController = TabController(vsync: this, length: 2)
      ..addListener(() {
        currentTabIndex.value = tabBarController.index;
        changeTabIndex(currentTabIndex.value);
        update();
      });
    tabBarController.animateTo(tabBarIndex.value);
    changeTabIndex(tabBarIndex.value);
  }

  void changeTabIndex(int index) {
    tabBarIndex.value = index;
    if (index == 0) {
      Get.find<DatePollDetailsController>().onIndexChange(tripDetailsModel!);
    } else if (index == 1) {
      Get.find<CityPollDetailsController>().onIndexChange(tripDetailsModel!);
    }
    update();
  }

  @override
  void onClose() {
    tabBarController.dispose();
    super.onClose();
  }
}
