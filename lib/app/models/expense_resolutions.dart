// To parse this JSON data, do
//
//     final expenseResolutions = expenseResolutionsFromJson(jsonString);

import 'dart:convert';

List<ExpenseResolutions> expenseResolutionsFromJson(String str) =>
    List<ExpenseResolutions>.from(
        json.decode(str).map((x) => ExpenseResolutions.fromJson(x)));

String expenseResolutionsToJson(List<ExpenseResolutions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpenseResolutions {
  double? amount;
  int? opp;
  String? opponent;
  String? paypalUsername;
  String? venmoUsername;

  ExpenseResolutions({
    this.amount,
    this.opp,
    this.opponent,
    this.paypalUsername,
    this.venmoUsername,
  });

  factory ExpenseResolutions.fromJson(Map<String, dynamic> json) =>
      ExpenseResolutions(
        amount: double.parse(json["amount"].toString()),
        opp: json["opp"],
        opponent: json["opponent"],
        paypalUsername: json["paypal_username"],
        venmoUsername: json["venmo_username"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "opp": opp,
        "opponent": opponent,
        "paypal_username": paypalUsername,
        "venmo_username": venmoUsername,
      };
}
