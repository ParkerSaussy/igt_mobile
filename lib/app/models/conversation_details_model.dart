import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationListModel {
  String? tripId;
  Timestamp? timestamp;
  String? senderId;
  List<dynamic>? memberIds;
  GroupDataModel? groupData;
  String? fileType;
  String? fileName;

  ConversationListModel({
    this.tripId,
    this.timestamp,
    this.senderId,
    this.memberIds,
    this.groupData,
    this.fileType,
    this.fileName,
  });

  ConversationListModel.fromJson(Map<String, dynamic> json) {
    tripId = json['tripId'];
    timestamp = json['timestamp'];
    senderId = json['senderId'];
    memberIds = json['memberIds'];
    groupData = json['groupData'] != null
        ? GroupDataModel.fromJson(json['groupData'])
        : null;
    fileType = json['fileType'];
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tripId'] = tripId;
    data['timestamp'] = timestamp;
    data['senderId'] = senderId;
    data['memberIds'] = memberIds;
    data['groupData'] = groupData!.toJson() as GroupDataModel?;
    data['fileType'] = fileType;
    data['fileName'] = fileName;
    return data;
  }
}

class GroupDataModel {
  String groupAdmin;
  Timestamp groupCreatedAt;
  String groupImage;
  String groupName;

  GroupDataModel({
    required this.groupAdmin,
    required this.groupCreatedAt,
    required this.groupImage,
    required this.groupName,
  });

  factory GroupDataModel.fromJson(Map<dynamic, dynamic> json) => GroupDataModel(
        groupAdmin: json['groupAdmin'],
        groupCreatedAt: json['groupCreatedAt'],
        groupImage: json['groupImage'],
        groupName: json['groupName'],
      );

  Map<String, dynamic> toJson() => {
        "groupAdmin": groupAdmin,
        "groupCreatedAt": groupCreatedAt,
        "groupImage": groupImage,
        "groupName": groupName,
      };
}
