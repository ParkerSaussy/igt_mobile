// To parse this JSON data, do
//
//     final tripListModel = tripListModelFromJson(jsonString);

import 'dart:convert';

TripListModel tripListModelFromJson(String str) =>
    TripListModel.fromJson(json.decode(str));

String tripListModelToJson(TripListModel data) => json.encode(data.toJson());

class TripListModel {
  int? id;
  String? tripName;
  String? tripDescription;
  String? itinaryDetails;
  DateTime? responseDeadline;
  int? reminderDays;
  String? tripImgUrl;
  int? createdBy;
  int? deletedBy;
  bool? isTripFinalised;
  DateTime? tripFinalStartDate;
  DateTime? tripFinalEndDate;
  String? tripFinalCity;
  DateTime? tripFinaledOn;
  bool? isDeleted;
  DateTime? createdAt;
  String? tripFinalizingComment;
  int? updatedBy;
  DateTime? updatedOn;
  String? role;
  int? isCoHost;
  CityNameDetails? cityNameDetails;
  HostDetail? hostDetail;

  TripListModel({
    this.id,
    this.tripName,
    this.tripDescription,
    this.itinaryDetails,
    this.responseDeadline,
    this.reminderDays,
    this.tripImgUrl,
    this.createdBy,
    this.deletedBy,
    this.isTripFinalised,
    this.tripFinalStartDate,
    this.tripFinalEndDate,
    this.tripFinalCity,
    this.tripFinaledOn,
    this.isDeleted,
    this.createdAt,
    this.tripFinalizingComment,
    this.updatedBy,
    this.updatedOn,
    this.role,
    this.isCoHost,
    this.cityNameDetails,
    this.hostDetail,
  });

  factory TripListModel.fromJson(Map<String, dynamic> json) => TripListModel(
        id: json["id"],
        tripName: json["trip_name"],
        tripDescription: json["trip_description"],
        itinaryDetails: json["itinary_details"],
        responseDeadline: json["response_deadline"] == null
            ? null
            : DateTime.parse(json["response_deadline"]),
        reminderDays: json["reminder_days"],
        tripImgUrl: json["trip_img_url"],
        createdBy: json["created_by"],
        deletedBy: json["deleted_by"],
        isTripFinalised: json["is_trip_finalised"],
        tripFinalStartDate: json["trip_final_start_date"] == null
            ? null
            : DateTime.parse(json["trip_final_start_date"]),
        tripFinalEndDate: json["trip_final_end_date"] == null
            ? null
            : DateTime.parse(json["trip_final_end_date"]),
        tripFinalCity: json["trip_final_city"],
        tripFinaledOn: json["trip_finaled_on"] == null
            ? null
            : DateTime.parse(json["trip_finaled_on"]),
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        tripFinalizingComment: json["trip_finalizing_comment"],
        updatedBy: json["updated_by"],
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
        role: json["role"],
        isCoHost: json["is_co_host"],
        cityNameDetails: json["city_name_details"] == null
            ? null
            : CityNameDetails.fromJson(json["city_name_details"]),
        hostDetail: json["host_detail"] == null
            ? null
            : HostDetail.fromJson(json["host_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_name": tripName,
        "trip_description": tripDescription,
        "itinary_details": itinaryDetails,
        "response_deadline": responseDeadline?.toIso8601String(),
        "reminder_days": reminderDays,
        "trip_img_url": tripImgUrl,
        "created_by": createdBy,
        "deleted_by": deletedBy,
        "is_trip_finalised": isTripFinalised,
        "trip_final_start_date": tripFinalStartDate?.toIso8601String(),
        "trip_final_end_date": tripFinalEndDate?.toIso8601String(),
        "trip_final_city": tripFinalCity,
        "trip_finaled_on": tripFinaledOn?.toIso8601String(),
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "trip_finalizing_comment": tripFinalizingComment,
        "updated_by": updatedBy,
        "updated_on": updatedOn?.toIso8601String(),
        "role": role,
        "is_co_host": isCoHost,
        "city_name_details": cityNameDetails?.toJson(),
        "host_detail": hostDetail?.toJson(),
      };
}

class CityNameDetails {
  int? id;
  String? cityName;
  String? countryName;
  String? timeZone;

  CityNameDetails({
    this.id,
    this.cityName,
    this.countryName,
    this.timeZone,
  });

  factory CityNameDetails.fromJson(Map<String, dynamic> json) =>
      CityNameDetails(
        id: json["id"],
        cityName: json["city_name"],
        countryName: json["country_name"],
        timeZone: json["time_zone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "country_name": countryName,
        "time_zone": timeZone,
      };
}

class HostDetail {
  int? id;
  String? firstName;
  String? lastName;
  String? profileImage;

  HostDetail({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImage,
  });

  factory HostDetail.fromJson(Map<String, dynamic> json) => HostDetail(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "profile_image": profileImage,
      };
}
