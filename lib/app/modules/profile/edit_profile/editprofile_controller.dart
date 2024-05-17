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

  formatHHMMSS() {
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
