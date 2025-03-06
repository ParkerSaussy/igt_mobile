import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/models/notification_list.dart';
import 'package:lesgo/app/models/user_data.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationsController extends GetxController {
  //TODO: Implement NotificationsController

  RxString rNotId = ''.obs;
  var isSelected = false.obs;
  RxList<NotificationList> notificationList =
      List<NotificationList>.empty(growable: true).obs;
  RxList<NotificationList> secList =
      List<NotificationList>.empty(growable: true).obs;
  Map<String?, List<NotificationList>>? newList;
  // Smart refresher
  RefreshController notificationController =
      RefreshController(initialRefresh: false);
  RxInt isRead = 0.obs;
  RxBool notificationFetch = false.obs;
  RxBool isDataLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    /*for(int i=0;i<2;i++){
      notificationList.value.add(NotificationList(isSelected: false,time: "2023/07/06 12:25:33 PM",title: "Message From Ayuz",desc: "Hi! dilvese, are you looking for a hotel in New York  and check our next plan and details...",img: ImagesPath.user7));
    }
    for(int i=0;i<4;i++){
      notificationList.value.add(NotificationList(isSelected: false,time: "2023/06/16 12:25:33 PM",title: "Message From Ayuz",desc: "Hi! dilvese, are you looking for a hotel in New York  and check our next plan and details...",img: IconPath.icNotification));
    }
    for(int i=0;i<4;i++){
      notificationList.value.add(NotificationList(isSelected: false,time: "2023/06/14 12:25:33 PM",title: "Message From Ayuz",desc: "Hi! dilvese, are you looking for a hotel in New York  and check our next plan and details...",img: IconPath.icLocation));
    }
    secList.addAll(notificationList.value);*/
    getNotification();
  }

  //Refresh Data
  /// Refreshes the notification data.
  ///
  /// This method resets the notification count to zero and retrieves the
  /// latest notifications. It includes a delay of 1 second to simulate a
  /// refresh operation.

  void onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    gc.loginData.value.notificationCount = 0;
    getNotification();
  }

  /// Simulates a loading operation by pausing for 1 second.
  ///
  /// This method is called when the user pulls down to refresh the
  /// notification data. It's intended to be overridden by subclasses
  /// that support loading more data.
  void onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
  }


  /// Converts a given date string into a relative time string.
  ///
  /// If the given date is today, it returns a string in the format "hh:mm a".
  /// If the given date is yesterday, it returns the string "Yesterday".
  /// Otherwise, it returns a string in the format "dd MMM yyyy".
  ///
  /// Example:
  /// 
  String daysBetween(String crDate) {
    DateTime fromUtc =
        DateFormat("yyyy/MM/dd hh:mm:ss aa").parse(crDate, true).toLocal();
    DateTime to = DateTime.now().toLocal();
    var diff = (to.difference(fromUtc).inDays);
    var timeAgo = DateFormat('hh:mm a').format(fromUtc);
    if (diff == 1) {
      timeAgo = LabelKeys.yesterday.tr;
    } else if (diff == 0) {
      timeAgo = LabelKeys.today.tr;
    } else {
      timeAgo = DateFormat('dd MMM yyyy').format(fromUtc);
    }

    return timeAgo;
  }

  /// Fetches the list of notifications from the server.
  ///
  /// This function uses the [RequestManager] to make a POST request to the
  /// [EndPoints.notificationGet] endpoint. The request body is empty.
  /// The [isLoader] parameter is set to true, so a loader is displayed
  /// while the request is in progress.
  ///
  /// The [onSuccess] callback is called when the request is successful.
  /// It takes the response body, message, and status as parameters.
  /// The response body is a list of notifications, which is converted
  /// to a list of [NotificationList] objects and stored in the
  /// [notificationList] property of the controller.
  /// The [secList] property is also updated with the same list.
  /// The [newList] property is updated with the grouped list of
  /// notifications.
  /// The [notificationFetch] property is set to true.
  /// The [isDataLoading] property is set to false.
  /// The [notificationController] is updated with the new list of
  /// notifications.
  ///
  /// The [onFailure] callback is called when the request fails.
  /// It takes the error as a parameter.
  /// The [secList], [notificationList], and [newList] properties are
  /// cleared.
  /// The [notificationFetch] property is set to false.
  /// The [isDataLoading] property is set to false.
  /// The [isSelected] property is set to false.
  void getNotification() {
    RequestManager.postRequest(
        uri: EndPoints.notificationGet,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {},
        onSuccess: (responseBody, message, status) {
          notificationList.value = List<NotificationList>.from(
              responseBody.map((x) => NotificationList.fromJson(x)));
          secList.addAll(notificationList.value);
          for (int i = 0; i < notificationList.length; i++) {
            var createdDate = notificationList[i].createdAt;
            String formateDate = Date.shared().stringFromDate(createdDate!);
            notificationList[i].groupDate = formateDate;
          }
          final groupList = groupBy(notificationList, (p0) => p0.groupDate);
          newList = groupList;
          notificationFetch.value = true;
          isDataLoading.value = false;
          notificationController.loadComplete();
          notificationController.refreshCompleted();
          rNotId.value = getRandomString();
        },
        onFailure: (error) {
          secList.clear();
          notificationList.clear();
          newList?.clear();
          rNotId.value = getRandomString();
          isSelected.value = false;
          notificationFetch.value = false;
          isDataLoading.value = false;
        });
  }

  /// Deletes a notification by its ID.
  ///
  /// This function sends a request to delete a specific notification identified
  /// by the [notificationId]. Upon successful deletion, it updates the user
  /// model and refreshes the notification list. If the deletion fails, it
  /// attempts to refresh the notification list to reflect the current state.
  ///
  /// Params:
  /// - [notificationId]: The ID of the notification to be deleted.
  /// - [index]: The index of the notification in the list (unused in the function).

  void deleteNotification(int notificationId, int index) {
    RequestManager.postRequest(
        uri: EndPoints.notificationDelete,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {RequestParams.notificationId: notificationId},
        onSuccess: (responseBody, message, status) {
          var userModel = userDataFromJson(jsonEncode(responseBody));
          Preference.setLoginResponse(userModel);
          getNotification();
        },
        onFailure: (error) {
          getNotification();
        });
  }

  /// This function will clear all notifications from the server and then fetch the updated notifications.
  ///
  /// It will call the [getNotification] function after the success of the clear all notification api.
  ///
  void clearAllNotification() {
    RequestManager.postRequest(
        uri: EndPoints.notificationDelete,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {RequestParams.notificationId: ""},
        onSuccess: (responseBody, message, status) {
          var userModel = userDataFromJson(jsonEncode(responseBody));
          Preference.setLoginResponse(userModel);
          notificationFetch.value = false;
          getNotification();
        },
        onFailure: (error) {
          rNotId.value = getRandomString();
        });
  }
}
