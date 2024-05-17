// To parse this JSON data, do
//
//     final shareList = shareListFromJson(jsonString);

import 'dart:convert';

ShareList shareListFromJson(String str) => ShareList.fromJson(json.decode(str));

String shareListToJson(ShareList data) => json.encode(data.toJson());

class ShareList {
  String? amount;
  int? debtor;

  ShareList({
    this.amount,
    this.debtor,
  });

  factory ShareList.fromJson(Map<String, dynamic> json) => ShareList(
        amount: json["amount"],
        debtor: json["debtor"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "debtor": debtor,
      };
}
