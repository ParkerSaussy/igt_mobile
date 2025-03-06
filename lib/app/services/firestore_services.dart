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
  /// Adds data with document ID to the Firestore collection.
  ///
  /// This method adds the given data to the Firestore collection with the given
  /// document ID. It also handles the loader and snack toast.
  ///
  /// Parameters:
  /// - [body] : The data to be added to the Firestore.
  /// - [documentId] : The document ID to which the data is to be added.
  /// - [collectionName] : The name of the Firestore collection.
  /// - [isLoader] : The flag for showing the loader. Default is false.
  /// - [isFailedMessage] : The flag for showing the failed message. Default is true.
  /// - [onSuccess] : The callback for the success of the Firestore operation.
  /// - [onFailure] : The callback for the failure of the Firestore operation.
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

  /// Checks if the user exists in Firestore.
  ///
  /// This method checks if the user exists in Firestore by querying the
  /// given collection with the given document ID and field name. It returns
  /// a future of boolean indicating whether the user exists or not.
  ///
  /// Parameters:
  /// - [documentId] : The ID of the document to be checked.
  /// - [collectionName] : The name of the Firestore collection.
  /// - [fieldName] : The name of the field to be queried.
  /// Returns:
  /// A Future of boolean indicating whether the user exists or not.
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

  /// Updates a document in Firestore with the given body.
  ///
  /// This method takes the ID of the document to be updated, the name of the
  /// Firestore collection, a boolean indicating whether to show a loader, a
  /// boolean indicating whether to show a failure message, and two functions:
  /// one to be called on success and one to be called on failure.
  ///
  /// If [isLoader] is true, it shows a loader until the update is complete.
  /// If [isFailedMessage] is true, it shows a message if the update fails.
  ///
  /// Parameters:
  /// - [body] : The data to be updated.
  /// - [documentId] : The ID of the document to be updated.
  /// - [collectionName] : The name of the Firestore collection.
  /// - [isLoader] : Whether to show a loader while updating. Defaults to false.
  /// - [isFailedMessage] : Whether to show a message if the update fails. Defaults to true.
  /// - [onSuccess] : A callback function to be called when the update is successful.
  /// - [onFailure] : A callback function to be called when the update fails.
  /// Returns:
  /// A Future of void.
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

  /// Listens to the snapshot of the trip with [tripId] from Firestore,
  /// and if the trip does not exist, navigates to the dashboard screen.
  ///
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

  /// Clears the Firebase token for a user.
  ///
  /// This method updates the user's document in the users collection
  /// in Firestore, setting the Firebase Cloud Messaging (FCM) token
  /// to an empty string. This effectively clears the token, ensuring
  /// that the user will no longer receive push notifications until a
  /// new token is set.
  ///
  /// Parameters:
  /// - [userId] : The ID of the user whose Firebase token is to be cleared.

  static void clearFirebaseToken({required String userId}) {
    FirebaseFirestore.instance
        .collection(FireStoreCollection.usersCollection)
        .doc(userId)
        .update({FireStoreParams.fcmToken: ""});
  }
}
