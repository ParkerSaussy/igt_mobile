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

  /// This function is used to add the guest to the trip.
  ///
  /// It will create the [AddGuestModel] object from the user input and add it to the [lstAddGuest].
  /// Then it will call the [RequestManager.postRequest] to add the guest to the trip.
  /// If the API call is success, it will clear all the text editing controllers, reset the [countryCode] to "+1",
  /// reset the [selectedGuest] to "Guest", clear the [lstAddGuest] and set the [activationMode] to disabled.
  /// If the API call fails, it will print the error message.
  ///
  /// The API endpoint is [EndPoints.addGuestToTrip].
  ///
  /// The request body is a list of [AddGuestModel] objects in the form of a map.
  /// The map contains the key value pairs of guest details.
  /// The keys are [RequestParams.tripId], [RequestParams.firstName], [RequestParams.lastName], [RequestParams.emailId], [RequestParams.phone], [RequestParams.role], [RequestParams.isCoHost], [RequestParams.inviteStatus].
  /// The values are the respective values of the guest details.
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
