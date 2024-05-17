// To parse this JSON data, do
//
//     final activityDetailsModel = activityDetailsModelFromJson(jsonString);

import 'dart:convert';

ActivityDetailsModel activityDetailsModelFromJson(String str) =>
    ActivityDetailsModel.fromJson(json.decode(str));

String activityDetailsModelToJson(ActivityDetailsModel data) =>
    json.encode(data.toJson());

class ActivityDetailsModel {
  int? id;
  int? userId;
  int? tripId;
  String? activityType;
  String? name;
  DateTime? eventDate;
  String? eventTime;
  DateTime? departureDate;
  String? checkoutTime;
  String? discription;
  String? url;
  String? address;
  String? cost;
  int? spentHours;
  int? numberOfNights;
  String? averageNightlyCost;
  int? capacityPerRoom;
  String? roomNumber;
  String? arrivalFlightNumber;
  String? departureFlightNumber;
  int? isItineary;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likeCount;
  int? dislikeCount;
  String? createdBy;

  ActivityDetailsModel(
      {this.id,
      this.userId,
      this.tripId,
      this.activityType,
      this.name,
      this.eventDate,
      this.eventTime,
      this.departureDate,
      this.checkoutTime,
      this.discription,
      this.url,
      this.address,
      this.cost,
      this.spentHours,
      this.numberOfNights,
      this.averageNightlyCost,
      this.capacityPerRoom,
      this.roomNumber,
      this.arrivalFlightNumber,
      this.departureFlightNumber,
      this.isItineary,
      this.createdAt,
      this.updatedAt,
      this.likeCount,
      this.dislikeCount,
      this.createdBy});

  factory ActivityDetailsModel.fromJson(Map<String, dynamic> json) =>
      ActivityDetailsModel(
        id: json["id"],
        userId: json["user_id"],
        tripId: json["trip_id"],
        activityType: json["activity_type"],
        name: json["name"],
        eventDate: json["event_date"] == null
            ? null
            : DateTime.parse(json["event_date"]),
        eventTime: json["event_time"],
        departureDate: json["departure_date"] == null
            ? null
            : DateTime.parse(json["departure_date"]),
        checkoutTime: json["checkout_time"],
        discription: json["discription"],
        url: json["url"],
        address: json["address"],
        cost: json["cost"],
        spentHours: json["spent_hours"],
        numberOfNights: json["number_of_nights"],
        averageNightlyCost: json["average_nightly_cost"],
        capacityPerRoom: json["capacity_per_room"],
        roomNumber: json["room_number"],
        arrivalFlightNumber: json["arrival_flight_number"],
        departureFlightNumber: json["departure_flight_number"],
        isItineary: json["is_itineary"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        likeCount: json["like_count"],
        dislikeCount: json["dislike_count"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "trip_id": tripId,
        "activity_type": activityType,
        "name": name,
        "event_date":
            "${eventDate!.year.toString().padLeft(4, '0')}-${eventDate!.month.toString().padLeft(2, '0')}-${eventDate!.day.toString().padLeft(2, '0')}",
        "event_time": eventTime,
        "departure_date":
            "${departureDate!.year.toString().padLeft(4, '0')}-${departureDate!.month.toString().padLeft(2, '0')}-${departureDate!.day.toString().padLeft(2, '0')}",
        "checkout_time": checkoutTime,
        "discription": discription,
        "url": url,
        "address": address,
        "cost": cost,
        "spent_hours": spentHours,
        "number_of_nights": numberOfNights,
        "average_nightly_cost": averageNightlyCost,
        "capacity_per_room": capacityPerRoom,
        "room_number": roomNumber,
        "arrival_flight_number": arrivalFlightNumber,
        "departure_flight_number": departureFlightNumber,
        "is_itineary": isItineary,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "like_count": likeCount,
        "dislike_count": dislikeCount,
        "createdBy": createdBy
      };
}
