// To parse this JSON data, do
//
//     final addedGuestmodel = addedGuestmodelFromJson(jsonString);

import 'dart:convert';

AddedGuestmodel addedGuestmodelFromJson(String str) =>
    AddedGuestmodel.fromJson(json.decode(str));

String addedGuestmodelToJson(AddedGuestmodel data) =>
    json.encode(data.toJson());

class AddedGuestmodel {
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
  bool isSelected = false;
  String? profilePicture;

  AddedGuestmodel({
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
    this.profilePicture,
    this.isSelected = false,
  });

  factory AddedGuestmodel.fromJson(Map<String, dynamic> json) =>
      AddedGuestmodel(
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
        profilePicture: json["profile_picture"],
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
        "profile_picture": profilePicture,
      };
}
