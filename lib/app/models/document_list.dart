/*
class DocumentList{
  bool? isSelected;
  String? time;
  DocumentList({
    required this.isSelected,
    required this.time,
  });
}*/
// To parse this JSON data, do
//
//     final documentList = documentListFromJson(jsonString);

import 'dart:convert';

DocumentList documentListFromJson(String str) =>
    DocumentList.fromJson(json.decode(str));

String documentListToJson(DocumentList data) => json.encode(data.toJson());

class DocumentList {
  int? id;
  int? tripId;
  String? documentName;
  String? document;
  String? uploadedBy;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;
  String? size;
  String? groupDate;
  bool? isSelected = false;

  DocumentList(
      {this.id,
      this.tripId,
      this.documentName,
      this.document,
      this.uploadedBy,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.size,
      this.groupDate,
      this.isSelected = false});

  factory DocumentList.fromJson(Map<String, dynamic> json) => DocumentList(
        id: json["id"],
        tripId: json["trip_id"],
        documentName: json["document_name"],
        document: json["document"],
        uploadedBy: json["uploaded_by"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        image: json["image"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_id": tripId,
        "document_name": documentName,
        "document": document,
        "uploaded_by": uploadedBy,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "image": image,
        "size": size,
      };
}
