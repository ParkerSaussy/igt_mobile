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

  /// This method is used to get the cover images from the server and
  /// selected index is set according to the selectedWhenBack value.
  /// If selectedWhenBack value is present then the uploadedImageName is
  /// set to the same value and imageSelected is set to a random string.
  /// If selectedWhenBack is empty then the uploadedImageName is set to
  /// the first image of the list and imageSelected is set to a random string.
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

  /// This method is used to upload the trip cover image to the server.
  ///
  /// It requires a file which is the image to be uploaded.
  /// It also requires a loader to be shown while the image is being uploaded.
  /// It also requires the bearer token to be sent in the request header.
  /// It also requires the url of the server to be sent in the request.
  /// It also requires the fileName of the image which is the coverImage.
  /// If the image is uploaded successfully, it will return the uploaded
  /// image name in the response body.
  /// If the image is not uploaded successfully, it will return the error
  /// message in the response body.
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
