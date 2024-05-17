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
  void onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    gc.loginData.value.notificationCount = 0;
    getNotification();
  }

  void onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
  }

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

  getNotification() {
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

  deleteNotification(int notificationId, int index) {
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
