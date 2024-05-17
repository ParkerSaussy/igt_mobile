import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../models/trip_cover_images_model.dart';

class SelectTripImageController extends GetxController {
  //RxList<String> lstImageURL = <String>[].obs;
  RxList<TripCoverImages> lstTripCoverImage = <TripCoverImages>[].obs;
  RxInt selectedIndex = 0.obs;
  RxString restorationId = "".obs;
  Uint8List? selectedImageBytes;
  RxString imageSelected = "".obs;
  RxString uploadedImageName = "".obs;
  RxString selectedPreImage = "".obs;
  RxString selectedWhenBack = "".obs;
  RxInt status = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    selectedIndex.value = -1;
    selectedWhenBack.value = Get.arguments[0];
    status.value = Get.arguments[1];
    lstTripCoverImage.value.clear();
    getCoverImages();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void getCoverImages() {
    RequestManager.getRequest(
      isSuccessMessage: false,
      isLoader: true,
      hasBearer: true,
      uri: EndPoints.getCoverImages,
      onSuccess: (responseBody, message) {
        lstTripCoverImage.value = List<TripCoverImages>.from(
            responseBody.map((x) => TripCoverImages.fromJson(x)));
        if (lstTripCoverImage.isNotEmpty) {
          if (status.value == 0) {
            for (int i = 0; i < lstTripCoverImage.length; i++) {
              if (lstTripCoverImage[i].imageName == selectedWhenBack.value) {
                selectedIndex.value = i;
                break;
              } else if (selectedWhenBack.value.isNotEmpty) {
                uploadedImageName.value = selectedWhenBack.value;
                imageSelected.value = getRandomString();
                break;
              }
            }
          } else {
            for (int i = 0; i < lstTripCoverImage.length; i++) {
              if (lstTripCoverImage[i].imageName == selectedWhenBack.value) {
                selectedIndex.value = i;
                selectedWhenBack.value = "";
                selectedPreImage.value = lstTripCoverImage[i].imageName!;
                printMessage("sdfjhbsdjfh1111: ${selectedPreImage.value}");
                printMessage(
                    "controller.uploadedImageName.value: ${uploadedImageName.value}");
                break;
              }
            }
            if (selectedWhenBack.value.isNotEmpty) {
              uploadedImageName.value = selectedWhenBack.value;
              printMessage("Uploaded222: ${uploadedImageName.value}");
              imageSelected.value = getRandomString();
            }
          }
        }
      },
      onFailure: (error) {
        printMessage("error: $error");
      },
    );
  }

  void uploadTripImages({required File selectedFile}) {
    RequestManager.uploadImage(
      isLoader: true,
      hasBearer: true,
      isSuccessMessage: false,
      uri: EndPoints.uploadTripCoverImage,
      file: selectedFile,
      onSuccess: (responseBody) {
        uploadedImageName.value = responseBody["data"]["coverImage"];
        selectedImageBytes = selectedFile.readAsBytesSync();
        selectedIndex.value = -1;
        imageSelected.value = getRandomString();
      },
      onFailure: (error) {
        printMessage("error: $error");
      },
      onConnectionFailed: (message) {
        printMessage("message: $message");
      },
      fileName: RequestParams.coverImage,
    );
  }
}
