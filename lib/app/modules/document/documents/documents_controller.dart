import 'dart:math';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../models/document_list.dart';

class DocumentsController extends GetxController {
  //TODO: Implement DocumentsController
  RxString restorationDocId = ''.obs;
  var isSelected = false.obs;
  RxList<DocumentList> docList = List<DocumentList>.empty(growable: true).obs;
  RxList<DocumentList> secList = List<DocumentList>.empty(growable: true).obs;
  var totalSelected = 0.obs;
  RxInt tripId = 0.obs;
  RxList<int> lstDoc = <int>[].obs;
  Map<String?, List<DocumentList>>? newList;
  RxBool isDocumentFetch = false.obs;
  RxBool isDataLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    tripId.value = Get.arguments;
    getTripDocuments(tripId.value);
  }

  /// Converts a given date string into a relative time string.
  ///
  /// If the given date is today, it returns a string in the format "hh:mm a".
  /// If the given date is yesterday, it returns the string "Yesterday".
  /// Otherwise, it returns a string in the format "dd MMM yyyy".
  ///
  /// Example:
  String daysBetween(String crDate) {
    DateTime fromUtc =
        DateFormat("yyyy/MM/dd hh:mm:ss aa").parse(crDate, true).toLocal();
    DateTime to = DateTime.now().toLocal();
    var diff = (to.difference(fromUtc).inDays);
    var timeAgo = DateFormat('hh:mm a').format(fromUtc);
    if (diff == 1) {
      timeAgo = LabelKeys.yesterday.tr;
    } else if (diff == 0) {
      timeAgo = LabelKeys.today.tr;
    } else {
      timeAgo = DateFormat('dd MMM yyyy').format(fromUtc);
    }

    return timeAgo;
  }

  
  /// Select all documents in the list.
  ///
  /// [isValue] is `true` to select all documents, or `false` to deselect all.
  ///
  /// This will loop through the [docList] and set the [DocumentList.isSelected]
  /// property of each document to [isValue].
  ///
  /// Also, it will set the value of [totalSelected] to the number of selected
  /// documents.
  void selectAll(bool isValue) {
    totalSelected.value = 0;
    if (isValue) {
      for (int i = 0; i < docList.value.length; i++) {
        docList.value[i].isSelected = true;
        totalSelected.value++;
      }
    } else {
      for (int i = 0; i < docList.value.length; i++) {
        docList.value[i].isSelected = false;
      }
    }
  }

  
  /// Fetches the list of trip documents from the API.
  ///
  /// This method sends a POST request to the [EndPoints.getTripDocuments] endpoint
  /// using the provided trip ID. If the request is successful, it populates
  /// [docList] with the retrieved documents and organizes them by their creation
  /// date. It also updates the [isDocumentFetch] status and generates a new
  /// [restorationDocId].
  ///
  /// If the request fails, it clears the current document lists, updates the
  /// loading status, and resets the selection state.
  ///
  /// [tripId]: The unique identifier of the trip for which documents are to be fetched.

  void getTripDocuments(int tripId) {
    RequestManager.postRequest(
        uri: EndPoints.getTripDocuments,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {RequestParams.tripId: tripId},
        onSuccess: (responseBody, message, status) {
          docList.value = List<DocumentList>.from(
              responseBody.map((x) => DocumentList.fromJson(x)));
          secList.addAll(docList.value);
          for (int i = 0; i < docList.length; i++) {
            var createdDate = docList[i].createdAt;
            String formateDate = Date.shared().stringFromDate(createdDate!);
            docList[i].groupDate = formateDate;
            printMessage(docList[i].groupDate);
          }
          final groupList = groupBy(docList, (p0) => p0.groupDate);
          newList = groupList;
          isDocumentFetch.value = true;

          restorationDocId.value = getRandomString();
        },
        onFailure: (error) {
          printMessage("error: $error");
          secList.clear();
          lstDoc.clear();
          docList.clear();
          newList?.clear();
          isDataLoading.value = false;
          restorationDocId.value = getRandomString();
          isSelected.value = false;
        });
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

  
  /// Deletes selected documents from the current trip.
  ///
  /// This method sends a POST request to the [EndPoints.deleteTripDocuments] endpoint
  /// using the list of selected document IDs. If the request is successful, it clears
  /// the current document lists, updates the loading status and selection state, and
  /// re-fetches the document list from the server. It also generates a new
  /// [restorationDocId].
  ///
  /// If the request fails, it clears the current document lists and selection state.
  void deleteTripDocuments() {
    RequestManager.postRequest(
        uri: EndPoints.deleteTripDocuments,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {RequestParams.documentId: lstDoc},
        onSuccess: (responseBody, message, status) async {
          printMessage(responseBody);
          lstDoc.clear();
          docList.clear();
          isSelected.value = false;
          isDocumentFetch.value = false;
          getTripDocuments(tripId.value);
          restorationDocId.value = getRandomString();
        },
        onFailure: (error) {
          printMessage("error: $error");
          lstDoc.clear();
          docList.clear();
          newList!.clear();
        });
  }

  
  /// Returns the file extension from the given file name.
  ///
  /// This method takes a file name and returns its extension by splitting the
  /// string at the last occurrence of '.' and returning the last part of the
  /// split result. If the file name does not contain a '.', it returns null.
  ///
  /// For example, if the file name is "example.txt", the method returns ".txt".
  String? getFileExtension(String fileName) {
    try {
      return ".${fileName.split('.').last}";
    } catch (e) {
      return null;
    }
  }
}
