import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lesgo/app/models/conversation_details_model.dart';
import 'package:lesgo/app/models/message_model.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../master/general_utils/date.dart';
import '../../../master/general_utils/label_key.dart';
import '../../../master/generic_class/image_picker.dart';
import '../../services/fcm_service.dart';

class ChatDetailsScreenController extends GetxController {
  final count = 0.obs;
  TextEditingController txtMessageController = TextEditingController();
  FocusNode? messageFocus;
  ScrollController scrollController = ScrollController();
  RxList<MessageModel> lstMessage = <MessageModel>[].obs;
  RxList<MessageModel> lstSelecetdMessages = <MessageModel>[].obs;
  RxBool isSelectedMessage = false.obs;
  int? tripId;
  String conversationId = '';
  RxString isGroup = ''.obs;
  RxBool isDetailsFetched = false.obs;
  ConversationListModel? conversationListModel;
  RxString restorationId = "".obs;
  int? selectedIndex;
  bool isLongPressEnables = false;
  RxBool showEmojiPicker = false.obs;
  List<String> lstFcmToken = [];
  String senderName = '';
  String? receiverId;
  DocumentSnapshot? receiverDetails;
  List<File> localImagePathList = [];
  List<XFile> localImagePathListTemp = [];

  @override
  void onInit() {
    super.onInit();
    /*Future.delayed(const Duration(milliseconds: 1200), () {
      Preference.isSetNotification(false);
    },);*/
    isGroup.value = Get.arguments[1];
    if (isGroup.value == ChatType.singleChat) {
      conversationId = Get.arguments[0];
      getFcmTokenForSingleChat();
      isDetailsFetched.value = false;
    } else {
      tripId = Get.arguments[0];
      gc.chatTripId.value = tripId.toString();
      printMessage("gc.chatTripId.value: ${gc.chatTripId.value}");
      FireStoreServices.checkIfTripExists(tripId: tripId.toString());
      getGroupDetails();
    }
  }

  /// Gets the details of the group chat.
  ///
  /// This method fetches the details of the group chat from Firestore and
  /// stores it in the [conversationListModel] variable. It also fetches the
  /// FCM tokens of the group members and stores them in the [lstFcmToken]
  /// variable.
  void getGroupDetails() {
    RequestManager.showEasyLoader();
    FirebaseFirestore.instance
        .collection(FireStoreCollection.tripGroupCollection)
        .doc(tripId.toString())
        .get()
        .then((value) {
      if (value.exists) {
        final data = value.data()!;
        var conversationModel =
            ConversationListModel.fromJson(Map<String, dynamic>.from(data));
        conversationListModel = conversationModel;
        isDetailsFetched.value = true;
        getFcmTokens();
      }
    });
  }

  /// Fetches the FCM tokens of the group members and stores them in the
  /// [lstFcmToken] variable.
  ///
  /// This method loops through the member IDs of the group chat stored in the
  /// [conversationListModel] and fetches the details of each member. It then
  /// checks if the fetched user ID is different from the current user ID. If
  /// yes, it adds the FCM token to the [lstFcmToken] variable. If the user ID
  /// matches the current user ID, it updates the [senderName] with the full
  /// name of the current user.
  void getFcmTokens() {
    for (int i = 0; i < conversationListModel!.memberIds!.length; i++) {
      FirebaseFirestore.instance
          .collection(FireStoreCollection.usersCollection)
          .doc(conversationListModel!.memberIds![i])
          .get()
          .then((value) {
        if (value.get('userId') != gc.loginData.value.id.toString()) {
          if (value.get('fcmToken') != '') {
            lstFcmToken.add(value.get('fcmToken'));
          }
        }

        if (value.get('userId') == gc.loginData.value.id.toString()) {
          senderName = "${value.get('firstName')} ${value.get('lastName')}";
        }
      }).then((value) {
        EasyLoading.dismiss();
      });
    }
  }

