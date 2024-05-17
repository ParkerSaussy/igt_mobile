// To parse this JSON data, do
//
//     final tripDetailsDatePollModel = tripDetailsDatePollModelFromJson(jsonString);

import 'dart:convert';

List<TripDetailsDatePollModel> tripDetailsDatePollModelFromJson(String str) =>
    List<TripDetailsDatePollModel>.from(
        json.decode(str).map((x) => TripDetailsDatePollModel.fromJson(x)));

String tripDetailsDatePollModelToJson(List<TripDetailsDatePollModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripDetailsDatePollModel {
  int? id;
  int? tripId;
  DateTime? startDate;
  DateTime? endDate;
  String? comment;
  bool? isDeleted;
  int? isDefault;
  DateTime? createdAt;
  List<TripDatePoll>? tripDatePolls;
  int? vipVoted;
  int? totalVip;
  int? totalGuest;
  int? userVoted;
  List<String>? userImage;
  int? totalVoted;

  TripDetailsDatePollModel({
    this.id,
    this.tripId,
    this.startDate,
    this.endDate,
    this.comment,
    this.isDeleted,
    this.isDefault,
    this.createdAt,
    this.tripDatePolls,
    this.vipVoted,
    this.totalVip,
    this.totalGuest,
    this.userVoted,
    this.userImage,
    this.totalVoted,
  });

  factory TripDetailsDatePollModel.fromJson(Map<String, dynamic> json) =>
      TripDetailsDatePollModel(
        id: json["id"],
        tripId: json["trip_id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]+"Z"),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]+"Z"),
        comment: json["comment"],
        isDeleted: json["is_deleted"],
        isDefault: json["is_default"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        tripDatePolls: json["trip_date_polls"] == null
            ? []
            : List<TripDatePoll>.from(
                json["trip_date_polls"]!.map((x) => TripDatePoll.fromJson(x))),
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
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "comment": comment,
        "is_deleted": isDeleted,
        "is_default": isDefault,
        "created_at": createdAt?.toIso8601String(),
        "trip_date_polls": tripDatePolls == null
            ? []
            : List<dynamic>.from(tripDatePolls!.map((x) => x.toJson())),
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

class TripDatePoll {
  int? id;
  int? tripDatesListId;
  int? guestId;
  bool? isSelected;
  bool? isDeleted;
  DateTime? createdAt;
  GuestDetails? guestDetails;

  TripDatePoll({
    this.id,
    this.tripDatesListId,
    this.guestId,
    this.isSelected,
    this.isDeleted,
    this.createdAt,
    this.guestDetails,
  });

  factory TripDatePoll.fromJson(Map<String, dynamic> json) => TripDatePoll(
        id: json["id"],
        tripDatesListId: json["trip_dates_list_id"],
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
        "trip_dates_list_id": tripDatesListId,
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
  DateTime? lastInvitationTime;
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
        lastInvitationTime: json["last_invitation_time"] == null
            ? null
            : DateTime.parse(json["last_invitation_time"]),
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
        "last_invitation_time": lastInvitationTime?.toIso8601String(),
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
