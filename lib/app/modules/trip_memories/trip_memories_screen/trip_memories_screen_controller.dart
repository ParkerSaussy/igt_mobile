import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_memories_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class TripMemoriesScreenController extends GetxController {
  //TODO: Implement TripMemoriesScreenController

  RxList<TripMemoriesModel> lstTripMemories =
      List<TripMemoriesModel>.empty(growable: true).obs;
  RxList<TripMemoriesModel> secList =
      List<TripMemoriesModel>.empty(growable: true).obs;
  List<TripMemoriesModel> lstTripImages = [];
  RxList<TripMemoriesModel> selectedTripImages = <TripMemoriesModel>[].obs;
  RxString gridRestorationId = "".obs;
  RxBool isLongPressEnabled = false.obs;
  RxBool isDropboxLinkEdit = false.obs;
  RxInt tripId = 0.obs;
  RxString tripRole = ''.obs;
  RxString dropboxUrl = ''.obs;
  Map<String?, List<TripMemoriesModel>>? newList;
  RxList<int> lstTrip = <int>[].obs;
  int? selectedIndex;
  RxBool isMemoriesFetch = false.obs;
  RxBool isDataLoading = true.obs;
  TextEditingController dropboxLinkController = TextEditingController();
  FocusNode focusNodeUrl = FocusNode();
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> urlFormKey = GlobalKey<FormState>(debugLabel: "url");
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tripId.value = Get.arguments[0];
    tripRole.value = Get.arguments[1];
    dropboxUrl.value = Get.arguments[2];
    if (dropboxUrl.value.isNotEmpty) {
      dropboxLinkController.text = dropboxUrl.value;
    }
    memoryListing(tripId.value);
  }

  
  /// API call to get the list of memories in the trip.
  ///
  /// This API is called when the user opens the trip memories screen.
  /// The response of this API is stored in the lstTripMemories observable list.
  /// The list is then grouped by the date it was created.
  /// The grouped list is stored in the newList observable map.
  /// The observable isMemoriesFetch is set to true if the list is not empty.
  /// Otherwise, it is set to false.
  /// The observable isDataLoading is set to false after the API call is completed.
  void memoryListing(int tripId) {
    RequestManager.postRequest(
        uri: EndPoints.memoryListing,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {RequestParams.tripId: tripId},
        onSuccess: (responseBody, message, status) {
          lstTripMemories.value = List<TripMemoriesModel>.from(
              responseBody.map((x) => TripMemoriesModel.fromJson(x)));
          secList.addAll(lstTripMemories.value);
          for (int i = 0; i < lstTripMemories.length; i++) {
            var createdDate = lstTripMemories[i].createdAt;
            String formatDate = Date.shared().stringFromDate(createdDate!);
            lstTripMemories[i].groupDate = formatDate;
          }
          final groupList = groupBy(lstTripMemories, (p0) => p0.groupDate);
          newList = groupList;
          if (lstTripMemories.isNotEmpty) {
            isMemoriesFetch.value = true;
          } else {
            isMemoriesFetch.value = false;
          }
          isDataLoading.value = false;
          gridRestorationId.value = getRandomString();
        },
        onFailure: (error) {
          printMessage("error: $error");
          secList.clear();
          selectedTripImages.clear();
          lstTripMemories.clear();
          newList?.clear();
          isDataLoading.value = false;
          gridRestorationId.value = getRandomString();
        });
  }

  
  /// Sends a request to delete selected memories for the current trip.
  ///
  /// This function makes a POST request to the `deleteMemory` endpoint
  /// with the current trip ID and the list of memory IDs to be deleted.
  /// If the request is successful, it clears the list of selected trip IDs,
  /// trip memories, and selected trip images, and refreshes the memory list
  /// by calling `memoryListing`. It also updates the `gridRestorationId` to
  /// a new random string to refresh the UI.
  /// In case of failure, it logs the error, clears the necessary lists,
  /// and refreshes the UI.

  void callApiForDeleteMemory() {
    RequestManager.postRequest(
        uri: EndPoints.deleteMemory,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: true,
        isFailedMessage: true,
        body: {
          RequestParams.tripId: tripId.toString(),
          RequestParams.memoryId: lstTrip
        },
        onSuccess: (responseBody, message, status) async {
          lstTrip.clear();
          lstTripMemories.clear();
          selectedTripImages.clear();
          isMemoriesFetch.value = false;
          memoryListing(tripId.value);
          gridRestorationId.value = getRandomString();
        },
        onFailure: (error) {
          printMessage("error: $error");
          lstTrip.clear();
          lstTripMemories.clear();
          newList!.clear();
          selectedTripImages.clear();
          gridRestorationId.value = getRandomString();
        });
  }

  /// Makes a request to add a Dropbox URL for the current trip.
  ///
  /// This function makes a POST request to the `addDropboxUrl` endpoint
  /// with the current trip ID and the Dropbox URL entered by the user.
  /// If the request is successful, it disables the Dropbox link edit
  /// mode by setting `isDropboxLinkEdit` to `false`. In case of failure,
  /// it does nothing.
  void callApiForDropboxUrl() {
    RequestManager.postRequest(
        uri: EndPoints.addDropboxUrl,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: true,
        isFailedMessage: true,
        body: {
          RequestParams.tripId: tripId.toString(),
          RequestParams.dropboxUrl: dropboxLinkController.text.toString()
        },
        onSuccess: (responseBody, message, status) {
          isDropboxLinkEdit.value = false;
        },
        onFailure: (error) {});
  }
}
