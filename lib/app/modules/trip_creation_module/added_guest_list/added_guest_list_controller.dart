import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';

import '../../../../master/general_utils/common_stuff.dart';

class AddedGuestListController extends GetxController {
  //TODO: Implement AddedGuestListController

  var isGuest = true.obs;
  var isVIP = false.obs;
  var isCoHost = false.obs;
  TextEditingController searchTextEditController = TextEditingController();
  //int? tripId;
  int? hostId;
  TripDetailsModel? tripDetailsModel;
  RxBool isHostOrCoHost = false.obs;
  RxBool isTripFinalized = false.obs;
  RxList<AddedGuestmodel> lstAddedGuestModel = <AddedGuestmodel>[].obs;
  RxList<AddedGuestmodel> lstAddedGuestSearchData = <AddedGuestmodel>[].obs;
  RxString restorationId = "".obs;
  int fromScreen = Constants.fromCreateTrip;
  List<dynamic> lstIds = [];
  RxBool isDataLoading = true.obs;

  @override
  void onClose() {
    // TODO: implement onClose
    searchTextEditController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    tripDetailsModel = Get.arguments[0];
    fromScreen = Get.arguments[1];
    hostId = Get.arguments[2];
    if (fromScreen == Constants.fromCreateTrip) {
      isHostOrCoHost.value = true;
      isTripFinalized.value = false;
    } else {
      isTripFinalized.value = tripDetailsModel!.isTripFinalised!;
      isHostOrCoHost.value = tripDetailsModel!.role == Role.host ||
          tripDetailsModel!.isCoHost == 1;
    }
    getAddedContacts();
  }

  
  /// This method is used to get the added guest list from the server.
  /// We are clearing the lstAddedGuestModel and then adding the data
  /// to lstAddedGuestModel and lstAddedGuestSearchData.
  /// We are also saving the uId of the guest in lstIds.
  /// If lstIds is not empty then we are calling updateMemberInFireStore
  /// to update the member status in the firestore.
  /// If there is an error then we are calling updateMemberInFireStore
  /// to update the member status in the firestore.
  /// If the lstAddedGuestSearchData is empty then we are navigating to
  /// ADD_GUEST_IMPORT screen.
  void getAddedContacts() {
    RequestManager.postRequest(
      uri: EndPoints.getTripGuestList,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: {RequestParams.tripId: tripDetailsModel!.id.toString()},
      onSuccess: (responseBody, message, status) {
        lstAddedGuestModel.clear();
        lstAddedGuestModel.value = List<AddedGuestmodel>.from(
            responseBody.map((x) => AddedGuestmodel.fromJson(x)));
        lstAddedGuestSearchData.value = lstAddedGuestModel;
        if (lstAddedGuestSearchData.isNotEmpty) {
          //lstIds.add(hostId.toString());
          for (int i = 0; i < lstAddedGuestSearchData.length; i++) {
            if (lstAddedGuestSearchData[i].uId != 0) {
              lstIds.add(lstAddedGuestSearchData[i].uId.toString());
            }
          }
        }
        isDataLoading.value = false;
        updateMemberInFireStore(lstIds, true);
      },
      onFailure: (error) {
        updateMemberInFireStore([hostId.toString()], false);
        /*if (lstAddedGuestSearchData.isEmpty) {
          Get.toNamed(Routes.ADD_GUEST_IMPORT,
                  arguments: [tripDetailsModel!.id])
              ?.then((value) => getAddedContacts());
        }*/
        lstAddedGuestModel.clear();
        lstAddedGuestSearchData.clear();
        isDataLoading.value = false;
      },
    );
  }

  /// Sends an invitation to a guest via API.
  ///
  /// This method initiates a POST request to send an invitation to a guest
  /// identified by [guestId] for a specific trip.
  /// The request includes the trip ID and guest ID in the body.
  /// On successful invitation, it prints the response body and refreshes
  /// the added contacts list by calling [getAddedContacts].
  /// If the request fails, no specific failure action is taken.

  void sendInviteApiCall(String guestId) {
    RequestManager.postRequest(
      uri: EndPoints.sendInvitation,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: true,
      body: {
        RequestParams.tripId: tripDetailsModel!.id.toString(),
        RequestParams.guestId: guestId,
      },
      onSuccess: (responseBody, message, status) {
        printMessage("responseBody: $responseBody");
        getAddedContacts();
      },
      onFailure: (error) {},
    );
  }

  /// Removes a guest from a trip.
  ///
  /// This method initiates a POST request to remove a guest identified by
  /// [guestId] from a trip identified by [tripDetailsModel!.id].
  /// The request includes the trip ID and guest ID in the body.
  /// On successful removal, it prints the response body and refreshes
  /// the added contacts list by calling [getAddedContacts].
  /// If the request fails, no specific failure action is taken.
  void removeGuestApi(String guestId, uid) {
    printMessage("lstId111s: $lstIds");
    //lstIds.removeWhere((element) => element = uid);
    //print("lstIds: ${lstIds}");
    RequestManager.postRequest(
      uri: EndPoints.removeInvitee,
      hasBearer: true,
      isSuccessMessage: true,
      isLoader: true,
      body: {
        RequestParams.tripId: tripDetailsModel!.id,
        RequestParams.guestId: guestId,
      },
      onSuccess: (responseBody, message, status) {
        //lstIds.removeWhere((element) => element = uid);
        //updateMemberInFireStore(lstIds, true);
        getAddedContacts();
      },
      onFailure: (error) {},
    );
  }

  /// Updates the role of a guest in a trip.
  ///
  /// This method initiates a POST request to update the role of a guest
  /// identified by [guestId] in a trip identified by [tripDetailsModel!.id].
  /// The request includes the trip ID, guest ID, role, and isCoHost in the body.
  /// On successful update, it refreshes the added contacts list by calling
  /// [getAddedContacts].
  /// If the request fails, no specific failure action is taken.
  void updateGuestRole(String guestId, String selectedRole, bool isCoHost) {
    final body = {
      RequestParams.tripId: tripDetailsModel!.id.toString(),
      RequestParams.guestId: guestId,
      RequestParams.role: selectedRole,
      RequestParams.isCoHost: isCoHost,
    };
    //Log.displayResponse(payload: body, requestType: "", res: "");
    RequestManager.postRequest(
      uri: EndPoints.updateGuestRole,
      hasBearer: true,
      isLoader: true,
      body: body,
      onSuccess: (responseBody, message, status) {
        getAddedContacts();
      },
      onFailure: (error) {},
    );
  }

  /// Updates the list of member IDs in the trip group document identified by
  /// [tripDetailsModel!.id] in the [FireStoreCollection.tripGroupCollection]
  /// collection with the provided [memberIds].
  ///
  /// This method initiates an update request to the Firestore database to
  /// update the list of member IDs. If the update is successful, it removes all
  /// IDs from the [lstIds] list except the current user ID. If the update fails,
  /// no specific failure action is taken.
  ///
  /// The [isLoader] parameter specifies whether to show a loader while the
  /// request is being processed.
  void updateMemberInFireStore(List<dynamic> memberIds, bool isLoader) {
    FireStoreServices.updateDataWithDocumentId(
      isLoader: isLoader,
      body: {FireStoreParams.memberIds: memberIds},
      documentId: tripDetailsModel!.id.toString(),
      collectionName: FireStoreCollection.tripGroupCollection,
      onSuccess: (responseBody) {
        lstIds.removeWhere((element) => element != gc.loginData.value.id);
      },
      onFailure: (error) {},
    );
  }
}
