// To parse this JSON data, do
//
//     final singlePlanModel = singlePlanModelFromJson(jsonString);

import 'dart:convert';

List<SinglePlanModel> singlePlanModelFromJson(String str) =>
    List<SinglePlanModel>.from(
        json.decode(str).map((x) => SinglePlanModel.fromJson(x)));

String singlePlanModelToJson(List<SinglePlanModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SinglePlanModel {
  int? id;
  String? name;
  String? description;
  String? price;
  dynamic duration;
  String? image;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  String? applePayKey;
  String? discountedPrice;
  bool? isPlanPurchased = false;
  String? imageUrl;

  SinglePlanModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.duration,
    this.image,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.applePayKey,
    this.discountedPrice,
    this.isPlanPurchased = false,
    this.imageUrl,
  });

  factory SinglePlanModel.fromJson(Map<String, dynamic> json) =>
      SinglePlanModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        duration: json["duration"],
        image: json["image"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        type: json["type"],
        applePayKey: json["apple_pay_key"],
        discountedPrice: json["discounted_price"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "duration": duration,
        "image": image,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "type": type,
        "apple_pay_key": applePayKey,
        "discounted_price": discountedPrice,
        "image_url": imageUrl,
      };
}
