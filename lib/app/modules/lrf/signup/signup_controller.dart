import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/generic_class/social_sign_in.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../../master/session/preference.dart';
import '../../../models/user_data.dart';
import '../../../routes/app_pages.dart';
import '../biomateric_auth.dart';

class SignupController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();

  RxString countryCode = "+1".obs;

  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode conformPasswordNode = FocusNode();
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(debugLabel: "signUp");

  RxBool isPasswordVisible = false.obs;
  RxBool isConformPasswordVisible = false.obs;
  RxBool isCheck = false.obs;
  var isPrivacy = false.obs;
  var isTerms = false.obs;
  String socialId = "";
  String socialType = "";
  String socialEmail = "";
  String fName = "";
  String lName = "";
  String signInType = "";

// EMAIL VALIDATION
  RxString emailValidationMsg = "".obs;
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailValidationMsg.value = LabelKeys.blankEmail.tr;
      return;
    } else {
      if (value.isEmail == false) {
        emailValidationMsg.value = LabelKeys.invalidEmail.tr;
        return;
      }
    }
    emailValidationMsg.value = "";
  }

// PASSWORD VALIDATION
  validatePassword(String value, bool isConformPassword) {
    if (value.trim().isEmpty) {
      return LabelKeys.blankPassword.tr;
    }
    if (value.trim().length < 8) {
      return LabelKeys.inCorrectPassword.tr;
    }
    if (isConformPassword && value != passwordController.text) {
      return LabelKeys.confirmPasswordMsg.tr;
    }
    return;
  }

  @override
  void dispose() {
    // implement dispose
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    conformPasswordController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    //signupFormKey.currentState!.dispose();
    super.onClose();
  }

  void signup() async {
    final deviceId = await getDeviceId();
    var body = {
      RequestParams.firstName: firstNameController.text.toString().trim(),
      RequestParams.lastName: lastNameController.text.toString().trim(),
      RequestParams.email: emailController.text.toString().trim(),
      RequestParams.countryCode:
          phoneController.text == "" ? "" : countryCode.value,
      RequestParams.mobileNumber: phoneController.text == ""
          ? ""
          : phoneController.text.toString().trim(),
      RequestParams.password: passwordController.text.toString().trim(),
      RequestParams.fcmToken: Preference
          .getFirebaseToken(), //here need to get FCM token from firebase Preference.getFirebaseToken()
      RequestParams.deviceId: deviceId,
      RequestParams.platform: getDeviceType(),
    };

    RequestManager.postRequest(
      uri: EndPoints.signUp,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          //var userModel = userDataFromJson(jsonEncode(response['userData']));
          //Preference.setLoginResponse(userModel);
          Get.offAllNamed(Routes.OTP_SCREEN, arguments: [
            Constants.fromSignUp,
            false,
            emailController.text,
            LabelKeys.verify
          ]);
          Preference.setLoginType(RequestParams.email);
          clear();
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
    conformPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
  }

  GoogleSignInClass googleSignInClass = GoogleSignInClass();

  doGoogleLogin() async {
    if (!await isConnectedNetwork()) {
      RequestManager.getSnackToast(
        //title: LabelKeys.noInternet.tr,
        message: LabelKeys.checkInternet.tr,
      );
      return;
    }
    try {
      googleSignInClass.googleSignIn().then((currentUser) {
        if (currentUser == null) return;
        printMessage(
            'Id: ${currentUser.id} UserName: ${currentUser.displayName} \n Email: ${currentUser.email} \n Profile Image: ${currentUser.photoUrl}');
        String displayName = currentUser.displayName ?? "";
        List<String> name = displayName.split(' ');
        fName = name[0];
        lName = name[1];
        socialEmail = currentUser.email;
        socialType = SocialType.google;
        socialId = currentUser.id;
        signInType = SignInType.social;
        doLogin();
      });
    } catch (e) {
      printMessage("error = $e");
    }
  }

  doAppleLogin() async {
    if (!await isConnectedNetwork()) {
      RequestManager.getSnackToast(
        //title: LabelKeys.noInternet.tr,
        message: LabelKeys.checkInternet.tr,
      );
      return;
    }
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      fName = credential.givenName ?? "";
      lName = credential.familyName ?? "";
      socialEmail = credential.email ?? "";
      socialType = SocialType.apple;
      socialId = credential.userIdentifier.toString();
      signInType = SignInType.social;

      if (socialEmail != "") {
        doLogin();
      } else {
        getEmailForAppleLogin(socialId);
      }
    } catch (error) {
      printMessage('Apple Error - $error');
    }
  }

  void getEmailForAppleLogin(String socialId) {
    RequestManager.postRequest(
      uri: EndPoints.getEmailForApple,
      isLoader: true,
      body: {
        RequestParams.socialId: socialId,
        RequestParams.socialType: SocialType.apple
      },
      onSuccess: (responseBody, message, status) {
        socialEmail = responseBody['email'];
        fName = responseBody['first_name'];
        lName = responseBody['last_name'];
        printMessage("socialEmail: $socialEmail");
        doLogin();
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }
  void goToDashboard(){
    Get.offAll(BiomatericAuth());
    //Get.offAllNamed(Routes.DASHBOARD);
  }
  void doLogin() async {
    final deviceId = await getDeviceId();
    var body = {
      RequestParams.signInType: signInType,
      RequestParams.email: signInType == SignInType.social
          ? socialEmail
          : emailController.text.toString().trim(),
      RequestParams.password: signInType == SignInType.social
          ? ""
          : passwordController.text.toString().trim(),
      RequestParams.countryCode:
          signInType == SignInType.mobile ? countryCode.value : "",
      RequestParams.mobileNumber: signInType == SignInType.mobile
          ? emailController.text.toString().trim()
          : "",
      RequestParams.socialId: signInType == SignInType.social
          ? socialId
          : "", //It will get after social login
      RequestParams.socialType: signInType == SignInType.social
          ? socialType
          : "", //It will get after social login
      RequestParams.deviceId: deviceId,
      RequestParams.fcmToken: Preference.getFirebaseToken(),
      RequestParams.firstName: fName,
      RequestParams.lastName: lName,
      RequestParams.platform: getDeviceType(),
    };
    RequestManager.postRequest(
      uri: EndPoints.login,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) async {
        if (status) {
          var userModel = userDataFromJson(jsonEncode(response['userData']));
          bool isUserExists = await FireStoreServices.userExists(
              collectionName: FireStoreCollection.usersCollection,
              documentId: userModel.id.toString(),
              fieldName: FireStoreParams.userId);
          if (!isUserExists) {
            createUserInFirebase(userModel);
          } else {
            RequestManager.isRefreshingToken = false;
            if (userModel.socialType == SocialType.google) {
              Preference.setLoginResponse(userModel);
              Preference.setIsLogin(true);
              //Get.offAllNamed(Routes.DASHBOARD);
              goToDashboard();
            } else /*if (userModel.socialType == RequestParams.apple) */ {
              Preference.setLoginResponse(userModel);
              Preference.setIsLogin(true);
              //Get.offAllNamed(Routes.DASHBOARD);
              goToDashboard();
            }
          }
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

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
        RequestManager.isRefreshingToken = false;
        if (userModel.socialType == SocialType.google) {
          Preference.setLoginResponse(userModel);
          Preference.setIsLogin(true);
          //Get.offAllNamed(Routes.DASHBOARD);
          goToDashboard();
        } else /*if (userModel.socialType == RequestParams.apple) */ {
          Preference.setLoginResponse(userModel);
          Preference.setIsLogin(true);
          //Get.offAllNamed(Routes.DASHBOARD);
          goToDashboard();
        }
      },
      onFailure: (error) {
        Get.offAllNamed(Routes.LOGIN);
        printMessage("error: $error");
      },
    );
  }
}
