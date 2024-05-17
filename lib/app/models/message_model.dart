/*
class MessageModel{
  String conversationId;
  String message;
  String messageId;
  int messageType;
  String senderId;
  String timestamp;
  String fileName;
  String fileType;
  MessageModel({
    required this.conversationId,
    required this.message,
    required this.messageId,
    required this.messageType,
    required this.senderId,
    required this.timestamp,
    required this.fileName,
    required this.fileType,
  });

}*/

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageListModel {
  late List<MessageModel> conversationList;

  MessageListModel({required this.conversationList});

  MessageListModel.fromJson(dynamic json) {
    conversationList = [];

    List<dynamic> jsonList = json;
    for (var msgInfo in jsonList) {
      conversationList.add(MessageModel.fromJson(msgInfo));
    }
  }
}

class MessageModel {
  int? tripId;
  String? message;
  String? messageId;
  int? messageType;
  String? senderId;
  Timestamp? timestamp;
  String? fileName;
  String? fileType;
  String? replyOfId;
  String? groupedDate;
  bool? isSelected;

  MessageModel({
    this.tripId,
    this.message,
    this.messageId,
    this.messageType,
    this.senderId,
    this.timestamp,
    this.fileName,
    this.fileType,
    this.replyOfId,
    this.groupedDate,
    this.isSelected,
  });

  MessageModel.fromJson(DocumentSnapshot json) {
    Map<String, dynamic> data = json.data() as Map<String, dynamic>;

    tripId = data["tripId"];
    message = data["message"];
    messageId = data["messageId"];
    messageType = data["messageType"];
    senderId = data["senderId"];
    timestamp = data["timestamp"];
    fileName = data["fileName"];
    fileType = data["fileType"];
    replyOfId = data["replyOfId"];
    groupedDate = data["groupedDate"];
    isSelected = data["isSelected"];
  }

  MessageModel.fromPayload(Map<String, dynamic> data) {
    tripId = data["tripId"];
    message = data["message"];
    messageId = data["messageId"];
    messageType = data["messageType"];
    senderId = data["senderId"];
    timestamp = data["timestamp"];
    fileName = data["fileName"];
    fileType = data["fileType"];
    replyOfId = data["replyOfId"];
    groupedDate = data["groupedDate"];
    isSelected = data["isSelected"];
  }
}
