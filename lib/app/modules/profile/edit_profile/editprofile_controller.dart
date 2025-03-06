import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/app/modules/common_widgets/bottomsheet_with_close.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:path/path.dart';
import 'package:pinput/pinput.dart';

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/generic_class/image_picker.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../../master/session/preference.dart';
import '../../../models/user_data.dart';

class EditProfileController extends GetxController {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController paypalUsernameController = TextEditingController();
  TextEditingController venmoUsernameController = TextEditingController();
  TextEditingController uNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode paypalNode = FocusNode();
  FocusNode venmoNode = FocusNode();
  FocusNode uNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode mobileNode = FocusNode();

  Rx<AutovalidateMode> activationModeMobile = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> mobileFormKey = GlobalKey<FormState>();

  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  RxString imageSelected = "".obs;
  Uint8List? selectedImageBytes;
  RxString countryCode = "+1".obs;
  var tempProfileImage = ''.obs;
  RxString mobileFieldRestorationId = "".obs;
  var isResendVisible = false.obs;
  var timeStart = "00:25".obs;
  Timer? timer;
  int? timeCounter;
  String? imageProfile;
  final pinPutController = TextEditingController();
  final pinFocusNode = FocusNode();
  final pinFormKey = GlobalKey<FormState>();
  final defaultPinTheme = PinTheme(
    width: 40,
    height: 40,
    textStyle: onBackgroundTextStyleSemiBold(fontSize: AppDimens.textLarge),
    decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Get.theme.colorScheme.primary))),
  );
  final submittedPinTheme = PinTheme(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Get.theme.colorScheme.primary))),
  );
  final errorPinTheme = PinTheme(
    width: 40,
    height: 40,
    padding: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
    textStyle: onBackgroundTextStyleRegular(fontSize: AppDimens.textMedium)
        .copyWith(color: Get.theme.colorScheme.error, height: 10),
    decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Get.theme.colorScheme.error))),
  );

  final preFilledWidget = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 40,
        height: 1.5,
        decoration: const BoxDecoration(),
      )
    ],
  );

  //Rx<UserData> userData = UserData().obs;
  @override
  void onInit() {
    super.onInit();
    mobileFieldRestorationId.value = getRandomString();
    //gc.loginData.value = Preference.getLoginResponse();
    printMessage(gc.loginData.value.countryCode);
    countryCode.value = (gc.loginData.value.countryCode == "" ||
            gc.loginData.value.countryCode == null
        ? "+1"
        : gc.loginData.value.countryCode)!;
    printMessage("profileImage = ${gc.loginData.value.profileImage}");
    emailController.text = gc.loginData.value.email == null
        ? ""
        : gc.loginData.value.email.toString();
    fNameController.text = gc.loginData.value.firstName == null
        ? ""
        : gc.loginData.value.firstName.toString();
    lNameController.text = gc.loginData.value.lastName == null
        ? ""
        : gc.loginData.value.lastName.toString();
    paypalUsernameController.text = gc.loginData.value.paypalUsername == null
        ? ""
        : gc.loginData.value.paypalUsername.toString();
    venmoUsernameController.text = gc.loginData.value.venmoUsername == null
        ? ""
        : gc.loginData.value.venmoUsername.toString();
    mobileController.text = gc.loginData.value.mobileNumber == null
        ? ""
        : gc.loginData.value.mobileNumber.toString();
    tempProfileImage.value = gc.loginData.value.profileImage == null
        ? ""
        : gc.loginData.value.profileImage.toString();
  }

  /// Picks an image from the specified source, uploads it, and updates the profile image URL.
  ///
  /// This function uses `CustomImagePicker` to allow the user to select an image
  /// from the given [source]. The image is then cropped to a 1:1 aspect ratio.
  /// Once an image is selected, it is uploaded using `RequestManager`. On successful
  /// upload, the `tempProfileImage` is updated with the new image URL.
  /// 
  /// The function ensures UI updates after setting the new image URL.
  ///
  /// [source] specifies the source from which the image is to be picked (e.g., camera or gallery).
  /// [context] is the build context in which the function is executed.
  /// 
  /// Handles possible errors during image upload and connection failures by
  /// logging the error or message.

  void getImage(ImageSource source, BuildContext context) async {
    FGBGEvents.ignoreWhile(() async {
      final file = await CustomImagePicker.pickImage(
        source: source,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        isSelectMultipleImage: false,
      );
      if (file != "") {
        File selectedImage = File(file);
        RequestManager.uploadImage(
          isLoader: true,
          hasBearer: true,
          isSuccessMessage: false,
          parameters: {"type": 'normal'},
          uri: EndPoints.uploadImage,
          file: selectedImage,
          onSuccess: (responseBody) {
            String imageURL = responseBody['data']["image"];
            if (imageURL.isNotEmpty) {
              tempProfileImage.value = imageURL;
            }
            update();
          },
          onFailure: (error) {
            printMessage("error: $error");
          },
          onConnectionFailed: (message) {
            printMessage("message: $message");
          },
          fileName: RequestParams.image,
        );
      }
    });

  }

  /// 
  /// Edits the user's profile by sending a POST request to the server.
  ///
  /// This method takes the user's profile image, first name, last name, PayPal
  /// username, and Venmo username and sends a POST request to the
  /// [EndPoints.editProfile] endpoint. If the server responds with a success
  /// status, it updates the user's profile data in the local storage and
  /// navigates back to the previous screen. It also displays a toast message
  /// with the response message.
  void editProfile() {
    var profileImage = '';
    if (tempProfileImage.value.isNotEmpty) {
      File file = File(tempProfileImage.value);
      profileImage = basename(file.path);
      printMessage("image = $profileImage");
      printMessage("image = $profileImage");
    }
    var body = {
      RequestParams.profileImage: profileImage,
      RequestParams.firstName: fNameController.text.toString().trim(),
      RequestParams.lastName: lNameController.text.toString().trim(),
      RequestParams.paypalUsername:
          paypalUsernameController.text.toString().trim(),
      RequestParams.venmoUsername:
          venmoUsernameController.text.toString().trim()
    };
    RequestManager.postRequest(
      uri: EndPoints.editProfile,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          var userModel = userDataFromJson(jsonEncode(response['userData']));
          Preference.setLoginResponse(userModel);
          Get.back();
          RequestManager.getSnackToast(
              //title: LabelKeys.success,
              //buttonText: Get.context!.theme.colorScheme.onPrimaryContainer,
              message: message,
              colorText: Get.context!.theme.colorScheme.onSurface,
              backgroundColor: Get.context!.theme.colorScheme.primaryContainer);
        }
      },
      onFailure: (error) {},
    );
  }

  void clear() {
    fNameController.clear();
    lNameController.clear();
    uNameController.clear();
    emailController.clear();
    mobileController.clear();
  }

  /// Sends an OTP to the user's registered mobile number.
  ///
  /// This function creates a body with the receiver type as mobile, the receiver
  /// as the concatenation of the country code and the mobile number, and the
  /// OTP type as update mobile. It then sends a POST request to the
  /// [EndPoints.sendOtp] endpoint. If the server responds with a success status,
  /// it displays a bottom sheet with the OTP verification UI and starts a timer
  /// for 60 seconds. If the server responds with a failure status, it displays
  /// an error message.
  void sendOtp() {
    var body = {
      RequestParams.reciverType: RequestParams.mobile,
      RequestParams.reciver: "${countryCode.value}${mobileController.text}",
      RequestParams.otpType: OTPType.updateMobile,
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
          Get.bottomSheet(
            isScrollControlled: true,
            verifyOtpBottomSheet(),
          );
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
  /// This function takes the OTP entered by the user, sends a POST request to
  /// the [EndPoints.verifyOtp] endpoint with the OTP, and checks if the OTP is
  /// valid. If the OTP is valid, it updates the mobile number in the user's
  /// profile and navigates back to the previous screen. If the OTP is invalid,
  /// it displays an error message.
  void verifyOtpAPI() {
    var body = {
      RequestParams.reciverType: RequestParams.mobile,
      RequestParams.reciver: "${countryCode.value}${mobileController.text}",
      RequestParams.otpType: OTPType.updateMobile,
      RequestParams.otp: pinPutController.text.trim().toString()
    };
    printInfo(info: "body: $body");
    RequestManager.postRequest(
      uri: EndPoints.verifyOtp,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: body,
      onSuccess: (response, message, status) {
        if (status == true) {
          updateMobileNumber();
          Get.back();
        }
      },
      onFailure: (error) {
        Get.snackbar("", error,
            backgroundColor: Colors.red, colorText: Colors.white);
        printMessage(error);
      },
    );
  }

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

/// Formats the timeCounter into a "mm:ss" string and updates timeStart.
/// If timeCounter is positive, it calculates the minutes and seconds,
/// formats them with leading zeros, and assigns the result to timeStart.
/// If timeCounter is zero or negative, it sets timeStart to an empty string
/// and resets timeCounter to zero.

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

  /// Updates the user's mobile number by sending a POST request to the server.
  ///
  /// This function constructs a request body with the user's current country code
  /// and mobile number, then sends a POST request to the [EndPoints.updateMobileNumber]
  /// endpoint. If the request is successful and the server responds positively, it
  /// updates the user data in local storage with the response data and clears the
  /// OTP input field. It also updates the login data observable and generates a new
  /// restoration ID for the mobile field. If the request fails, it logs the error
  /// message and sets the mobile number in the login data observable to the current
  /// input.

  void updateMobileNumber() {
    var body = {
      RequestParams.countryCode: countryCode.value,
      RequestParams.mobileNumber: mobileController.text,
    };
    RequestManager.postRequest(
      uri: EndPoints.updateMobileNumber,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status == true) {
          var userModel = userDataFromJson(jsonEncode(response['userData']));
          pinPutController.clear();
          Preference.setLoginResponse(userModel);
          gc.loginData.value = Preference.getLoginResponse();
          mobileFieldRestorationId.value = getRandomString();
        }
      },
      onFailure: (error) {
        printMessage(error);
        gc.loginData.value.mobileNumber = mobileController.text;
      },
    );
  }

  /// Returns a bottom sheet widget with a PIN input field and a verification button.
  ///
  /// The PIN input field is a Pinput widget with a length of 4, a custom
  /// formatter to only allow digits, and a custom validator to check if the PIN
  /// is empty or not equal to 4. The focused pin theme is set to the submitted pin
  /// theme and the error pin theme is set to the error pin theme. The PIN input
  /// field is also focused when the bottom sheet is opened.
  ///
  /// The verification button is a gradient button with a text "Verify". When the
  /// button is pressed, the function `verifyOtpAPI` is called.
  ///
  /// The bottom sheet also has a resend OTP button. When the button is pressed,
  /// the `sendOtp` function is called and the bottom sheet is closed.
  Widget verifyOtpBottomSheet() {
    return Obx(
      () => BottomSheetWithClose(
        widget: Form(
          key: pinFormKey,
          child: Column(
            children: [
              AppDimens.paddingMedium.ph,
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.padding3XLarge),
                child: Pinput(
                  length: 4,
                  pinAnimationType: PinAnimationType.none,
                  controller: pinPutController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  focusNode: pinFocusNode,
                  defaultPinTheme: defaultPinTheme,
                  showCursor: false,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return LabelKeys.enterVerificationCode.tr;
                    }
                    if (v.length != 4) {
                      return LabelKeys.validEnterVerificationCode.tr;
                    } else {}
                    return null;
                  },
                  focusedPinTheme: submittedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (a) {
                    verifyOtpAPI();
                  },
                  errorPinTheme: errorPinTheme,
                  keyboardAppearance: Brightness.light,
                  preFilledWidget: preFilledWidget,
                ),
              ),
              AppDimens.paddingXXLarge.ph,
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingLarge),
                  child: MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.verify.tr,
                    onPressed: () {
                      pinFocusNode.unfocus();
                      if (pinFormKey.currentState!.validate()) {
                        hideKeyboard();
                        verifyOtpAPI();
                      }
                    },
                  )),
              AppDimens.paddingSmall.ph,
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingLarge),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: AppDimens.paddingHuge,
                      alignment: Alignment.center,
                      child: isResendVisible.value
                          ? const SizedBox()
                          : Text(
                              timeStart.value,
                              textAlign: TextAlign.center,
                              style: primaryTextStyleSemiBold(
                                  alpha: Constants.lightAlfa),
                            ),
                    ),
                    isResendVisible.value
                        ? MasterButtonsBounceEffect.textButton(
                            btnText: LabelKeys.resendOtp.tr,
                            onPressed: () {
                              pinPutController.clear();
                              startTimer();
                              Get.back();
                              sendOtp();
                            },
                            textStyles: primaryTextStyleRegular(
                                fontSize: AppDimens.textMedium))
                        : const SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
