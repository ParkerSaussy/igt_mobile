import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/add_guest_model.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/app/models/trip_list_model.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/constants.dart';

class TripGuestListController extends GetxController {
  //TODO: Implement TripGuestListController

  TextEditingController searchTextEditController = TextEditingController();
  TripListModel? tripListModel;
  RxList<AddedGuestmodel> lstAddedGuestModel = <AddedGuestmodel>[].obs;
  RxList<AddedGuestmodel> lstAddedGuestSearchData = <AddedGuestmodel>[].obs;
  RxList<AddedGuestmodel> lstSelectedContact = <AddedGuestmodel>[].obs;
  RxString restorationId = "".obs;
  List<AddGuestModel> lstAddGuest = [];
  int? tripId;
  RxBool isDataLoading = true.obs;
  RxBool isHostOrCoHost = false.obs;
  RxBool isTripFinalized = false.obs;
  @override
  void onInit() {
    super.onInit();
    tripListModel = Get.arguments[0];
    tripId = Get.arguments[1];
    isHostOrCoHost.value = Get.arguments[2];
    isTripFinalized.value = Get.arguments[3];
    getAddedContacts();
  }

  void getAddedContacts() {
    RequestManager.postRequest(
      uri: EndPoints.getTripGuestList,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: {RequestParams.tripId: tripListModel!.id.toString()},
      onSuccess: (responseBody, message, status) {
        lstAddedGuestModel.clear();
        var tempList = List<AddedGuestmodel>.from(
            responseBody.map((x) => AddedGuestmodel.fromJson(x)));
        //Use only guest not host
        for(var item in tempList){
          if(item.uId != tripListModel!.hostDetail!.id){
            lstAddedGuestModel.value.add(item);
          }
        }
        lstAddedGuestSearchData.value.addAll(lstAddedGuestModel);
        getAddedContactsOfCurrentTrip();
        //isDataLoading.value = false;
      },
      onFailure: (error) {
        lstAddedGuestModel.clear();
        lstAddedGuestSearchData.clear();
        isDataLoading.value = false;
      },
    );
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
        List<AddedGuestmodel> tempGuestList = [];
        tempGuestList.addAll(lstAddedGuestSearchData);
        lstAddedGuestSearchData.clear();
        printMessage("temp guaest list count ${tempGuestList.length}");
        for(var selected in tempGuestList){
          var isAlreadyAdded = false;
          for(var current in tempList){
            if(current.uId! == selected.uId!){
              isAlreadyAdded = true;
            }
          }
          if(!isAlreadyAdded){
            printMessage("Add gauest ${selected.emailId}");
            lstAddedGuestSearchData.add(selected);
          }
        }
        printMessage("Search Guest list count ${lstAddedGuestSearchData.length}");
        lstAddedGuestModel.clear();
        lstAddedGuestModel.addAll(lstAddedGuestSearchData);
        printMessage("Search Guest list count again ${lstAddedGuestSearchData.length}");
        isDataLoading.value = false;
        restorationId.value = getRandomString();
      },
      onFailure: (error) {
        isDataLoading.value = false;
      },
    );
  }

  void addGuest() {
    for (int i = 0; i < lstSelectedContact.length; i++) {
      lstAddGuest.add(AddGuestModel(
          tripId: tripId.toString(),
          firstName: lstSelectedContact[i].firstName!,
          lastName: lstSelectedContact[i].lastName ?? "",
          emailId: lstSelectedContact[i].emailId ?? "",
          phone: lstSelectedContact[i].phoneNumber ?? "",
          role: lstSelectedContact[i].role ?? Role.guest,
          isCoHost: lstSelectedContact[i].isCoHost!,
          inviteStatus: "Not Sent"));
    }
    final addGuestMap = lstAddGuest.map((e) {
      return {
        RequestParams.tripId: e.tripId,
        RequestParams.firstName: e.firstName,
        RequestParams.lastName: e.lastName,
        RequestParams.emailId: e.emailId,
        RequestParams.phone: e.phone,
        RequestParams.role: /*e.role == Role.host ?*/ Role.guest /*: e.role*/,
        RequestParams.isCoHost: /*e.isCoHost*/ false,
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
        lstAddGuest.clear();
        lstSelectedContact.clear();
        Get.back();
        Get.back();
        Get.back();
      },
      onFailure: (error) {
        lstAddGuest.clear();
        printMessage("error: $error");
      },
    );
  }
}
