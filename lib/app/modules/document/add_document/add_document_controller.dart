import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/document_list.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/general_utils/common_stuff.dart';

class AddDocumentController extends GetxController {
  //TODO: Implement AddDocumentController

  var isUpload = false.obs;
  TextEditingController docController = TextEditingController();
  FocusNode docNode = FocusNode();
  GlobalKey<FormState> addDocumentKey = GlobalKey<FormState>();
  PlatformFile? file;
  RxInt tripId = 0.obs;
  RxString editValue = "".obs;
  DocumentList? lstDocument;
  RxString docFileSize = ''.obs;
  RxString docFileName = ''.obs;
  RxString docFileExtension = ''.obs;
  RxString fileSize = "".obs;
  RxInt documentId = 0.obs;
  File? selectedDocumentFile;
  RxBool isImageChange = false.obs;
  @override
  void onInit() {
    super.onInit();

    editValue.value = Get.arguments[0];
    printMessage("editValue ${editValue.value}");

    /// for document edit time if edit value 1
    if (editValue.value == "1") {
      tripId.value = Get.arguments[1];
      lstDocument = Get.arguments[2];
      docController.text = lstDocument!.documentName ?? "";
      docFileSize.value = lstDocument!.image!;
      isUpload.value = true;
      documentId.value = lstDocument!.id!;
      printMessage("documentId${documentId.value}");
    } else {
      tripId.value = Get.arguments[1];
    }
  }

  
  /// Returns a human-readable string representing the given number of bytes.
  ///
  /// The [decimals] parameter specifies the number of decimal places to
  /// include in the string. It defaults to 0.
  ///
  /// Example: getFileSizeString(1234567) => "1.2mb"
  String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  /// get document file extension
  String? getFileExtension(String fileName) {
    try {
      return fileName.split('.').last;
    } catch (e) {
      return null;
    }
  }

  
  /// Pick files from device and check size is less than 5MB
  /// if yes then set the flag isUpload to true and set the file size and name
  /// if size is greater than 5MB then show snack toast with error message
  Future<void> pickFiles() async {
    isUpload.value = false;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
    );
    if (result != null) {
      if (result.files.isNotEmpty) {
        if (editValue.value == "0") {
          lstDocument = null;
          selectedDocumentFile = File(result.files[0].path!);
          double sizeInMb =
              fileSizeCalculator(selectedDocumentFile!.lengthSync());
          if (sizeInMb <= 5) {
            //uploadFiles(File(result.files[0].path!));
            isUpload.value = true;
            docFileSize.value =
                getFileSizeString(bytes: selectedDocumentFile!.lengthSync());
            docFileName.value = getFileNameFromURL(result.files[0].path!);
            docFileExtension.value = getFileExtension(result.files[0].path!)!;
          } else {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankTripDocumentFileSize.tr);
          }
          isUpload.value = true;
          file = result.files.first;
        } else {
          isImageChange.value = true;
          lstDocument = null;
          selectedDocumentFile = File(result.files[0].path!);
          double sizeInMb =
              fileSizeCalculator(selectedDocumentFile!.lengthSync());
          if (sizeInMb <= 5) {
            //uploadFiles(File(result.files[0].path!));
            isUpload.value = true;
            docFileSize.value =
                getFileSizeString(bytes: selectedDocumentFile!.lengthSync());
            docFileName.value = getFileNameFromURL(result.files[0].path!);
            docFileExtension.value = getFileExtension(result.files[0].path!)!;
          } else {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankTripDocumentFileSize.tr);
          }
          isUpload.value = true;
          file = result.files.first;
        }
      }
    }
  }

  
  /// Uploads a file to the server.
  ///
  /// This method takes a [File] and uses `RequestManager.uploadImage` to upload
  /// it to the server. After the image is uploaded, it updates the UI with the
  /// uploaded image URL.
  void uploadFiles(File file) {
    RequestManager.uploadImage(
      isLoader: true,
      hasBearer: true,
      isSuccessMessage: false,
      uri: EndPoints.uploadImage,
      parameters: {RequestParams.type: "document"},
      file: file,
      onSuccess: (responseBody) {
        EasyLoading.show();
        String imageURL = responseBody['data']["image"];
        if (imageURL.isNotEmpty) {
          docFileName.value = getFileNameFromURL(imageURL);
          docFileExtension.value = getFileExtension(imageURL)!;
        }
        uploadTripDocument(Get.context!);
        update();
      },
      onFailure: (error) {
        printMessage("error: $error");
        EasyLoading.dismiss();
      },
      onConnectionFailed: (message) {
        printMessage("message: $message");
        EasyLoading.dismiss();
      },
      fileName: RequestParams.image,
    );
  }

  
  /// Uploads a trip document to the server.
  ///
  /// This method takes a file and documents name and uses `RequestManager.postRequest`
  /// to upload it to the server. After the document is uploaded, it updates the UI
  /// by popping the current screen.
  ///
  /// Parameters:
  /// - [context]: The context of the screen.
  void uploadTripDocument(context) {
    print("docFileName.value:${docFileName.value}");
    var body = {
      RequestParams.tripId: tripId.value.toString(),
      RequestParams.documentName: docController.text,
      RequestParams.document: editValue.value == "0"
          ? getFileNameFromURL(docFileName.value)
          : isImageChange.value
              ? getFileNameFromURL(docFileName.value)
              : getFileNameFromURL(lstDocument!.image!),
      RequestParams.documentId: editValue.value == "0" ? "" : documentId.value,
      RequestParams.size:
          editValue.value == "0" ? docFileSize.value : fileSize.value
    };
    RequestManager.postRequest(
      uri: EndPoints.uploadTripDocument,
      isLoader: false,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        EasyLoading.dismiss();
        Get.back();
      },
      onFailure: (error) {
        EasyLoading.dismiss();
        printMessage(error);
      },
    );
  }
}
