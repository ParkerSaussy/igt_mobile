import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/lrf/biomateric_auth.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class FireStoreCollection {
  static const usersCollection = "users";
  static const tripGroupCollection = "tripGroups";
  static const tripMessages = "tripMessages";
}

class FireStoreParams {
  //CREATE USER PARAMS
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const profileImage = 'profileImage';
  static const mobileNumber = 'mobileNumber';
  static const userId = 'userId';
  static const email = 'email';
  static const fcmToken = 'fcmToken';

  //CREATE GROUP PARAMS
  static const tripId = 'tripId';
  static const fileName = 'fileName';
  static const fileType = 'fileType';
  static const groupData = 'groupData';
  static const groupAdmin = 'groupAdmin';
  static const groupName = 'groupName';
  static const groupCreatedAt = 'groupCreatedAt';
  static const groupImage = 'groupImage';
  static const totalMembers = 'totalMembers';
  static const memberIds = 'memberIds';
  static const message = 'message';
  static const senderId = 'senderId';
  static const timestamp = 'timestamp';

  //MESSAGES PARAMS
  static const messageType = 'messageType';
  static const replyOfId = 'replyOfId';
  static const messageId = 'messageId';
  static const groupedDate = 'groupedDate';
  static const isSelected = 'isSelected';
}

class FireStoreServices {
  static Future<void> addDataWithDocumentId({
    required body,
    required String documentId,
    required String collectionName,
    bool isLoader = false,
    bool isFailedMessage = true,
    required Function(dynamic responseBody) onSuccess,
    required Function onFailure,
  }) async {
    try {
      if (!await isConnectedNetwork()) {
        RequestManager.getSnackToast(
          message: LabelKeys.checkInternet.tr,
        );
        return;
      }
      if (isLoader) {
        RequestManager.showEasyLoader();
      }
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .set(body)
          .then((value) {
        if (isLoader) {
          EasyLoading.dismiss();
        }
        onSuccess(body);
      }).catchError((error) {
        if (isLoader) {
          EasyLoading.dismiss();
        }
        onFailure(error);
      }).onError((error, stackTrace) {
        if (isLoader) {
          EasyLoading.dismiss();
        }
        onFailure(error);
      });
    } catch (e) {
      printMessage(e);
    }
  }

  static Future<bool> userExists(
      {required String documentId,
      required String collectionName,
      required String fieldName}) async {
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .where(fieldName, isEqualTo: documentId)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  static Future<void> updateDataWithDocumentId({
    required body,
    required String documentId,
    required String collectionName,
    bool isLoader = false,
    bool isFailedMessage = true,
    required Function(dynamic responseBody) onSuccess,
    required Function onFailure,
  }) async {
    try {
      if (!await isConnectedNetwork()) {
        RequestManager.getSnackToast(
          message: LabelKeys.checkInternet.tr,
        );
        return;
      }
      if (isLoader) {
        RequestManager.showEasyLoader();
      }
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .update(body)
          .then((value) {
        if (isLoader) {
          EasyLoading.dismiss();
        }
        onSuccess(body);
      }).catchError((error) {
        if (isLoader) {
          EasyLoading.dismiss();
        }
        onFailure(error);
      }).onError((error, stackTrace) {
        if (isLoader) {
          EasyLoading.dismiss();
        }
        onFailure(error);
      });
    } catch (e) {
      printMessage(e);
    }
  }

  static void checkIfTripExists({required String tripId}) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection(FireStoreCollection.tripGroupCollection)
        .doc(tripId);
    reference.snapshots().listen((event) {
      if (!event.exists) {
        Future.delayed(Duration.zero, () async {
          Get.offAllNamed(Routes.DASHBOARD);
          //Get.offAll(const BiomatericAuth());
        });
      }
    });
  }

  static void clearFirebaseToken({required String userId}) {
    FirebaseFirestore.instance
        .collection(FireStoreCollection.usersCollection)
        .doc(userId)
        .update({FireStoreParams.fcmToken: ""});
  }
}
