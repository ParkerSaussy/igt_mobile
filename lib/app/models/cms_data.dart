// To parse this JSON data, do
//
//     final cmdData = cmdDataFromJson(jsonString);

import 'dart:convert';

CmsData cmsDataFromJson(String str) => CmsData.fromJson(json.decode(str));

String cmsDataToJson(CmsData data) => json.encode(data.toJson());

class CmsData {
  int id;
  String type;
  String description;
  dynamic createdAt;
  dynamic updatedAt;

  CmsData({
    required this.id,
    required this.type,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory CmsData.fromJson(Map<String, dynamic> json) => CmsData(
        id: json["id"],
        type: json["type"],
        description: json["description"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
