// To parse this JSON data, do
//
//     final tripDetailsModel = tripDetailsModelFromJson(jsonString);

import 'dart:convert';

TripDetailsModel tripDetailsModelFromJson(String str) =>
    TripDetailsModel.fromJson(json.decode(str));

String tripDetailsModelToJson(TripDetailsModel data) =>
    json.encode(data.toJson());

class TripDetailsModel {
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
  DateTime? previousReminderDate;
  int? isPaid;
  dynamic paidBy;
  dynamic paidOn;
  String? deadlinePassedStatus;
  dynamic paidPlanType;
  String? role;
  int? isCoHost;
  String? inviteStatus;
  int? guestCount;
  HostDetail? hostDetail;
  HostDetail? premiumPlanBy;
  CityNameDetails? cityNameDetails;
  String? dropboxUrl;

  TripDetailsModel({
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
    this.previousReminderDate,
    this.isPaid,
    this.paidBy,
    this.paidOn,
    this.deadlinePassedStatus,
    this.paidPlanType,
    this.role,
    this.isCoHost,
    this.inviteStatus,
    this.guestCount,
    this.hostDetail,
    this.premiumPlanBy,
    this.cityNameDetails,
    this.dropboxUrl,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) =>
      TripDetailsModel(
        id: json["id"],
        tripName: json["trip_name"],
        tripDescription: json["trip_description"],
        itinaryDetails: json["itinary_details"],
        responseDeadline: json["response_deadline"] == null
            ? null
            : DateTime.parse(json["response_deadline"]+"Z"),
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
        previousReminderDate: json["previous_reminder_date"] == null
            ? null
            : DateTime.parse(json["previous_reminder_date"]),
        isPaid: json["is_paid"],
        paidBy: json["paid_by"],
        paidOn: json["paid_on"],
        deadlinePassedStatus: json["deadline_passed_status"],
        paidPlanType: json["paid_plan_type"],
        role: json["role"],
        isCoHost: json["is_co_host"],
        inviteStatus: json["invite_status"],
        guestCount: json["guest_count"],
        dropboxUrl: json["dropbox_url"],
        hostDetail: json["host_detail"] == null
            ? null
            : HostDetail.fromJson(json["host_detail"]),
        premiumPlanBy: json["premium_plan_by"] == null
            ? null
            : HostDetail.fromJson(json["premium_plan_by"]),
        cityNameDetails: json["city_name_details"] == null
            ? null
            : CityNameDetails.fromJson(json["city_name_details"]),
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
        "previous_reminder_date":
            "${previousReminderDate!.year.toString().padLeft(4, '0')}-${previousReminderDate!.month.toString().padLeft(2, '0')}-${previousReminderDate!.day.toString().padLeft(2, '0')}",
        "is_paid": isPaid,
        "paid_by": paidBy,
        "paid_on": paidOn,
        "deadline_passed_status": deadlinePassedStatus,
        "paid_plan_type": paidPlanType,
        "role": role,
        "is_co_host": isCoHost,
        "invite_status": inviteStatus,
        "guest_count": guestCount,
        "host_detail": hostDetail?.toJson(),
        "premium_plan_by": premiumPlanBy?.toJson(),
        "city_name_details": cityNameDetails?.toJson(),
        "dropbox_url": dropboxUrl,
      };
}

class CityNameDetails {
  int? id;
  String? cityName;
  String? countryName;
  String? timeZone;
  int? isDeleted;
  DateTime? createdAt;

  CityNameDetails({
    this.id,
    this.cityName,
    this.countryName,
    this.timeZone,
    this.isDeleted,
    this.createdAt,
  });

