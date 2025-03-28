import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../models/trip_details_model.dart';
import 'expanse_activities/expanse_activities_controller.dart';
import 'expanse_resolutions/expanse_resolutions_controller.dart';

class ExpanseResolutionTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxString payment = "0".obs;
  final TextEditingController unequalController = TextEditingController();
  TripDetailsModel? tripDetailsModel;
  int? tripId;
  RxInt tabBarIndex = 0.obs;
  RxBool isDataLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    //tabController = TabController(length: 2, vsync: this);
    tripId = Get.arguments[0];
    getTripDetails();
    tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        tabBarIndex.value = tabController.index;
        //if (!tabController.indexIsChanging) {
        if (isDataLoaded.value) {
          changeTabIndex(tabBarIndex.value);
        }
        update();
        // }
      });
  }

  void changeTabIndex(int index) {
    tabBarIndex.value = index;
    if (index == 0) {
      Get.find<ExpanseActivitiesController>().onIndexChange(tripDetailsModel!);
    } else if (index == 1) {
      Get.find<ExpanseResolutionsController>().onIndexChange(tripDetailsModel!);
    }
    update();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Gets trip details from API.
  ///
  /// This method is used to get trip details from API.
  /// It takes trip id as parameter and returns trip details.
  /// If request is successfull, it sets [isDataLoaded] to true and
  /// assigns response to [tripDetailsModel].
  /// If request is failed, it shows easy loading and sets [isDataLoaded] to false.
  /// It also calls [changeTabIndex] with current [tabBarIndex] value.
  void getTripDetails() {
    RequestManager.postRequest(
      uri: EndPoints.getTripDetail,
      hasBearer: true,
      isLoader: true,
      body: {RequestParams.tripId: tripId.toString()},
      isSuccessMessage: false,
      onSuccess: (responseBody, message, status) {
        var tripDetailsData =
            tripDetailsModelFromJson(jsonEncode(responseBody));
        tripDetailsModel = tripDetailsData;
        isDataLoaded.value = true;

        changeTabIndex(tabBarIndex.value);
      },
      onFailure: (error) {},
    );
  }

  /// Shares the expense report for the current trip.
  ///
  /// This method sends a POST request to the [EndPoints.expReport] endpoint.
  /// It includes the current trip ID in the request body. If the request
  /// is successful, a success message is displayed. If the request fails,
  /// a failure message is displayed.

  void shareExpanseReport() {
    RequestManager.postRequest(
      uri: EndPoints.expReport,
      hasBearer: true,
      isLoader: true,
      body: {RequestParams.trip_id: tripId.toString()},
      isSuccessMessage: true,
      isFailedMessage: true,
      onSuccess: (responseBody, message, status) {},
      onFailure: (error) {},
    );
  }
}
