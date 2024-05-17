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

  /// check selected value
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

  /// call api for get trip document
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

  /// calculate the uploading file size
  String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  /// call api for particular delete trip from document
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

  /// get file extension from url
  String? getFileExtension(String fileName) {
    try {
      return ".${fileName.split('.').last}";
    } catch (e) {
      return null;
    }
  }
}
