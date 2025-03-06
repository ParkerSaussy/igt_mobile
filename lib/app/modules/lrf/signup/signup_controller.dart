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
  /// Validate the email address.
  ///
  /// This function takes in the email address from the UI and checks if it is
  /// valid. If the email address is empty, the function sets the error message to
  /// "Please enter email address". If the email address is not empty, the function
  /// checks if the email address is valid. If the email address is invalid, the
  /// function sets the error message to "Please enter valid email address". If
  /// the email address is valid, the function sets the error message to an empty
  /// string.
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

  /// Send a signup request to the server.
  ///
  /// This function takes in the user details from the UI and sends a signup
  /// request to the server. The request body contains the first name, last name,
  /// email address, country code, mobile number, password, firebase token, device
  /// id, and platform type. If the request is successful, the function navigates
  /// to the OTP screen with the email address, OTP type set to verify, and
  /// isFromSignUp set to true. If the request fails, the function shows an error
  /// message.
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

  /// It will do google signin and then it will do login if internet is connected
  /// otherwise it will show a toast message
  void doGoogleLogin() async {
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

  /// Do Apple Sign in and then it will do login if internet is connected.
  /// If email is not available in apple sign in then it will call
  /// [getEmailForAppleLogin] to get the email from our server.
  /// If internet is not connected then it will show a toast message
  void doAppleLogin() async {
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

  /// Call to server to get the email if it is not available during the Apple Sign in.
  /// [socialId] is the id of the user which is received from the Apple Sign in.
  /// If response is success then it will call [doLogin] method.
  /// If response is failure then it will print the error message.
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
  /// Do login.
  ///
  /// If the user is from social (google, apple) then it will directly go to dashboard.
  /// If the user is from normal login then it will check if the email is verified or not.
  /// If the email is not verified then it will show an alert to verify the email.
  /// If the email is verified then it will check if the mobile number is verified or not.
  /// If the mobile number is not verified then it will go to OTP screen to verify the mobile number.
  /// If the mobile number is verified then it will go to dashboard.
  /// If any error occurs then it will go to login screen.
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

  /// Adds a new user to the Firestore user collection.
  ///
  /// This function takes a [UserData] object and adds the user's information to
  /// the Firestore database with the user's ID as the document ID. If the user
  /// is successfully added and is using Google or Apple for login, it sets the
  /// login response and navigates to the dashboard. If the operation fails, it
  /// navigates to the login screen and logs the error.
  ///
  /// [userModel] is the user data object containing details such as first name,
  /// last name, profile image, mobile number, user ID, email, and FCM token.

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
