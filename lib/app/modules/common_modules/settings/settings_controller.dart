import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/user_data.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';

class SettingsController extends GetxController {
  //TODO: Implement SettingsController

  RxBool isMessaging = false.obs;
  RxBool isAllNotifications = false.obs;
  RxBool isChatNotifications = false.obs;
  RxBool isPoll = true.obs;
  @override
  void onInit() {
    super.onInit();
    isAllNotifications.value = gc.loginData.value.getPushNotification == 1;
    isChatNotifications.value = gc.loginData.value.getChatNotification == 1;
  }

  void updateNotificationStatus() {
    RequestManager.postRequest(
      uri: EndPoints.updateNotificationStatus,
      hasBearer: true,
      isLoader: false,
      body: {
        RequestParams.chatNotification: isChatNotifications.value ? 1 : 0,
        RequestParams.pushNotification: isAllNotifications.value ? 1 : 0
      },
      onSuccess: (responseBody, message, status) {
        var userModel = userDataFromJson(jsonEncode(responseBody['userData']));
        Preference.setLoginResponse(userModel);
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  void logoutApi() {
    RequestManager.postRequest(
      uri: EndPoints.logout,
      hasBearer: true,
      isLoader: true,
      body: {},
      onSuccess: (responseBody, message, status) {
        Preference.clearPreference();
        Get.offAllNamed(Routes.LOGIN);
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }
}
