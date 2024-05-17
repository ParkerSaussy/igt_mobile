// To parse this JSON data, do
//
//     final likeDislikeModel = likeDislikeModelFromJson(jsonString);

import 'dart:convert';

LikeDislikeModel likeDislikeModelFromJson(String str) =>
    LikeDislikeModel.fromJson(json.decode(str));

String likeDislikeModelToJson(LikeDislikeModel data) =>
    json.encode(data.toJson());

class LikeDislikeModel {
  int? like;
  int? disLike;

  LikeDislikeModel({
    this.like,
    this.disLike,
  });

  factory LikeDislikeModel.fromJson(Map<String, dynamic> json) =>
      LikeDislikeModel(
        like: json["like"],
        disLike: json["disLike"],
      );

  Map<String, dynamic> toJson() => {
        "like": like,
        "disLike": disLike,
      };
}
