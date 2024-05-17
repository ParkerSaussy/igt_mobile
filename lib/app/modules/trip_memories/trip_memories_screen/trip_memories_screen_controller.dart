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

  /// call api for get trip document
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

  /// call api for delete memory from list
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
