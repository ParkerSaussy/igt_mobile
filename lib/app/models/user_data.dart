// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  int? id;
  String? signinType;
  String? email;
  String? countryCode;
  String? mobileNumber;
  String? password;
  String? firstName;
  String? lastName;
  dynamic paypalUsername;
  dynamic venmoUsername;
  String? socialId;
  String? socialType;
  int? isEmailVerify;
  int? isMobileVerify;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profileImage;
  String? authToken;
  String? fcmToken;
  int? notificationCount;
  int? getChatNotification;
  int? getPushNotification;
  int? planId;
  DateTime? planStartDate;
  DateTime? planEndDate;
  int? duration;
  String? price;
  String? discountedPrice;
  String? image;

  UserData(
      {this.id,
      this.signinType,
      this.email,
      this.countryCode,
      this.mobileNumber,
      this.password,
      this.firstName,
      this.lastName,
      this.paypalUsername,
      this.venmoUsername,
      this.socialId,
      this.socialType,
      this.isEmailVerify,
      this.isMobileVerify,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.profileImage,
      this.authToken,
      this.fcmToken,
      this.notificationCount,
      this.getChatNotification,
      this.getPushNotification,
      this.planId,
      this.planStartDate,
      this.planEndDate,
      this.duration,
      this.price,
      this.discountedPrice,
      this.image});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        signinType: json["signin_type"],
        email: json["email"],
        countryCode: json["country_code"],
        mobileNumber: json["mobile_number"],
        password: json["password"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        paypalUsername: json["paypal_username"],
        venmoUsername: json["venmo_username"],
        socialId: json["social_id"],
        socialType: json["social_type"],
        isEmailVerify: json["is_email_verify"],
        isMobileVerify: json["is_mobile_verify"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        profileImage: json["profile_image"],
        authToken: json["auth_token"],
        fcmToken: json["fcm_token"],
        notificationCount: json["notification_count"],
        getChatNotification: json["get_chat_notfication"],
        getPushNotification: json["get_push_notfication"],
        planId: json["plan_id"] ?? 0,
        planStartDate: json["plan_start_date"] == null
            ? null
            : DateTime.parse(json["plan_start_date"]),
        planEndDate: json["plan_end_date"] == null
            ? null
            : DateTime.parse(json["plan_end_date"]),
        duration: json["duration"] ?? 0,
        price: json["price"],
        discountedPrice: json["discounted_price"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "signin_type": signinType,
        "email": email,
        "country_code": countryCode,
        "mobile_number": mobileNumber,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "paypal_username": paypalUsername,
        "venmo_username": venmoUsername,
        "social_id": socialId,
        "social_type": socialType,
        "is_email_verify": isEmailVerify,
        "is_mobile_verify": isMobileVerify,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile_image": profileImage,
        "auth_token": authToken,
        "fcm_token": fcmToken,
        "notification_count": notificationCount,
        "get_chat_notfication": getChatNotification,
        "get_push_notfication": getPushNotification,
        "plan_id": planId,
        "plan_start_date": planStartDate?.toIso8601String(),
        "plan_end_date": planEndDate?.toIso8601String(),
        "duration": duration,
        "price": price,
        "discounted_price": discountedPrice,
        "image": image,
      };
}
