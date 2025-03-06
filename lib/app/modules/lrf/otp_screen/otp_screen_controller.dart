import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../../master/session/preference.dart';
import '../../../models/user_data.dart';
import '../../../routes/app_pages.dart';
import '../biomateric_auth.dart';

class OtpScreenController extends GetxController {
  final pinPutController = TextEditingController();
  final pinFocusNode = FocusNode();
  final pinFormKey = GlobalKey<FormState>();

  RxBool isResendVisible = false.obs;
  RxString timeStart = "00:25".obs;
  Timer? timer;
  int? timeCounter;
  int fromScreen = Constants.fromSignUp;
  RxString otpType = LabelKeys.verify.obs;
  RxBool isPhone = false.obs;
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

  // arguments
  // 0- from which screen
  // 1- is Phone number entered
  // 2- value of email/phone number(with country code)
  // 3- otp type (forgot,verify)
  @override
  void onInit() {
    super.onInit();
    //startTimer();
    fromScreen = Get.arguments[0];
    isPhone.value = Get.arguments[1];
    reciever = Get.arguments[2];
    otpType.value = Get.arguments[3];
    startTimer();
    sendOtp();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer?.cancel();
    }
    super.onClose();
  }
  void goToDashboard(){
    Get.offAll(BiomatericAuth());
    //Get.offAllNamed(Routes.DASHBOARD);
  }
  /// Navigate to the next screen based on the fromScreen value.
  ///
  /// If fromScreen is [Constants.fromForgot], navigate to the reset password screen.
  /// If fromScreen is [Constants.fromSignUp], navigate to the dashboard screen.
  /// Otherwise, also navigate to the dashboard screen.
  void verifyOTP() {
    printMessage("fromScreen = $fromScreen");
    if (fromScreen == Constants.fromForgot) {
      Get.offAllNamed(Routes.RESET_PASSWORD);
    } else if (fromScreen == Constants.fromSignUp) {
      Preference.setIsLogin(true);
      //Get.offAllNamed(Routes.DASHBOARD);
      goToDashboard();
    } else {
      Preference.setIsLogin(true);
      //Get.offAllNamed(Routes.DASHBOARD);
      goToDashboard();
    }
  }

  /// Sends an OTP to the user's email address or phone number.
  ///
  /// The request body contains the type of the request (email or mobile),
  /// the email address or phone number (with country code), and the OTP type
  /// (verify or forgot).
  ///
  /// If the request is successful, the function clears the OTP text field.
  /// If the request fails, the function shows an error message.
  void sendOtp() {
    var body = {
      RequestParams.reciverType: isPhone.value ? "mobile" : "email",
      RequestParams.reciver: reciever,
      RequestParams.otpType: otpType.value
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
          // clear();
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  /// Verifies an OTP sent to the user's email address or phone number.
  ///
  /// The request body contains the type of the request (email or mobile),
  /// the email address or phone number (with country code), the OTP type
  /// (verify or forgot), and the OTP sent by the user.
  ///
  /// If the request is successful, the function logs in the user and navigates
  /// to the dashboard. If the user does not exist in Firestore, the function
  /// creates a new user in Firestore. If the request fails, the function shows
  /// an error message.
  void verifyOtpAPI() {
    var body = {
      RequestParams.reciverType: isPhone.value ? "mobile" : "email",
      RequestParams.reciver: reciever,
      RequestParams.otpType: otpType.value,
      RequestParams.otp: pinPutController.text.trim().toString()
    };
    RequestManager.postRequest(
      uri: EndPoints.verifyOtp,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) async {
        if (status == true) {
          var userModel = userDataFromJson(jsonEncode(response));
          bool isUserExists = await FireStoreServices.userExists(
              collectionName: FireStoreCollection.usersCollection,
              documentId: userModel.id.toString(),
              fieldName: FireStoreParams.userId);
          if (!isUserExists) {
            createUserInFirebase(userModel);
          } else {
            clear();
            Preference.setLoginResponse(userModel);
            verifyOTP();
          }
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  void clear() {
    pinPutController.clear();
  }

  /// Creates a new user in Firestore.
  ///
  /// The function takes a [UserData] object and creates a new user in Firestore
  /// with the provided data. If the request is successful, the function logs in
  /// the user and navigates to the dashboard. If the request fails, the function
  /// shows an error message and navigates to the login screen.
  void createUserInFirebase(UserData userModel) {
    FireStoreServices.addDataWithDocumentId(
      isLoader: true,
      body: {
        FireStoreParams.firstName: userModel.firstName,
        FireStoreParams.lastName: userModel.lastName,
        FireStoreParams.profileImage: userModel.profileImage,
        FireStoreParams.mobileNumber:
            "${userModel.countryCode}${userModel.mobileNumber}",
        FireStoreParams.userId: userModel.id.toString(),
        FireStoreParams.email: userModel.email,
        FireStoreParams.fcmToken: userModel.fcmToken
      },
      documentId: userModel.id.toString(),
      collectionName: FireStoreCollection.usersCollection,
      onSuccess: (responseBody) {
        clear();
        Preference.setLoginResponse(userModel);
        verifyOTP();
      },
      onFailure: (error) {
        Get.offAllNamed(Routes.LOGIN);
        printMessage("error: $error");
      },
    );
  }
}
