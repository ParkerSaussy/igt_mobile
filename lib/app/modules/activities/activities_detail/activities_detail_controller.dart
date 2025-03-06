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

  /// Gets trip details from API
  ///
  /// This method is used to get trip details from API.
  /// It takes trip id as parameter and returns trip details.
  /// If request is successfull, it sets [isDataLoaded] to true and
  /// assigns response to [tripDetailsModel].
  /// If request is failed, it shows easy loading and sets [isDataLoaded] to false.
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

  /// Gets list of activities from API
  ///
  /// This method is used to get list of activities from API.
  /// It takes two parameters, [isLoader] and [filters].
  /// [isLoader] is used to show or hide loader.
  /// [filters] is used to filter activities by event type.
  /// It posts request to [EndPoints.getActivityDetail] with [RequestParams.tripId],
  /// [RequestParams.filterEventType], [RequestParams.sortBy], [RequestParams.searchText] and [RequestParams.type].
  /// If request is successfull, it assigns response to [activitiesList] and sets [isListAvailable] to true.
  /// If request is failed, it shows easy loading and sets [isListAvailable] to false.
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

  /// Deletes activity from API
  ///
  /// This method is used to delete activity from API.
  /// It takes two parameters, [id] and [index].
  /// [id] is used to identify which activity to delete.
  /// [index] is used to remove activity from list.
  /// It posts request to [EndPoints.deleteActivity] with [RequestParams.activityId].
  /// If request is successfull, it removes activity from list and shows toast.
  /// If request is failed, it shows error message.
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

  /// Likes or dislikes activity idea
  ///
  /// This method is used to like or dislike activity idea.
  /// It takes three parameters, [id], [likeDislike] and [index].
  /// [id] is used to identify which activity idea to like or dislike.
  /// [likeDislike] is used to specify whether to like or dislike.
  /// [index] is used to update like or dislike count in list.
  /// It posts request to [EndPoints.likeDislikeIdeas] with [RequestParams.activityId] and [RequestParams.likeOrDislike].
  /// If request is successfull, it shows toast and updates like or dislike count in list.
  /// If request is failed, it shows error message.
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

  /// Makes activity as trip itinerary
  ///
  /// This method is used to make activity as trip itinerary.
  /// It takes three parameters, [id], [isItinerary] and [index].
  /// [id] is used to identify which activity to make as trip itinerary.
  /// [isItinerary] is used to specify whether to make it as trip itinerary or not.
  /// [index] is used to remove activity from list after making it as trip itinerary.
  /// It posts request to [EndPoints.makeItineary] with [RequestParams.activityId], [RequestParams.isItineary] and [RequestParams.tripId].
  /// If request is successfull, it shows toast and removes activity from list.
  /// If request is failed, it shows error message.
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

  /// Gets the list of filters to be applied on activity list
  ///
  /// This method is used to get the list of filters to be applied on activity list.
  /// It adds the respective filter type to the list if the filter is selected.
  /// If any filter is selected, it sets [isFilterApplied] to true.
  /// It returns the list of filters.
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

  /// Gets the selected sort by filter.
  ///
  /// This method is used to get the selected sort by filter.
  /// It returns the selected sort by filter.
  /// If the selected sort by filter is "upcoming", it returns [ShortBy.upcoming].
  /// If the selected sort by filter is "hidePast", it returns [ShortBy.hidePast].
  String getSortByFilter() {
    if (gc.sortBy.value == "0") {
      sortBy = ShortBy.upcoming;
    } else {
      sortBy = ShortBy.hidePast;
    }
    return sortBy;
  }

  /// Refreshes all the controllers.
  ///
  /// This method is used to refresh all the controllers
  /// used in the activity details screen.
  /// It calls the [loadComplete] and [refreshCompleted] methods
  /// of all the controllers.
  /// It also regenerates the [restorationId].
  ///
  /// This method is used when the user wants to refresh the
  /// activity details screen.
  void refreshMethod() {
    othersController.loadComplete();
    othersController.refreshCompleted();
    itineraryController.loadComplete();
    itineraryController.refreshCompleted();
    ideasController.loadComplete();
    ideasController.refreshCompleted();
    restorationId.value = getRandomString();
  }

  /// Opens a bottom sheet for the specified activity.
  ///
  /// This method displays a bottom sheet that provides additional details about
  /// the given [activityDetailsModel]. It checks if there are activities in the
  /// [activitiesList] and, if so, opens a bottom sheet. The bottom sheet's scroll
  /// control is determined by whether the activity type is "flight". If the
  /// [activitiesList] is empty, it shows a toast message indicating no activities
  /// were found.
  ///
  /// The [activityDetailsModel] parameter is required and contains information
  /// about the activity to be displayed in the bottom sheet.

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

  /// Returns a bottom sheet widget with the activity details.
  ///
  /// This method returns a bottom sheet widget with the activity details.
  /// It takes an [activityDetailsModel] as a required parameter which contains
  /// information about the activity to be displayed in the bottom sheet.
  /// The bottom sheet's scroll control is determined by whether the activity type
  /// is "flight". If the activity type is "flight", the bottom sheet is not
  /// scrollable. Otherwise, the bottom sheet is scrollable.
  /// It returns a different widget based on the activity type.
  /// If the activity type is "hotel", it returns an [ActivityWidget].
  /// If the activity type is "flight", it returns an [ActivityFlightWidget].
  /// If the activity type is "dining", it returns an [ActivityDiningWidget].
  /// If the activity type is "event", it returns an [ActivityEventWidget].
  /// If the activity type is anything else, it returns an empty [Container].
  ///
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
