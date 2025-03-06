import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/session/preference.dart';

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../models/user_data.dart';

class MyProfileController extends GetxController {
  //Rx<UserData> userData = UserData().obs;
  RxInt fromScreen = Constants.fromDashboard.obs;
  RxString myProfileId = "".obs;
  @override
  void onInit() {
    super.onInit();
    callApiGetProfile();
    fromScreen.value = Get.arguments;
    printMessage("My Profile signIn type: ${gc.loginData.value.signinType}");
  }

  final pinPutController = TextEditingController();
  final pinFocusNode = FocusNode();
  final pinFormKey = GlobalKey<FormState>();

  var isResendVisible = false.obs;
  var timeStart = "00:25".obs;
  Timer? timer;
  int? timeCounter;
  var reciever;

  /// Starts a timer that counts down from 25 seconds. After each second the
  /// `timeStart` observable is updated with the remaining time in the format
  /// "mm:ss". When the timer reaches 0, the `isResendVisible` observable is set
  /// to true and the timer is cancelled.
  void startTimer() {
    timeCounter = Constants.timeCounter;
    timeStart.value = "00:25";
    isResendVisible.value = false;
    if (timer != null) {
      timer?.cancel();
    }
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timeCounter! < 1) {
          timer.cancel();
          isResendVisible.value = true;
        } else {
          formatHHMMSS();
          timeCounter = timeCounter! - 1;
        }
      },
    );
  }

  /// Formats the `timeCounter` in seconds into a string in the format "mm:ss" and assigns it to `timeStart`.
  /// If `timeCounter` is 0 or less, sets `timeStart` to an empty string and sets `timeCounter` to 0.
  void formatHHMMSS() {
    if (timeCounter! > 0) {
      printMessage("timeCounter   $timeCounter");
      int minutes = (timeCounter! / 60).truncate();
      int second = timeCounter! - (minutes * 60);
      String minutesStr = (minutes).toString().padLeft(2, '0');
      String secondsStr = (second).toString().padLeft(2, '0');
      timeStart.value = "$minutesStr:$secondsStr";
    } else {
      timeStart.value = "";
      timeCounter = 0;
    }
  }

  /// Sends an OTP to the user's registered mobile number.
  ///
  /// This function creates a body with the receiver type as mobile, the receiver
  /// as the concatenation of the country code and the mobile number, and the
  /// OTP type as verify. It then sends a POST request to the
  /// [EndPoints.sendOtp] endpoint. If the server responds with a success status,
  /// it starts a timer for 60 seconds. If the server responds with a failure
  /// status, it displays an error message.
  void sendOtp() {
    var body = {
      RequestParams.reciverType: RequestParams.mobile,
      RequestParams.reciver: reciever,
      RequestParams.otpType: RequestParams.verify,
    };
    RequestManager.postRequest(
      uri: EndPoints.sendOtp,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: true,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          startTimer();
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  /// Verifies an OTP sent to the user's registered mobile number.
  ///
  /// This function constructs a request body with the receiver type as mobile,
  /// the receiver as the user's mobile number, the OTP type as verify, and the
  /// OTP entered by the user. The function sends a POST request to the
  /// [EndPoints.verifyOtp] endpoint to verify the OTP.
  ///
  /// If the OTP is verified successfully, it clears the OTP input field,
  /// updates the user's login response in the preferences, and pops the current
  /// screen to navigate back. If the OTP verification fails, it displays an
  /// error message.

  void verifyOtpAPI() {
    var body = {
      RequestParams.reciverType: RequestParams.mobile,
      RequestParams.reciver: reciever,
      RequestParams.otpType: RequestParams.verify,
      RequestParams.otp: pinPutController.text.trim().toString()
    };
    RequestManager.postRequest(
      uri: EndPoints.verifyOtp,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status == true) {
          var userModel = userDataFromJson(jsonEncode(response));
          pinPutController.clear();
          Preference.setLoginResponse(userModel);
          gc.loginData.value = Preference.getLoginResponse();
          Get.back();
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  /// Fetches the user's profile information from the server.
  ///
  /// This method calls the [EndPoints.getProfile] API endpoint to fetch the
  /// user's profile information. If the response is successful, it sets the
  /// user's login response in the preferences and updates the [myProfileId].
  /// If the response fails, it displays an error message.
  void callApiGetProfile() {
    RequestManager.postRequest(
        uri: EndPoints.getProfile,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {},
        onSuccess: (responseBody, message, status) {
          var userModel = userDataFromJson(jsonEncode(responseBody));
          Preference.setLoginResponse(userModel);
          myProfileId.value = getRandomString();
          EasyLoading.dismiss();
        },
        onFailure: (error) {
          EasyLoading.dismiss();
          printMessage("error: $error");
        });
  }
}