  /// Fetches the FCM token of the receiver in single chat.
  ///
  /// This method fetches the FCM token of the receiver in single chat and
  /// stores it in the [lstFcmToken] variable. It also fetches the details of
  /// the receiver and stores them in the [receiverDetails] variable. Finally,
  /// it sets the [isDetailsFetched] variable to true.
  void getFcmTokenForSingleChat() {
    RequestManager.showEasyLoader();
    FirebaseFirestore.instance
        .collection(FireStoreCollection.tripGroupCollection)
        .doc(conversationId)
        .get()
        .then((value) {
      for (int i = 0; i < value.get('memberIds').length; i++) {
        if (value.get('memberIds')[i] != gc.loginData.value.id.toString()) {
          receiverId = value.get('memberIds')[i];
        }
      }
    }).then((value) {
      FirebaseFirestore.instance
          .collection(FireStoreCollection.usersCollection)
          .doc(receiverId)
          .get()
          .then((value) {
        if (value.exists) {
          if (value.get('fcmToken') != '') {
            lstFcmToken.add(value.get('fcmToken'));
          }
          receiverDetails = value;
          isDetailsFetched.value = true;
        }
      });
      EasyLoading.dismiss();
    });
  }

  /// Sends a message in a group chat.
  ///
  /// This method handles sending a message in a group chat by updating the
  /// Firestore `tripGroupCollection` with the message details, such as
  /// message content, sender ID, timestamp, file name, and file type. After
  /// updating the group collection, it calls `createMessageCollection` to
  /// add the message to the message collection with the appropriate details,
  /// including handling different message types (e.g., text or image).
  ///
  /// Parameters:
  /// - [messageType]: An integer representing the type of the message (0 for text, 1 for image).
  /// - [fileName]: The name of the file associated with the message, if any.
  /// - [fileType]: The type of the file associated with the message, if any.
  /// - [imageUrl]: The URL of the image if the message is of type image.

  void sendMessageGroupMessage(
      int messageType, String fileName, String fileType, String imageUrl) {
    print("sdfjhbs");
    final sendDateTime = FieldValue.serverTimestamp();
    final message = txtMessageController.text;
    txtMessageController.clear();
    FirebaseFirestore.instance
        .collection(FireStoreCollection.tripGroupCollection)
        .doc(tripId.toString())
        .update({
      FireStoreParams.message: message,
      FireStoreParams.senderId: gc.loginData.value.id.toString(),
      FireStoreParams.timestamp: sendDateTime,
      FireStoreParams.fileName: fileName,
      FireStoreParams.fileType: fileType,
    }).then((value) {
      createMessageCollection(
          sendDateTime: sendDateTime,
          message: messageType == 0 ? message : imageUrl,
          fileName: fileName,
          fileType: fileType,
          messageType: messageType,
          docId: tripId.toString());
    });
  }

  /// Sends a message in a single chat.
  ///
  /// This method handles sending a message in a single chat by updating the
  /// Firestore `tripGroupCollection` with the message details, such as
  /// message content, sender ID, timestamp, file name, and file type. After
  /// updating the group collection, it calls `createMessageCollection` to
  /// add the message to the message collection with the appropriate details,
  /// including handling different message types (e.g., text or image).
  ///
  /// Parameters:
  /// - [messageType]: An integer representing the type of the message (0 for text, 1 for image).
  /// - [fileName]: The name of the file associated with the message, if any.
  /// - [fileType]: The type of the file associated with the message, if any.
  /// - [imageUrl]: The URL of the image if the message is of type image.
  void sendMessageForSingleChat(
      int messageType, String fileName, String fileType, String imageUrl) {
    final sendDateTime = FieldValue.serverTimestamp();
    final message = txtMessageController.text;
    txtMessageController.clear();
    FirebaseFirestore.instance
        .collection(FireStoreCollection.tripGroupCollection)
        .doc(conversationId.toString())
        .update({
      FireStoreParams.message: message,
      FireStoreParams.senderId: gc.loginData.value.id.toString(),
      FireStoreParams.timestamp: sendDateTime,
      FireStoreParams.fileName: fileName,
      FireStoreParams.fileType: fileType,
    }).then((value) {
      createMessageCollection(
          sendDateTime: sendDateTime,
          message: messageType == 0 ? message : imageUrl,
          fileName: fileName,
          fileType: fileType,
          messageType: messageType,
          docId: conversationId.toString());
    });
  }

