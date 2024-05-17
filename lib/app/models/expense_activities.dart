// To parse this JSON data, do
//
//     final expenseActivities = expenseActivitiesFromJson(jsonString);

import 'dart:convert';

List<ExpenseActivities> expenseActivitiesFromJson(String str) =>
    List<ExpenseActivities>.from(
        json.decode(str).map((x) => ExpenseActivities.fromJson(x)));

String expenseActivitiesToJson(List<ExpenseActivities> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpenseActivities {
  double? totalAmount;
  int? guestId;
  int? uId;
  String? creditor;
  String? description;
  String? name;
  DateTime? expenseOn;
  String? type;
  double? remainAmount;
  double? amount;
  int? expenseId;

  ExpenseActivities({
    this.totalAmount,
    this.guestId,
    this.uId,
    this.creditor,
    this.description,
    this.name,
    this.expenseOn,
    this.type,
    this.remainAmount,
    this.amount,
    this.expenseId,
  });

  factory ExpenseActivities.fromJson(Map<String, dynamic> json) =>
      ExpenseActivities(
        totalAmount: double.parse(json["totalAmount"].toString()),
        guestId: json["guest_id"],
        uId: json["u_id"],
        creditor: json["creditor"],
        description: json["description"],
        name: json["name"] ?? "",
        expenseOn: json["expense_on"] == null
            ? null
            : DateTime.parse(json["expense_on"]),
        type: json["type"],
        remainAmount: double.parse(json["remainAmount"].toString()),
        amount: double.parse(json["amount"].toString()),
        expenseId: json["expense_id"],
      );

  Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "guest_id": guestId,
        "u_id": uId,
        "creditor": creditor,
        "description": description,
        "name": name,
        "expense_on":
            "${expenseOn!.year.toString().padLeft(4, '0')}-${expenseOn!.month.toString().padLeft(2, '0')}-${expenseOn!.day.toString().padLeft(2, '0')}",
        "type": type,
        "remainAmount": remainAmount,
        "amount": amount,
        "expense_id": expenseId,
      };
}
