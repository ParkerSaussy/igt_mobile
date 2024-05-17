import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../master/general_utils/alertview.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../models/user_data.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  RxBool isEmailValidate = false.obs;
  var isPhone = false.obs;
  RxString countryCode = "+1".obs;

  void forgotPassword(BuildContext context) {
    var body = {
      RequestParams.type:
          isPhone.value == true ? RequestParams.mobile : RequestParams.email,
      RequestParams.email:
          isPhone.value == true ? "" : emailController.text.toString().trim(),
      RequestParams.mobileNumber: isPhone.value == true
          ? countryCode.value + emailController.text.toString().trim()
          : "",
    };
    RequestManager.postRequest(
      uri: EndPoints.forgotPassword,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          var userModel = userDataFromJson(jsonEncode(response));

          if (userModel.isEmailVerify == 0) {
            // Email Not Verified
            if (isPhone.value) {
              // First verify email
              AlertView().showAlertViewWithTwoButton(
                Get.context!,
                '${LabelKeys.emailIsNotVerifiedMsg.tr}${userModel.email.toString()})',
                LabelKeys.no.toUpperCase(),
                LabelKeys.yes.toUpperCase(),
                () {
                  Get.back();
                },
                () {
                  Get.toNamed(Routes.OTP_SCREEN, arguments: [
                    Constants.fromForgot,
                    false,
                    userModel.email.toString().trim(),
                    OTPType.verify
                  ]);
                  clear();
                },
                title: LabelKeys.appName,
              );
            } else {
              // Email entered and need to be verify
              Get.toNamed(Routes.OTP_SCREEN, arguments: [
                Constants.fromForgot,
                isPhone.value,
                emailController.text.toString().trim(),
                OTPType.verify
              ]);
            }
          } else {
            // Email is verified
            if (isPhone.value) {
              if (userModel.isMobileVerify == 0) {
                // Mobile Not verified then verify
                Get.toNamed(Routes.OTP_SCREEN, arguments: [
                  Constants.fromForgot,
                  isPhone.value,
                  countryCode.value + emailController.text.toString().trim(),
                  OTPType.verify
                ]);
              } else {
                // Mobile is verified then forget
                Get.toNamed(Routes.OTP_SCREEN, arguments: [
                  Constants.fromForgot,
                  isPhone.value,
                  countryCode.value + emailController.text.toString().trim(),
                  OTPType.forgot
                ]);
              }
            } else {
              Get.toNamed(Routes.OTP_SCREEN, arguments: [
                Constants.fromForgot,
                isPhone.value,
                emailController.text.toString().trim(),
                OTPType.forgot
              ]);
            }
          }
          clear();
        }
      },
      onFailure: (error) {},
    );
  }

  void clear() {
    emailController.clear();
  }
}
