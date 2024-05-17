// To parse this JSON data, do
//
//     final tripMemoryActivityListModel = tripMemoryActivityListModelFromJson(jsonString);

import 'dart:convert';

TripMemoryActivityListModel tripMemoryActivityListModelFromJson(String str) =>
    TripMemoryActivityListModel.fromJson(json.decode(str));

String tripMemoryActivityListModelToJson(TripMemoryActivityListModel data) =>
    json.encode(data.toJson());

class TripMemoryActivityListModel {
  int? id;
  String? name;

  TripMemoryActivityListModel({
    this.id,
    this.name,
  });

  factory TripMemoryActivityListModel.fromJson(Map<String, dynamic> json) =>
      TripMemoryActivityListModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
