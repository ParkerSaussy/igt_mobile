import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/user_data.dart';
import 'package:lesgo/master/session/preference.dart';

import '../../../../master/networking/request_manager.dart';
import '../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final resetPassFormKey = GlobalKey<FormState>();
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;

  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();

  FocusNode passwordNode = FocusNode();
  FocusNode conformPasswordNode = FocusNode();

  RxBool isPasswordVisible = false.obs;
  RxBool isConformPasswordVisible = false.obs;

/// Resets the user's password.
///
/// This function sends a request to the server to reset the user's password. 
/// It retrieves the user ID from the stored login response and the new 
/// password from the conform password controller. If the request is successful, 
/// it clears the password fields and navigates the user to the login screen. 
/// If the request fails, an error handler is executed.
///
/// Parameters:
/// - `context` (BuildContext): The build context of the current widget.

  void resetPassword(BuildContext context) {
    UserData userData = Preference.getLoginResponse();
    var body = {
      RequestParams.userId: userData.id.toString(),
      RequestParams.password: conformPasswordController.text.toString().trim(),
    };
    RequestManager.postRequest(
      uri: EndPoints.resetPassword,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: true,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          clear();
          Get.offAllNamed(Routes.LOGIN);
        }
      },
      onFailure: (error) {},
    );
  }

  void clear() {
    passwordController.clear();
    conformPasswordController.clear();
  }
}
