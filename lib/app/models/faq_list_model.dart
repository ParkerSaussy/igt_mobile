/*
class FAQList{
  bool? isSelected;
  String? title;
  String? desc;
  FAQList({
    required this.isSelected,
    required this.title,
    required this.desc,
  });
}*/
// To parse this JSON data, do
//
//     final faqListModel = faqListModelFromJson(jsonString);

import 'dart:convert';

List<FaqListModel> faqListModelFromJson(String str) => List<FaqListModel>.from(
    json.decode(str).map((x) => FaqListModel.fromJson(x)));

String faqListModelToJson(List<FaqListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FaqListModel {
  int? id;
  String? question;
  String? answer;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isSelected = false;

  FaqListModel(
      {this.id,
      this.question,
      this.answer,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.isSelected = false});

  factory FaqListModel.fromJson(Map<String, dynamic> json) => FaqListModel(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
