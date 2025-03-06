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
  /// Called when the widget is initialized.
  ///
  /// Checks the user's current notification settings from local storage and sets
  /// the corresponding RxBool variables to those values.
  void onInit() {
    super.onInit();
    isAllNotifications.value = gc.loginData.value.getPushNotification == 1;
    isChatNotifications.value = gc.loginData.value.getChatNotification == 1;
  }

/// Updates the notification status on the server.
///
/// Sends a POST request to the [EndPoints.updateNotificationStatus] endpoint
/// with the current chat and push notification settings. If the request is
/// successful, the user's updated data is stored locally. If the request fails,
/// any loading indicators are dismissed.
///
/// The request includes the following parameters:
/// - [RequestParams.chatNotification]: Indicates if chat notifications are enabled (1) or disabled (0).
/// - [RequestParams.pushNotification]: Indicates if push notifications are enabled (1) or disabled (0).
///
/// On success:
/// - Updates the local user data with the response from the server.
///
/// On failure:
/// - Dismisses any active loading indicators.

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

  /// Logs the user out of the app.
  ///
  /// Sends a POST request to the [EndPoints.logout] endpoint to log the user out.
  /// If the request is successful, all local data is cleared and the user is
  /// navigated to the login screen. If the request fails, any active loading
  /// indicators are dismissed.
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
