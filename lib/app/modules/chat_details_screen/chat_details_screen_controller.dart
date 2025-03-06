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

  void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn);
    });
  }

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
