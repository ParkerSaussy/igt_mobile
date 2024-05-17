import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/activity_details_model.dart';
import 'package:lesgo/app/models/like_dislike_model.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/app/modules/common_widgets/activity_dining_widget.dart';
import 'package:lesgo/app/modules/common_widgets/activity_event_widget.dart';
import 'package:lesgo/app/modules/common_widgets/activity_flight_widget.dart';
import 'package:lesgo/app/modules/common_widgets/activity_widget.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../master/general_utils/constants.dart';
import '../../../../master/networking/request_manager.dart';

class ActivitiesDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement ActivitiesDetailController

  TabController? tabController;
  TripDetailsModel tripDetailsModel = TripDetailsModel();
  RxInt tripID = 0.obs;
  RxList<ActivityDetailsModel> activitiesList = <ActivityDetailsModel>[].obs;
  RxBool isListAvailable = false.obs;
  RxBool isFilterApplied = false.obs;
  var restorationId = "".obs;
  String selectedTab = "itineary";
  List<String> filters = <String>[];
  String sortBy = '';
  TextEditingController searchTextEditController = TextEditingController();
  RxBool isSearchViewVisible = false.obs;
  String searchText = '';
  final customDebouncer = CustomDebouncer(milliseconds: 1000);
  RxBool isDataLoaded = false.obs;

  // Smart refresher
  RefreshController itineraryController =
      RefreshController(initialRefresh: false);
  RefreshController othersController = RefreshController(initialRefresh: false);
  RefreshController ideasController = RefreshController(initialRefresh: false);
  //Refresh Data
  void onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    getFilters();
    getSortByFilter();
    callActivitiesListApi(true);
  }

  void onLoading() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tripID.value = Get.arguments[0];
    filters.clear();
    getFilters();
    getSortByFilter();
    getTripDetails();
    callActivitiesListApi(false);
  }

  void toggleSearchView() {
    isSearchViewVisible.toggle();
    if (isSearchViewVisible.value == false) {
      searchText = "";
    }
  }

  @override
  void dispose() {
    searchTextEditController.dispose();
    itineraryController.dispose();
    othersController.dispose();
    ideasController.dispose();
    super.dispose();
  }

  void getTripDetails() {
    RequestManager.showEasyLoader();
    RequestManager.postRequest(
      uri: EndPoints.getTripDetail,
      hasBearer: true,
      isLoader: false,
      body: {RequestParams.tripId: tripID.value.toString()},
      isSuccessMessage: false,
      onSuccess: (responseBody, message, status) {
        var tripDetailsData =
            tripDetailsModelFromJson(jsonEncode(responseBody));
        tripDetailsModel = tripDetailsData;
        isDataLoaded.value = true;
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  void callActivitiesListApi(bool isLoader) {
    if (isLoader) {
      RequestManager.showEasyLoader();
    }
    RequestManager.postRequest(
        uri: EndPoints.getActivityDetail,
        hasBearer: true,
        isLoader: false,
        isSuccessMessage: false,
        body: {
          RequestParams.tripId: tripID.value,
          RequestParams.filterEventType: filters,
          RequestParams.sortBy: sortBy,
          RequestParams.searchText: searchText,
          RequestParams.type: selectedTab
        },
        onSuccess: (responseBody, message, status) {
          filters.clear();
          activitiesList.value = List<ActivityDetailsModel>.from(
              responseBody["activityData"]
                  .map((x) => ActivityDetailsModel.fromJson(x)));
          printMessage("Activities Count ${activitiesList.value.length}");
          if (activitiesList.isNotEmpty) {
            isListAvailable.value = true;
          } else {
            isListAvailable.value = false;
          }
          refreshMethod();
          update();
          EasyLoading.dismiss();
        },
        onFailure: (error) {
          refreshMethod();
          printMessage("error: $error");
          EasyLoading.dismiss();
        });
  }

  void deleteActivity(String id, int index) {
    RequestManager.postRequest(
        uri: EndPoints.deleteActivity,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {RequestParams.activityId: id},
        onSuccess: (responseBody, message, status) {
          if (status) {
            //Add Toast
            RequestManager.getSnackToast(
                message: LabelKeys.activityDeleteMsg.tr,
                colorText: Get.context!.theme.colorScheme.onSurface,
                backgroundColor:
                    Get.context!.theme.colorScheme.primaryContainer);
            restorationId.value = getRandomString();
            activitiesList.removeAt(index);
          }
        },
        onFailure: (error) {
          printMessage("error: $error");
        });
  }

  void likeDislikeIdeas(String id, String likeDislike, int index) {
    RequestManager.postRequest(
        uri: EndPoints.likeDislikeIdeas,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {
          RequestParams.activityId: id,
          RequestParams.likeOrDislike: likeDislike
        },
        onSuccess: (responseBody, message, status) {
          if (status) {
            //Add Toast
            RequestManager.getSnackToast(
                message: message,
                colorText: Get.context!.theme.colorScheme.onSurface,
                backgroundColor:
                    Get.context!.theme.colorScheme.primaryContainer);
            LikeDislikeModel likeDislikeModel =
                likeDislikeModelFromJson(jsonEncode(responseBody));
            activitiesList[index].likeCount = likeDislikeModel.like!;
            activitiesList[index].dislikeCount = likeDislikeModel.disLike!;
            restorationId.value = getRandomString();
          }
        },
        onFailure: (error) {
          printMessage("error: $error");
        });
  }

  void makeItineary(String id, String isItinerary, int index) {
    RequestManager.postRequest(
        uri: EndPoints.makeItineary,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {
          RequestParams.activityId: id,
          RequestParams.isItineary: isItinerary,
          RequestParams.tripId: tripID.value
        },
        onSuccess: (responseBody, message, status) {
          if (status) {
            //Add Toast
            RequestManager.getSnackToast(
                message: LabelKeys.activityMovedTripItineraryMsg.tr,
                colorText: Get.context!.theme.colorScheme.onSurface,
                backgroundColor:
                    Get.context!.theme.colorScheme.primaryContainer);
            restorationId.value = getRandomString();
            activitiesList.removeAt(index);
          }
        },
        onFailure: (error) {
          printMessage("error: $error");
        });
  }

  List<String> getFilters() {
    if (gc.isOne.value) {
      filters.add("dining");
    }
    if (gc.isTwo.value) {
      filters.add("flight");
    }
    if (gc.isThree.value) {
      filters.add("event");
    }
    if (gc.isFour.value) {
      filters.add("hotel");
    }
    if (filters.isNotEmpty) {
      isFilterApplied.value = true;
    }
    return filters;
  }

  String getSortByFilter() {
    if (gc.sortBy.value == "0") {
      sortBy = ShortBy.upcoming;
    } else {
      sortBy = ShortBy.hidePast;
    }
    return sortBy;
  }

  void refreshMethod() {
    othersController.loadComplete();
    othersController.refreshCompleted();
    itineraryController.loadComplete();
    itineraryController.refreshCompleted();
    ideasController.loadComplete();
    ideasController.refreshCompleted();
    restorationId.value = getRandomString();
  }

  void openOthersBottomSheet(
      {required ActivityDetailsModel activityDetailsModel}) {
    if (activitiesList.isNotEmpty) {
      Get.bottomSheet(
        isScrollControlled:
            activityDetailsModel.activityType == "flight" ? false : true,
        ignoreSafeArea: true,
        activityBottomSheet(
          activityDetailsModel: activityDetailsModel,
        ),
      );
    } else {
      RequestManager.getSnackToast(message: LabelKeys.noActivityFound.tr);
    }
  }

  Widget activityBottomSheet(
      {required ActivityDetailsModel activityDetailsModel}) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: StatefulBuilder(
        builder: (context, setState) {
          if (activityDetailsModel.activityType == "hotel") {
            return ActivityWidget(
              activityDetailsModel: activityDetailsModel,
            );
          } else if (activityDetailsModel.activityType == "flight") {
            return ActivityFlightWidget(
              activityDetailsModel: activityDetailsModel,
            );
          } else if (activityDetailsModel.activityType == "dining") {
            return ActivityDiningWidget(
              activityDetailsModel: activityDetailsModel,
            );
          } else if (activityDetailsModel.activityType == "event") {
            return ActivityEventWidget(
              activityDetailsModel: activityDetailsModel,
            );
          }
          return Container();
        },
      ),
    );
  }
}

class CustomDebouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  CustomDebouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
