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

  void clear() {
    captionController.clear();
    locationController.clear();
    localImagePathList.clear();
    selectedValue.value = "";
  }
}
