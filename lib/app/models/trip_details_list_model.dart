// To parse this JSON data, do
//
//     final TripDetailListModel = tripDetailListModelFromJson(jsonString);

import 'dart:convert';

List<TripDetailListModel> tripDetailListModelFromJson(String str) =>
    List<TripDetailListModel>.from(
        json.decode(str).map((x) => TripDetailListModel.fromJson(x)));

String scheduledEventsListModelToJson(List<TripDetailListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripDetailListModel {
  TripDetailListModel({
    this.eventId,
    this.eventName,
    this.djId,
    this.djName,
    this.djProfileImage,
    this.eventPrice,
    this.eventCategory,
    this.eventSeats,
    this.totalSeats,
    this.eventSongPrice,
    this.eventAdsPrice,
    this.eventStartDate,
    this.eventEndDate,
    this.eventUtcStartDate,
    this.eventUtcEndDate,
    this.eventStreet,
    this.eventLatitude,
    this.eventLongitude,
    this.status,
    this.eventPhotos,
    this.isActive,
    this.isDelete,
    this.eventLikeCount,
    this.eventFavCount,
    this.isLike,
    this.isFav,
  });

  int? eventId;
  String? eventName;
  String? djId;
  String? djName;
  String? djProfileImage;
  String? eventPrice;
  String? eventCategory;
  String? eventSeats;
  String? totalSeats;
  String? eventSongPrice;
  String? eventAdsPrice;
  DateTime? eventStartDate;
  DateTime? eventEndDate;
  DateTime? eventUtcStartDate;
  DateTime? eventUtcEndDate;
  String? eventStreet;
  String? eventLatitude;
  String? eventLongitude;
  String? status;
  List<EventPhoto>? eventPhotos;
  bool? isActive;
  bool? isDelete;
  int? eventLikeCount;
  int? eventFavCount;
  bool? isLike;
  bool? isFav;

  factory TripDetailListModel.fromJson(Map<String, dynamic> json) =>
      TripDetailListModel(
        eventId: json["eventId"],
        eventName: json["eventName"],
        djId: json["djId"],
        djName: json["djName"],
        djProfileImage: json["djProfileImage"],
        eventPrice: json["eventPrice"],
        eventCategory: json["eventCategory"],
        eventSeats: json["eventSeats"],
        totalSeats: json["totalSeats"],
        eventSongPrice: json["eventSongPrice"],
        eventAdsPrice: json["eventAdsPrice"],
        eventStartDate: DateTime.parse(json["eventStartDate"]),
        eventEndDate: DateTime.parse(json["eventEndDate"]),
        eventUtcStartDate: DateTime.parse(json["eventUtcStartDate"]),
        eventUtcEndDate: DateTime.parse(json["eventUtcEndDate"]),
        eventStreet: json["eventStreet"],
        eventLatitude: json["eventLatitude"],
        eventLongitude: json["eventLongitude"],
        status: json["status"],
        eventPhotos: List<EventPhoto>.from(
            json["eventPhotos"].map((x) => EventPhoto.fromJson(x))),
        isActive: json["is_active"],
        isDelete: json["is_delete"],
        eventLikeCount: json["eventLikeCount"],
        eventFavCount: json["eventFavCount"],
        isLike: json["isLike"],
        isFav: json["isFav"],
      );

  Map<String, dynamic> toJson() => {
        "eventId": eventId,
        "eventName": eventName,
        "djId": djId,
        "djName": djName,
        "djProfileImage": djProfileImage,
        "eventPrice": eventPrice,
        "eventCategory": eventCategory,
        "eventSeats": eventSeats,
        "totalSeats": totalSeats,
        "eventSongPrice": eventSongPrice,
        "eventAdsPrice": eventAdsPrice,
        "eventStartDate": eventStartDate?.toIso8601String(),
        "eventEndDate": eventEndDate?.toIso8601String(),
        "eventUtcStartDate": eventUtcStartDate?.toIso8601String(),
        "eventUtcEndDate": eventUtcEndDate?.toIso8601String(),
        "eventStreet": eventStreet,
        "eventLatitude": eventLatitude,
        "eventLongitude": eventLongitude,
        "status": status,
        "eventPhotos": List<dynamic>.from(eventPhotos!.map((x) => x.toJson())),
        "is_active": isActive,
        "is_delete": isDelete,
        "eventLikeCount": eventLikeCount,
        "eventFavCount": eventFavCount,
        "isLike": isLike,
        "isFav": isFav,
      };
}

class EventPhoto {
  EventPhoto({
    this.eventPhotos,
  });

  String? eventPhotos;

  factory EventPhoto.fromJson(Map<String, dynamic> json) => EventPhoto(
        eventPhotos: json["eventPhotos"],
      );

  Map<String, dynamic> toJson() => {
        "eventPhotos": eventPhotos,
      };
}
