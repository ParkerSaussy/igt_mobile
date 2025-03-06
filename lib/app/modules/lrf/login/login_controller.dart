import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/user_data.dart';
import 'package:lesgo/app/modules/lrf/biomateric_auth.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../master/general_utils/alertview.dart';
import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/generic_class/social_sign_in.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../../master/session/preference.dart';
import '../../../routes/app_pages.dart';
import '../../../services/fcm_service.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>(debugLabel: "login");

  RxBool isPasswordVisible = false.obs;
  RxBool isCheck = true.obs;
  RxBool isPhone = false.obs;
  RxString countryCode = "+1".obs;
  UserData userData = UserData();
  String socialId = "";
  String socialType = "";
  String socialEmail = "";
  String fName = "";
  String lName = "";
  String signInType = "";
  String profilePicture = "";

  @override
  void onInit() {
    // userData=Preference.getLoginResponse();
    super.onInit();
    checkFcmToken();
  }

  Future<void> checkFcmToken() async {
    if (Preference.getFirebaseToken() == "") {
      await FcmService().getFCMToken();
    }
  }

  void goToDashboard(){
    Get.offAll(BiomatericAuth());
    //Get.offAllNamed(Routes.DASHBOARD);
  }

  /// Initiates the login process by sending a request with user credentials
  /// and device information to the server. Based on the login response, it
  /// handles user existence in Firebase, updates FCM token, and navigates
  /// to the appropriate screen. If the user is logging in via social 
  /// accounts, it handles the necessary parameters accordingly. It also 
  /// verifies whether the user's email and mobile number are verified, 
  /// directing them to the OTP screen if needed.

  void doLogin() async {
    final deviceId = await getDeviceId();
    printMessage("Device Id " + deviceId.toString());
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
      /*RequestParams.profilePicture: signInType == SignInType.social
          ? profilePicture
          : "", //It will get after social login*/
      RequestParams.deviceId: deviceId,
      RequestParams.fcmToken: Preference.getFirebaseToken(),
      //here need to get FCM token from firebase Preference.getFirebaseToken()
      RequestParams.firstName:
          fName, //here need to get FCM token from firebase Preference.getFirebaseToken()
      RequestParams.lastName:
          lName, //here need to get FCM token from firebase Preference.getFirebaseToken()
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
          RequestManager.isRefreshingToken = false;
          if (!isUserExists) {
            createUserInFirebase(userModel);
          } else {
            FirebaseFirestore.instance
                .collection(FireStoreCollection.usersCollection)
                .doc(userModel.id.toString())
                .update({FireStoreParams.fcmToken: userModel.fcmToken}).then(
                    (value) {
              if (userModel.socialType == SocialType.google) {
                Preference.setLoginResponse(userModel);
                Preference.setIsLogin(true);
                //Get.offAllNamed(Routes.DASHBOARD);
                goToDashboard();
              } else if (userModel.socialType == SocialType.apple) {
                Preference.setLoginResponse(userModel);
                Preference.setIsLogin(true);
                //Get.offAllNamed(Routes.DASHBOARD);
                goToDashboard();
              } else {
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
                          Constants.fromLogin,
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
                      Constants.fromLogin,
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
                        Constants.fromLogin,
                        isPhone.value,
                        countryCode.value +
                            emailController.text.toString().trim(),
                        OTPType.verify
                      ]);
                    } else {
                      // Mobile is verified then Dashboard
                      Preference.setLoginResponse(userModel);
                      Preference.setIsLogin(true);
                      //Get.offAllNamed(Routes.DASHBOARD);
                      goToDashboard();
                    }
                  } else {
                    //Phone Number verified then dashboard
                    Preference.setLoginResponse(userModel);
                    Preference.setIsLogin(true);
                    //Get.offAllNamed(Routes.DASHBOARD);
                    goToDashboard();
                  }
                }
                clear();
              }
            });
          }
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  GoogleSignInClass googleSignInClass = GoogleSignInClass();

  /// It will do google signin and then it will do login if internet is connected
  /// otherwise it will show a toast message
  void doGoogleLogin() async {
    if (!await isConnectedNetwork()) {
      RequestManager.getSnackToast(
        // title: LabelKeys.noInternet.tr,
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
        profilePicture = currentUser.photoUrl ?? "";

        doLogin();
        printMessage('***************Google Response************************');
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

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  /// It will add the user in fireStore collection.
  /// If user is from google or apple then it will directly go to dashboard.
  /// If user is from normal login then it will check if the email is verified or not.
  /// If email is not verified then it will show a alert to verify the email.
  /// If email is verified then it will check if the mobile number is verified or not.
  /// If mobile number is not verified then it will go to OTP screen to verify the mobile number.
  /// If mobile number is verified then it will go to dashboard.
  /// If any error occurs then it will go to login screen.
  void createUserInFirebase(UserData userModel) {
    FireStoreServices.addDataWithDocumentId(
      isLoader: true,
      body: {
        FireStoreParams.firstName: userModel.firstName,
        FireStoreParams.lastName: userModel.lastName,
        FireStoreParams.profileImage: userModel.profileImage,
        FireStoreParams.mobileNumber:
            "${userModel.countryCode ?? ""}${userModel.mobileNumber ?? ""}",
        FireStoreParams.userId: userModel.id.toString(),
        FireStoreParams.email: userModel.email,
        FireStoreParams.fcmToken: userModel.fcmToken
      },
      documentId: userModel.id.toString(),
      collectionName: FireStoreCollection.usersCollection,
      onSuccess: (responseBody) {
        if (userModel.socialType == SocialType.google) {
          Preference.setLoginResponse(userModel);
          Preference.setIsLogin(true);
          //Get.offAllNamed(Routes.DASHBOARD);
          goToDashboard();
        } else if (userModel.socialType == SocialType.apple) {
          Preference.setLoginResponse(userModel);
          Preference.setIsLogin(true);
          //Get.offAllNamed(Routes.DASHBOARD);
          goToDashboard();
        } else {
          if (userModel.isEmailVerify == 0) {
            // Email Not Verified
            if (isPhone.value) {
              // First verify email
              AlertView().showAlertViewWithTwoButton(
                Get.context!,
                '${LabelKeys.emailIsNotVerifiedMsg.tr}${userModel.email.toString()})',
                LabelKeys.no.tr.toUpperCase(),
                LabelKeys.yes.tr.toUpperCase(),
                () {
                  Get.back();
                },
                () {
                  Get.toNamed(Routes.OTP_SCREEN, arguments: [
                    Constants.fromLogin,
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
                Constants.fromLogin,
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
                  Constants.fromLogin,
                  isPhone.value,
                  countryCode.value + emailController.text.toString().trim(),
                  OTPType.verify
                ]);
              } else {
                // Mobile is verified then Dashboard
                Preference.setLoginResponse(userModel);
                Preference.setIsLogin(true);
                //Get.offAllNamed(Routes.DASHBOARD);
                goToDashboard();
              }
            } else {
              //Phone Number verified then dashboard
              Preference.setLoginResponse(userModel);
              Preference.setIsLogin(true);
              //Get.offAllNamed(Routes.DASHBOARD);
              goToDashboard();
            }
          }
          clear();
        }
      },
      onFailure: (error) {
        Get.offAllNamed(Routes.LOGIN);
        printMessage("error: $error");
      },
    );
  }
}
