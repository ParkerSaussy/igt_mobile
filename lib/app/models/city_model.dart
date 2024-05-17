import 'dart:convert';

class CityModel {
  String cityName;
  CityModel({
    required this.cityName,
  });
}

// To parse this JSON data, do
//
//     final citiesModel = citiesModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final citiesModel = citiesModelFromJson(jsonString);


List<CitiesModel> citiesModelFromJson(String str) => List<CitiesModel>.from(json.decode(str).map((x) => CitiesModel.fromJson(x)));

String citiesModelToJson(List<CitiesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CitiesModel {
  int id;
  String cityName;
  String state;
  String stateAbbr;
  String countryName;
  String timeZone;
  int isDeleted;
  DateTime createdAt;
  bool? isSelected = false;

  CitiesModel({
    required this.id,
    required this.cityName,
    required this.state,
    required this.stateAbbr,
    required this.countryName,
    required this.timeZone,
    required this.isDeleted,
    required this.createdAt,
    this.isSelected = false,
  });

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
    id: json["id"],
    cityName: json["city_name"],
    state: json["state"],
    stateAbbr: json["state_abbr"],
    countryName: json["country_name"],
    timeZone: json["time_zone"],
    isDeleted: json["is_deleted"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_name": cityName,
    "state": state,
    "state_abbr": stateAbbr,
    "country_name": countryName,
    "time_zone": timeZone,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
  };
}

