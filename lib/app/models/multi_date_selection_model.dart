class MultiDateSelectionModel {
  DateTime startDate;
  DateTime endDate;
  String startTime;
  String endTime;
  String displayName;
  String? comment;
  MultiDateSelectionModel({
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.displayName,
    this.comment,
  });
}
