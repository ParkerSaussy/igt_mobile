import 'package:flutter/material.dart';

class PollModel {
  String date;
  int totalPoll;
  int totalPolled;
  String groupValue;
  Color indicatorColor;

  PollModel(
      {required this.date,
      required this.totalPoll,
      required this.totalPolled,
      required this.groupValue,
      required this.indicatorColor});
}