  /// Creates a message collection in Firestore for a single chat.
  ///
  /// This method adds a document to the `tripMessages` subcollection of the
  /// `tripGroupCollection` document with the given [docId]. The document
  /// contains the message details, such as the message content, sender ID,
  /// timestamp, file name, and file type. The method also handles different
  /// message types (e.g., text or image). After adding the document, it updates
  /// the document with the generated ID and clears the text message controller.
  /// If the message is of type text, it also scrolls to the bottom of the message
  /// list. If there are FCM tokens for the group, it sends a push notification.
  ///
  /// Parameters:
  /// - [sendDateTime]: The timestamp of when the message was sent.
  /// - [message]: The content of the message.
  /// - [messageType]: An integer representing the type of the message (0 for text, 1 for image).
  /// - [fileName]: The name of the file associated with the message, if any.
  /// - [fileType]: The type of the file associated with the message, if any.
  /// - [docId]: The ID of the document in the `tripGroupCollection` to add the
  ///   message collection to.
  void createMessageCollection(
      {required FieldValue sendDateTime,
      required String message,
      required int messageType,
      required String fileName,
      required String fileType,
      required String docId}) {
    dynamic body;
    if (messageType == 0) {
      body = {
        FireStoreParams.messageType: messageType,
        FireStoreParams.tripId: tripId,
        FireStoreParams.message: message,
        FireStoreParams.senderId: gc.loginData.value.id.toString(),
        FireStoreParams.timestamp: sendDateTime,
        FireStoreParams.fileType: fileType,
        FireStoreParams.fileName: fileName,
        FireStoreParams.replyOfId: "",
        FireStoreParams.isSelected: false,
      };
    } else {
      body = {
        FireStoreParams.messageType: messageType,
        FireStoreParams.tripId: tripId,
        FireStoreParams.message: message,
        FireStoreParams.senderId: gc.loginData.value.id.toString(),
        FireStoreParams.timestamp: sendDateTime,
        FireStoreParams.fileType: fileName,
        FireStoreParams.fileName: fileType,
        FireStoreParams.replyOfId: "",
        FireStoreParams.isSelected: false,
      };
    }
    CollectionReference messagesRef = FirebaseFirestore.instance
        .collection(FireStoreCollection.tripGroupCollection)
        .doc(docId)
        .collection(FireStoreCollection.tripMessages);
    messagesRef.add(body).then((value) {
      messagesRef.doc(value.id).update({FireStoreParams.messageId: value.id});
      txtMessageController.clear();
      if (messageType == 0) {
        scrollToBottom();
      }

      if (lstFcmToken.isNotEmpty) {
        sendPushNotification(message, messageType);
      }
    });
  }

