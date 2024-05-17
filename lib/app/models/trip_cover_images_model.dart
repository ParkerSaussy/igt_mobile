// To parse this JSON data, do
//
//     final tripCoverImages = tripCoverImagesFromJson(jsonString);

import 'dart:convert';

List<TripCoverImages> tripCoverImagesFromJson(String str) =>
    List<TripCoverImages>.from(
        json.decode(str).map((x) => TripCoverImages.fromJson(x)));

String tripCoverImagesToJson(List<TripCoverImages> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripCoverImages {
  int? id;
  String? imageName;
  dynamic createdAt;
  dynamic updatedAt;
  int? isDeleted;

  TripCoverImages({
    this.id,
    this.imageName,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
  });

  factory TripCoverImages.fromJson(Map<String, dynamic> json) =>
      TripCoverImages(
        id: json["id"],
        imageName: json["image_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_name": imageName,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_deleted": isDeleted,
      };
}
