import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/add_guest_model.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/general_utils/common_stuff.dart';

class AddGuestImportController extends GetxController {
  //TODO: Implement AddGuestImportController

  RxString selectedGuest = LabelKeys.guest.tr.obs;
  List<String> lstGuest = [
    LabelKeys.guest.tr,
    LabelKeys.vip.tr,
    LabelKeys.coHost.tr
  ];
  RxString countryCode = "+1".obs;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> signupFormKey =
      GlobalKey<FormState>(debugLabel: "add_guest_import");
  int? tripId;
  List<AddGuestModel> lstAddGuest = [];
  RxBool isHostOrCoHost = false.obs;
  RxBool isTripFinalized = false.obs;

  @override
  void onInit() {
    super.onInit();
    tripId = Get.arguments[0];
    isHostOrCoHost.value = Get.arguments[1];
    isTripFinalized.value = Get.arguments[2];
  }

  void addGuestAPI() {
    lstAddGuest.add(AddGuestModel(
        tripId: tripId.toString(),
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        emailId: emailController.text,
        phone: phoneController.text == ""
            ? ""
            : "$countryCode${phoneController.text}",
        role: selectedGuest.value == "Co-Host" ? "Guest" : selectedGuest.value,
        isCoHost: selectedGuest.value == "Co-Host" ? true : false,
        inviteStatus: "Not Sent"));
    final addGuestMap = lstAddGuest.map((e) {
      return {
        RequestParams.tripId: e.tripId,
        RequestParams.firstName: e.firstName,
        RequestParams.lastName: e.lastName,
        RequestParams.emailId: e.emailId,
        RequestParams.phone: e.phone,
        RequestParams.role: e.role,
        RequestParams.isCoHost: e.isCoHost,
        RequestParams.inviteStatus: e.inviteStatus,
      };
    }).toList();
    RequestManager.postRequest(
      uri: EndPoints.addGuestToTrip,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: true,
      body: {RequestParams.tripGuestsList: addGuestMap},
      onSuccess: (responseBody, message, status) {
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        countryCode.value = "+1";
        phoneController.clear();
        selectedGuest.value = "Guest";
        lstAddGuest.clear();
        activationMode.value = AutovalidateMode.disabled;
      },
      onFailure: (error) {
        printMessage("error: $error");
      },
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
