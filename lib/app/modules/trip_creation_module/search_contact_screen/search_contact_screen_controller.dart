import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/add_guest_model.dart';
import 'package:lesgo/app/models/search_contact_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/networking/request_manager.dart';
import '../../../models/added_guest_model.dart';

class SearchContactScreenController extends GetxController {
  //TODO: Implement SearchContactScreenController

  var isGuest = true.obs;
  var isVIP = false.obs;
  var isCoHost = false.obs;
  RxList<SearchContactModel> fetchedContacts = <SearchContactModel>[].obs;
  RxList<SearchContactModel> fetchedSearchContacts = <SearchContactModel>[].obs;
  RxString fetchedContactsRestorationId = "".obs;
  RxBool permissionDenied = false.obs;
  TextEditingController searchTextEditController = TextEditingController();
  RxList<SearchContactModel> lstSelectedContact = <SearchContactModel>[].obs;
  List<AddGuestModel> lstAddGuest = [];
  int? tripId;
  RxBool isTripFinalized = false.obs;
  RxBool isHostOrCoHost = false.obs;

  @override
  void onInit() {
    super.onInit();
    tripId = Get.arguments[0];
    isHostOrCoHost.value = Get.arguments[1];
    isTripFinalized.value = Get.arguments[2];
    print(isHostOrCoHost.value);
    print("isTripFinalized${isTripFinalized.value}");
    getAllContacts();
  }

  Future<void> getAllContacts() async {
    if (await FlutterContacts.requestPermission(readonly: false)) {
      RequestManager.showEasyLoader();
      final contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withAccounts: true,
          withGroups: true,
          withThumbnail: true,
          withPhoto: true);

      for (int i = 0; i < contacts.length; i++) {
        final fullContact = await FlutterContacts.getContact(contacts[i].id);
        if (fullContact!
            .emails.isNotEmpty /* && fullContact.phones.isNotEmpty*/) {
          fetchedContacts.add(SearchContactModel(
              id: contacts[i].id,
              name: contacts[i].name,
              photo: contacts[i].photo,
              phones: contacts[i].phones,
              emails: contacts[i].emails,
              isSelected: false,
              selectedRole: "Guest",
              isCoHost: false));
        }
      }
      if (fetchedContacts.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.noContactsAvailable.tr,
          backgroundColor: Colors.blueAccent,
        );
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        fetchedSearchContacts.value.addAll(fetchedContacts);
        printMessage("Contact count ${fetchedSearchContacts.length}");
        getAddedContactsOfCurrentTrip();
      }
    }
  }

  void getAddedContactsOfCurrentTrip() {
    RequestManager.postRequest(
      uri: EndPoints.getTripGuestList,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: {RequestParams.tripId: tripId!.toString()},
      onSuccess: (responseBody, message, status) {
        var tempList = List<AddedGuestmodel>.from(
            responseBody.map((x) => AddedGuestmodel.fromJson(x)));
        List<SearchContactModel> tempContacts = [];
        tempContacts.addAll(fetchedSearchContacts);
        fetchedSearchContacts.clear();
        for(var selected in tempContacts){
          var isAlreadyAdded = false;
          for(var current in tempList){
            if(current.emailId == selected.emails[0].address){
              isAlreadyAdded = true;
            }
          }
          if(!isAlreadyAdded){
            fetchedSearchContacts.add(selected);
          }
        }
        fetchedContacts.clear();
        fetchedContacts.addAll(fetchedSearchContacts);
        fetchedContactsRestorationId.value = getRandomString();
      },
      onFailure: (error) {
        fetchedContactsRestorationId.value = getRandomString();
      },
    );
  }

  void addGuest() {
    for (int i = 0; i < lstSelectedContact.length; i++) {
      if (lstSelectedContact[i].selectedRole.isEmpty) {
        RequestManager.getSnackToast(message: LabelKeys.selectRoleMsg.tr);
        break;
      } else {
        lstAddGuest.add(AddGuestModel(
            tripId: tripId.toString(),
            firstName: lstSelectedContact[i].name.first,
            lastName: lstSelectedContact[i].name.last,
            emailId: lstSelectedContact[i].emails[0].address,
            phone: lstSelectedContact[i].phones.isNotEmpty
                ? lstSelectedContact[i].phones[0].number
                : '',
            role: lstSelectedContact[i].selectedRole,
            isCoHost: lstSelectedContact[i].isCoHost,
            inviteStatus: "Not Sent"));
      }
    }
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
    printMessage("addGuestMap: $addGuestMap");
    RequestManager.postRequest(
      uri: EndPoints.addGuestToTrip,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: true,
      body: {RequestParams.tripGuestsList: addGuestMap},
      onSuccess: (responseBody, message, status) {
        lstAddGuest.clear();
        lstSelectedContact.clear();
        Get.back();
        Get.back();
      },
      onFailure: (error) {
        printMessage("error: $error");
      },
    );

    /*lstAddGuest.add(AddGuestModel(
        tripId: tripId.toString(),
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        emailId: emailController.text,
        phone: "$countryCode${phoneController.text}",
        role: selectedGuest! == "Co-Host" ? "Guest" : selectedGuest!,
        isCoHost: selectedGuest! == "Co-Host" ? "true" : "false",
        inviteStatus: "Not Sent"
    ));*/
  }
}
