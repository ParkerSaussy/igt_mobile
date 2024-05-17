import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../master/networking/request_manager.dart';

class ChangePasswordController extends GetxController {
  //TODO: Implement DashboardController

  TextEditingController oldPwController = TextEditingController();
  TextEditingController newPwController = TextEditingController();
  TextEditingController cPwController = TextEditingController();

  FocusNode oldPwNode = FocusNode();
  FocusNode newPwNode = FocusNode();
  FocusNode cPwNode = FocusNode();

  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> changePWFormKey =
      GlobalKey<FormState>(debugLabel: "changePw");

  RxBool isOldPwVisible = false.obs;
  RxBool isNewPwVisible = false.obs;
  RxBool iscPwVisible = false.obs;

  void changePassword(BuildContext context) {
    var body = {
      RequestParams.socialType: RequestParams.email,
      RequestParams.oldPassword: oldPwController.text.toString().trim(),
      RequestParams.cPassword: cPwController.text.toString().trim(),
      RequestParams.password: newPwController.text.toString().trim(),
    };
    RequestManager.postRequest(
      uri: EndPoints.changePassword,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          clear();

          RequestManager.getSnackToast(
              message: message,
              colorText: Get.context!.theme.colorScheme.onSurface,
              backgroundColor: Get.context!.theme.colorScheme.primaryContainer);
          Get.back();
        }
      },
      onFailure: (error) {},
    );
  }

  void clear() {
    activationMode.value = AutovalidateMode.disabled;
    oldPwController.clear();
    newPwController.clear();
    cPwController.clear();
  }
}
