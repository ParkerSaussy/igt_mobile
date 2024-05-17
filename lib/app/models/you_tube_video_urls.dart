// To parse this JSON data, do
//
//     final youTubeVideoUrls = youTubeVideoUrlsFromJson(jsonString);

import 'dart:convert';

List<YouTubeVideoUrls> youTubeVideoUrlsFromJson(String str) =>
    List<YouTubeVideoUrls>.from(
        json.decode(str).map((x) => YouTubeVideoUrls.fromJson(x)));

String youTubeVideoUrlsToJson(List<YouTubeVideoUrls> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class YouTubeVideoUrls {
  int? id;
  String? type;
  String? key;
  String? value;
  dynamic createdAt;
  DateTime? updatedAt;

  YouTubeVideoUrls({
    this.id,
    this.type,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory YouTubeVideoUrls.fromJson(Map<String, dynamic> json) =>
      YouTubeVideoUrls(
        id: json["id"],
        type: json["type"],
        key: json["key"],
        value: json["value"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "key": key,
        "value": value,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}