  /// Scrolls the message list to the bottom.
  ///
  /// This method is called after a message is added to the message list, and
  /// it is only called if the message type is text. It uses the
  /// `addPostFrameCallback` method of the `SchedulerBinding` to animate the
  /// scroll to the bottom of the list after the frame has been built. This
  /// allows the list to be scrolled to the bottom even if the list is not yet
  /// at its final size.
  void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn);
    });
  }

  /// Uploads a chat image to the server.
  ///
  /// This method takes a [File] and uses `RequestManager.uploadImage` to upload
  /// it to the server. After the image is uploaded, it sends a message to the
  /// chat with the image URL, either to a single chat or a group chat, depending
  /// on the value of `isGroup`.
  void uploadChatImage(File file) {
    RequestManager.uploadImage(
      isLoader: true,
      hasBearer: true,
      isSuccessMessage: false,
      uri: EndPoints.uploadImage,
      parameters: {RequestParams.type: "chat"},
      file: file,
      onSuccess: (responseBody) {
        String imageURL = responseBody['data']["image"];
        final fileName = getFileNameFromURL(imageURL);
        final fileType = getFileExtension(fileName);
        if (isGroup.value == ChatType.singleChat) {
          sendMessageForSingleChat(1, fileName, fileType!, imageURL);
        } else {
          sendMessageGroupMessage(1, fileName, fileType!, imageURL);
        }
        printMessage("tempFile $imageURL");
      },
      onFailure: (error) {
        printMessage("error: $error");
      },
      onConnectionFailed: (message) {
        printMessage("message: $message");
      },
      fileName: RequestParams.image,
    );
  }

  /// Adds a memory to the server.
  ///
  /// This method takes a [List] of [File]s and uses `RequestManager.uploadImage` to
  /// upload each one to the server. After each image is uploaded, it sends a message
  /// to the chat with the image URL, either to a single chat or a group chat,
  /// depending on the value of `isGroup`. If the upload is successful, it calls
  /// `scrollToBottom` to scroll to the bottom of the chat list, and clears the
  /// temporary list of images. If the upload fails, it shows a snack toast with
  /// the error message.
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
            RequestParams.tripId: tripId.toString(),
            RequestParams.caption: Date.shared().getCurrentDateFormatted(),
            RequestParams.location: "From Chat",
            RequestParams.activityName: '0',
          },
          file: selectedImage,
          fileName: RequestParams.image,
          onSuccess: (response) {
            printMessage(response);
            String imageURL = response['data']["image"];
            final fileName = getFileNameFromURL(imageURL);
            final fileType = getFileExtension(fileName);
            if (isGroup.value == ChatType.singleChat) {
              sendMessageForSingleChat(1, fileName, fileType!, imageURL);
            } else {
              sendMessageGroupMessage(1, fileName, fileType!, imageURL);
            }
            counter++;
            if (counter == localImagePathList.length) {
              //Get.back();
              printMessage('********* Counter: $counter *****************');
              scrollToBottom();
              localImagePathListTemp.clear();
              localImagePathList.clear();
              EasyLoading.dismiss();
            }
          },
          onFailure: (error) {
            counter++;
            if (counter == localImagePathList.length) {
              // Get.back();
              printMessage('********* Counter: $counter *****************');
              scrollToBottom();
              localImagePathListTemp.clear();
              localImagePathList.clear();
              EasyLoading.dismiss();
            }
            printMessage("error: $error");
          },
          onConnectionFailed: (message) {
            counter++;
            if (counter == localImagePathList.length) {
              // Get.back();
              printMessage('********* Counter: $counter *****************');
              scrollToBottom();
              localImagePathListTemp.clear();
              localImagePathList.clear();
              EasyLoading.dismiss();
            }
            printMessage("message: $message");
          },
        );
      }
    }
  }

  /// Send a push notification to the users in the [lstFcmToken] list.
  ///
  /// This function is used to send a push notification to the users in the
  /// [lstFcmToken] list. It takes two parameters, [message] and [messageType].
  /// The [message] parameter is the message to be sent and the [messageType]
  /// parameter is the type of message. If the [messageType] is 0, the message
  /// is a text message. If the [messageType] is 1, the message is an image.
  ///
  /// The function first checks if the [lstFcmToken] list is not empty. If it
  /// is not empty, it constructs the body of the notification. If the chat type
  /// is single chat, the body of the notification is constructed with the
  /// registration ids of the users in the [lstFcmToken] list and the data
  /// of the notification is set to {"type": 'singleChat', 'conversationId':
  /// [conversationId]}. If the chat type is group chat, the body of the
  /// notification is constructed with the registration ids of the users in the
  /// [lstFcmToken] list and the data of the notification is set to
  /// {"type": 'groupChat', 'tripId': [tripId]}.
  ///
  /// The function then sends the notification to the users in the
  /// [lstFcmToken] list using the [http] package. The function then checks
  /// the status code of the response. If the status code is 200, the function
  /// prints a success message. If the status code is not 200, the function
  /// prints an error message.
  Future<void> sendPushNotification(message, messageType) async {
    printMessage("Send Push No : ${lstFcmToken.length}");
    if (lstFcmToken.isNotEmpty) {
      Map<String, Object> body;
      try {
        if (isGroup.value == ChatType.singleChat) {
          body = {
            "registration_ids": lstFcmToken,
            "notification": {
              "title":
                  "New message Received ${gc.loginData.value.firstName} ${gc.loginData.value.lastName}",
              "body": messageType == 0
                  ? "$message"
                  : "${gc.loginData.value.firstName ?? ""} ${gc.loginData.value.lastName ?? ""} sent an image",
              "sound": "default",
            },
            "data": {"type": 'singleChat', 'conversationId': conversationId}
          };
        } else {
          body = {
            "registration_ids": lstFcmToken,
            "notification": {
              "title": conversationListModel!.groupData!.groupName,
              "body": messageType == 0
                  ? "$message"
                  : "${gc.loginData.value.firstName ?? ""} ${gc.loginData.value.lastName ?? ""} sent an image",
              "sound": "default",
            },
            "data": {"type": 'groupChat', 'tripId': tripId}
          };
        }
        printMessage("Notificaton Body $body");
        var url1 = 'https://fcm.googleapis.com/fcm/send';
        var response1 = await http.post(Uri.parse(url1),
            headers: {
              "Authorization": "key= ${FcmService.serverKey}",
              "Content-Type": "application/json"
            },
            body: json.encode(body));
        if (response1.statusCode == 200) {
          printMessage("Success");
          //Map<String, dynamic> map = json.decode(response1.body);
        } else {
          Map<String, dynamic> error = jsonDecode(response1.body);
          printMessage("fcm.google: $error");
        }
      } catch (e) {
        printMessage("fcm.google: $e");
      }
    }
  }
}
