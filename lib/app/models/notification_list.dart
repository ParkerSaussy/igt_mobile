/*
class NotificationList{
  bool? isSelected;
  String? time;
  String? title;
  String? desc;
  String? img;
  NotificationList({
    required this.isSelected,
    required this.time,
    required this.title,
    required this.desc,
    required this.img,
  });
}*/
// To parse this JSON data, do
//
//     final notificationList = notificationListFromJson(jsonString);

import 'dart:convert';

NotificationList notificationListFromJson(String str) =>
    NotificationList.fromJson(json.decode(str));

String notificationListToJson(NotificationList data) =>
    json.encode(data.toJson());

class NotificationList {
  int? id;
  String? type;
  int? senderId;
  int? reciverId;
  String? title;
  Payload? payload;
  int? isRead;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? message;
  String? groupDate;
  bool? isSelected = false;

  NotificationList(
      {this.id,
      this.type,
      this.senderId,
      this.reciverId,
      this.title,
      this.payload,
      this.isRead,
      this.createdAt,
      this.updatedAt,
      this.message,
      this.groupDate,
      this.isSelected = false});

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(
        id: json["id"],
        type: json["type"],
        senderId: json["sender_id"],
        reciverId: json["reciver_id"],
        title: json["title"],
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
        isRead: json["is_read"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "sender_id": senderId,
        "reciver_id": reciverId,
        "title": title,
        "payload": payload?.toJson(),
        "is_read": isRead,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "message": message,
      };
}

class Payload {
  String? key1;
  String? key2;

  Payload({
    this.key1,
    this.key2,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        key1: json["key1"],
        key2: json["key2"],
      );

  Map<String, dynamic> toJson() => {
        "key1": key1,
        "key2": key2,
      };
}