  factory CityNameDetails.fromJson(Map<String, dynamic> json) =>
      CityNameDetails(
        id: json["id"],
        cityName: json["city_name"],
        countryName: json["country_name"],
        timeZone: json["time_zone"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "country_name": countryName,
        "time_zone": timeZone,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
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

// To parse this JSON data, do
//
//     final tripDetailsModel = tripDetailsModelFromJson(jsonString);

/*import 'dart:convert';

TripDetailsModel tripDetailsModelFromJson(String str) => TripDetailsModel.fromJson(json.decode(str));

String tripDetailsModelToJson(TripDetailsModel data) => json.encode(data.toJson());

class TripDetailsModel {
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
  DateTime? previousReminderDate;
  int? isPaid;
  int? paidBy;
  DateTime? paidOn;
  String? role;
  int? isCoHost;
  String? inviteStatus;
  int? guestCount;
  HostDetail? hostDetail;
  CityNameDetails? cityNameDetails;

  TripDetailsModel({
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
    this.previousReminderDate,
    this.isPaid,
    this.paidBy,
    this.paidOn,
    this.role,
    this.isCoHost,
    this.inviteStatus,
    this.guestCount,
    this.hostDetail,
    this.cityNameDetails,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) => TripDetailsModel(
    id: json["id"],
    tripName: json["trip_name"],
    tripDescription: json["trip_description"],
    itinaryDetails: json["itinary_details"],
    responseDeadline: json["response_deadline"] == null ? null : DateTime.parse(json["response_deadline"]),
    reminderDays: json["reminder_days"],
    tripImgUrl: json["trip_img_url"],
    createdBy: json["created_by"],
    deletedBy: json["deleted_by"],
    isTripFinalised: json["is_trip_finalised"],
    tripFinalStartDate: json["trip_final_start_date"] == null ? null : DateTime.parse(json["trip_final_start_date"]),
    tripFinalEndDate: json["trip_final_end_date"] == null ? null : DateTime.parse(json["trip_final_end_date"]),
    tripFinalCity: json["trip_final_city"],
    tripFinaledOn: json["trip_finaled_on"] == null ? null : DateTime.parse(json["trip_finaled_on"]),
    isDeleted: json["is_deleted"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    tripFinalizingComment: json["trip_finalizing_comment"],
    updatedBy: json["updated_by"],
    updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
    previousReminderDate: json["previous_reminder_date"] == null ? null : DateTime.parse(json["previous_reminder_date"]),
    isPaid: json["is_paid"],
    paidBy: json["paid_by"],
    paidOn: json["paid_on"] == null ? null : DateTime.parse(json["paid_on"]),
    role: json["role"],
    isCoHost: json["is_co_host"],
    inviteStatus: json["invite_status"],
    guestCount: json["guest_count"],
    hostDetail: json["host_detail"] == null ? null : HostDetail.fromJson(json["host_detail"]),
    cityNameDetails: json["city_name_details"] == null ? null : CityNameDetails.fromJson(json["city_name_details"]),
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
    "previous_reminder_date": "${previousReminderDate!.year.toString().padLeft(4, '0')}-${previousReminderDate!.month.toString().padLeft(2, '0')}-${previousReminderDate!.day.toString().padLeft(2, '0')}",
    "is_paid": isPaid,
    "paid_by": paidBy,
    "paid_on": paidOn?.toIso8601String(),
    "role": role,
    "is_co_host": isCoHost,
    "invite_status": inviteStatus,
    "guest_count": guestCount,
    "host_detail": hostDetail?.toJson(),
    "city_name_details": cityNameDetails?.toJson(),
  };
}

class CityNameDetails {
  int? id;
  String? cityName;
  String? countryName;
  dynamic timeZone;
  int? isDeleted;
  DateTime? createdAt;

  CityNameDetails({
    this.id,
    this.cityName,
    this.countryName,
    this.timeZone,
    this.isDeleted,
    this.createdAt,
  });

  factory CityNameDetails.fromJson(Map<String, dynamic> json) => CityNameDetails(
    id: json["id"],
    cityName: json["city_name"],
    countryName: json["country_name"],
    timeZone: json["time_zone"],
    isDeleted: json["is_deleted"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_name": cityName,
    "country_name": countryName,
    "time_zone": timeZone,
    "is_deleted": isDeleted,
    "created_at": createdAt?.toIso8601String(),
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
}*/
