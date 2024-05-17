// To parse this JSON data, do
//
//     final tripDetailsCityPollModel = tripDetailsCityPollModelFromJson(jsonString);

import 'dart:convert';

List<TripDetailsCityPollModel> tripDetailsCityPollModelFromJson(String str) =>
    List<TripDetailsCityPollModel>.from(
        json.decode(str).map((x) => TripDetailsCityPollModel.fromJson(x)));

String tripDetailsCityPollModelToJson(List<TripDetailsCityPollModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripDetailsCityPollModel {
  int? id;
  int? tripId;
  int? cityId;
  bool? isDeleted;
  DateTime? createdAt;
  List<TripCityPoll>? tripCityPolls;
  CityNameDetails? cityNameDetails;
  int? vipVoted;
  int? totalVip;
  int? totalGuest;
  int? userVoted;
  List<String>? userImage;
  int? totalVoted;

  TripDetailsCityPollModel({
    this.id,
    this.tripId,
    this.cityId,
    this.isDeleted,
    this.createdAt,
    this.tripCityPolls,
    this.cityNameDetails,
    this.vipVoted,
    this.totalVip,
    this.totalGuest,
    this.userVoted,
    this.userImage,
    this.totalVoted,
  });

  factory TripDetailsCityPollModel.fromJson(Map<String, dynamic> json) =>
      TripDetailsCityPollModel(
        id: json["id"],
        tripId: json["trip_id"],
        cityId: json["city_id"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        tripCityPolls: json["trip_city_polls"] == null
            ? []
            : List<TripCityPoll>.from(
                json["trip_city_polls"]!.map((x) => TripCityPoll.fromJson(x))),
        cityNameDetails: json["city_name_details"] == null
            ? null
            : CityNameDetails.fromJson(json["city_name_details"]),
        vipVoted: json["vipVoted"],
        totalVip: json["totalVip"],
        totalGuest: json["totalGuest"],
        userVoted: json["userVoted"],
        userImage: json["userImage"] == null
            ? []
            : List<String>.from(json["userImage"]!.map((x) => x)),
        totalVoted: json["totalVoted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_id": tripId,
        "city_id": cityId,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "trip_city_polls": tripCityPolls == null
            ? []
            : List<dynamic>.from(tripCityPolls!.map((x) => x.toJson())),
        "city_name_details": cityNameDetails?.toJson(),
        "vipVoted": vipVoted,
        "totalVip": totalVip,
        "totalGuest": totalGuest,
        "userVoted": userVoted,
        "userImage": userImage == null
            ? []
            : List<dynamic>.from(userImage!.map((x) => x)),
        "totalVoted": totalVoted,
      };
}

class CityNameDetails {
  int? id;
  String? cityName;
  String? state;
  String? stateAbbr;
  String? countryName;
  String? timeZone;
  int? isDeleted;
  int? isDefault;
  DateTime? createdAt;
  String? timeZoIFlutter4780Ne;

  CityNameDetails({
    this.id,
    this.cityName,
    this.state,
    this.stateAbbr,
    this.countryName,
    this.timeZone,
    this.isDeleted,
    this.isDefault,
    this.createdAt,
    this.timeZoIFlutter4780Ne,
  });

  factory CityNameDetails.fromJson(Map<String, dynamic> json) =>
      CityNameDetails(
        id: json["id"],
        cityName: json["city_name"],
        state: json["state"],
        stateAbbr: json["state_abbr"],
        countryName: json["country_name"],
        timeZone: json["time_zone"],
        isDeleted: json["is_deleted"],
        isDefault: json["is_default"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        timeZoIFlutter4780Ne: json["time_zo I/flutter ( 4780): ne"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "state": state,
        "state_abbr": stateAbbr,
        "country_name": countryName,
        "time_zone": timeZone,
        "is_deleted": isDeleted,
        "is_default": isDefault,
        "created_at": createdAt?.toIso8601String(),
        "time_zo I/flutter ( 4780): ne": timeZoIFlutter4780Ne,
      };
}

class TripCityPoll {
  int? id;
  int? tripCityListId;
  int? guestId;
  bool? isSelected;
  bool? isDeleted;
  DateTime? createdAt;
  GuestDetails? guestDetails;

  TripCityPoll({
    this.id,
    this.tripCityListId,
    this.guestId,
    this.isSelected,
    this.isDeleted,
    this.createdAt,
    this.guestDetails,
  });

  factory TripCityPoll.fromJson(Map<String, dynamic> json) => TripCityPoll(
        id: json["id"],
        tripCityListId: json["trip_city_list_id"],
        guestId: json["guest_id"],
        isSelected: json["is_selected"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        guestDetails: json["guest_details"] == null
            ? null
            : GuestDetails.fromJson(json["guest_details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_city_list_id": tripCityListId,
        "guest_id": guestId,
        "is_selected": isSelected,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "guest_details": guestDetails?.toJson(),
      };
}

class GuestDetails {
  int? id;
  int? tripId;
  String? firstName;
  String? lastName;
  String? emailId;
  String? phoneNumber;
  String? role;
  bool? isCoHost;
  bool? isDeleted;
  int? noOfInviteSend;
  String? inviteStatus;
  int? uId;
  dynamic lastInvitationTime;
  DateTime? createdAt;
  UsersDetailProfileImage? usersDetailProfileImage;

  GuestDetails({
    this.id,
    this.tripId,
    this.firstName,
    this.lastName,
    this.emailId,
    this.phoneNumber,
    this.role,
    this.isCoHost,
    this.isDeleted,
    this.noOfInviteSend,
    this.inviteStatus,
    this.uId,
    this.lastInvitationTime,
    this.createdAt,
    this.usersDetailProfileImage,
  });

  factory GuestDetails.fromJson(Map<String, dynamic> json) => GuestDetails(
        id: json["id"],
        tripId: json["trip_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        emailId: json["email_id"],
        phoneNumber: json["phone_number"],
        role: json["role"],
        isCoHost: json["is_co_host"],
        isDeleted: json["is_deleted"],
        noOfInviteSend: json["no_of_invite_send"],
        inviteStatus: json["invite_status"],
        uId: json["u_id"],
        lastInvitationTime: json["last_invitation_time"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        usersDetailProfileImage: json["users_detail_profile_image"] == null
            ? null
            : UsersDetailProfileImage.fromJson(
                json["users_detail_profile_image"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trip_id": tripId,
        "first_name": firstName,
        "last_name": lastName,
        "email_id": emailId,
        "phone_number": phoneNumber,
        "role": role,
        "is_co_host": isCoHost,
        "is_deleted": isDeleted,
        "no_of_invite_send": noOfInviteSend,
        "invite_status": inviteStatus,
        "u_id": uId,
        "last_invitation_time": lastInvitationTime,
        "created_at": createdAt?.toIso8601String(),
        "users_detail_profile_image": usersDetailProfileImage?.toJson(),
      };
}

class UsersDetailProfileImage {
  int? id;
  String? profileImage;

  UsersDetailProfileImage({
    this.id,
    this.profileImage,
  });

  factory UsersDetailProfileImage.fromJson(Map<String, dynamic> json) =>
      UsersDetailProfileImage(
        id: json["id"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_image": profileImage,
      };
}
