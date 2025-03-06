import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/app/models/tripmemory/trip_memory_activity_list_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/generic_class/image_picker.dart';

class AddNewPhotosController extends GetxController {
  //TODO: Implement AddNewPhotosController

  RxList<TripMemoryActivityListModel> lstActivity =
      <TripMemoryActivityListModel>[].obs;
  TripMemoryActivityListModel? selectedActivity;
  RxString selectedValue = "".obs;
  RxInt selectedValueId = 0.obs;
  //RxString selectedActivity = "Activity 1".obs;
  List<File> localImagePathList = [];
  List<XFile> localImagePathListTemp = [];
  var refreshString = "".obs;
  RxInt tripId = 0.obs;
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  GlobalKey<FormState> addNewPhotoKey = GlobalKey<FormState>();
  /*RxString imageSelected = "".obs;*/
  // Uint8List? selectedImageBytes;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    refreshString.value = getRandomString();
    tripId.value = Get.arguments;
    getTripMemoryMemory(tripId.value);
  }

  /// This function is used to get the trip memory activities from server.
  /// [value] is the trip id for which activities are required.
  /// The response is parsed and stored in the observable list [lstActivity].
  /// If server returns error, it is printed in the console.
  void getTripMemoryMemory(int value) {
    RequestManager.postRequest(
        uri: EndPoints.getActivityName,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {RequestParams.tripId: tripId.value},
        onSuccess: (responseBody, message, status) {
          lstActivity.clear();
          lstActivity.value = List<TripMemoryActivityListModel>.from(
              responseBody.map((x) => TripMemoryActivityListModel.fromJson(x)));
        },
        onFailure: (error) {
          printMessage("error: $error");
        });
  }

  /// This function is used to add new memory to the server.
  /// It takes the list of selected images, compresses and converts them to bytes,
  /// and then uploads them one by one to the server.
  /// If the upload is successful, it shows a success toast and navigates back.
  /// If the upload fails, it shows an error toast and navigates back.
  /// If there is no internet connection, it shows a connection failed toast and navigates back.
  ///
  Future<void> addMemory() async {
    File selectedImage;
    int counter = 0;
    RequestManager.showEasyLoader();
    localImagePathList = await CustomImagePicker.compressAndConvertImages(
        localImagePathListTemp);
    for (int i = 0; i < localImagePathList.length; i++) {
      selectedImage = File(localImagePathList[i].path);
      printMessage('Length ${selectedImage.path}');
      if (localImagePathList.isEmpty) {
        printMessage(
            "********************something wrong *************************");
        RequestManager.getSnackToast(
            message: LabelKeys.cBlankAddTripPhotosUploadPhoto.tr);
      } else {
        RequestManager.uploadImage(
          uri: EndPoints.addMemory,
          hasBearer: true,
          isLoader: false,
          isSuccessMessage: false,
          parameters: {
            RequestParams.tripId: tripId.value.toString(),
            RequestParams.caption: captionController.text.trim(),
            RequestParams.location: locationController.text.trim(),
            RequestParams.activityName: selectedValueId.value.toString(),
          },
          file: selectedImage,
          fileName: RequestParams.image,
          onSuccess: (response) {
            printMessage(response);
            counter++;
            if (counter == localImagePathList.length) {
              clear();
              EasyLoading.dismiss();
              Get.back();
            }
          },
          onFailure: (error) {
            counter++;
            if (counter == localImagePathList.length) {
              clear();
              EasyLoading.dismiss();
              Get.back();
            }
            printMessage("error: $error");
          },
          onConnectionFailed: (message) {
            counter++;
            if (counter == localImagePathList.length) {
              clear();
              EasyLoading.dismiss();
              Get.back();
            }
            printMessage("message: $message");
          },
        );
      }
    }
  }

  /// Clear caption, location controllers and local image path list.
  /// Reset selected activity value to empty string.
  void clear() {
    captionController.clear();
    locationController.clear();
    localImagePathList.clear();
    selectedValue.value = "";
  }
}
