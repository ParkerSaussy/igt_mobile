// To parse this JSON data, do
//
//     final tripMemoriesModel = tripMemoriesModelFromJson(jsonString);

import 'dart:convert';

List<TripMemoriesModel> tripMemoriesModelFromJson(String str) =>
    List<TripMemoriesModel>.from(
        json.decode(str).map((x) => TripMemoriesModel.fromJson(x)));

String tripMemoriesModelToJson(List<TripMemoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripMemoriesModel {
  int? id;
  int? tripId;
  int? createdBy;
  int? activityName;
  String? caption;
  String? location;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? groupDate;
  bool? isSelected = false;
  GetActivityName? getActivityName;

  TripMemoriesModel({
    this.id,
    this.tripId,
    this.createdBy,
    this.activityName,
    this.caption,
    this.location,
    this.image,
    this.groupDate,
    this.isSelected = false,
    this.createdAt,
    this.updatedAt,
    this.getActivityName,
  });

  factory TripMemoriesModel.fromJson(Map<String, dynamic> json) =>
      TripMemoriesModel(
        id: json["id"],
        tripId: json["trip_id"],
        createdBy: json["created_by"],
        activityName: json["activity_name"],
        caption: json["caption"],
        location: json["location"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        getActivityName: json["get_activity_name"] == null
            ? null
            : GetActivityName.fromJson(json["get_activity_name"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_id": tripId,
        "created_by": createdBy,
        "activity_name": activityName,
        "caption": caption,
        "location": location,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "get_activity_name": getActivityName?.toJson(),
      };
}

class GetActivityName {
  int? id;
  String? name;

  GetActivityName({
    this.id,
    this.name,
  });

  factory GetActivityName.fromJson(Map<String, dynamic> json) =>
      GetActivityName(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
