import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
//import 'package:timeago/timeago.dart' as timeago;

const cDateFormat = 'dd/MM/yyyy';
const cDateFormatDDMMYYYY = 'dd MMM yyyy';
const cDateFormatMMDDYYY = 'MM/dd/yyyy';
const cDateFormatMMDDYYYY = 'MM/dd/yyyy';
const cDateFormatDDMMM = 'dd MMM';
const cDateFormatMMDDYY = 'MMM dd, yyyy';
const cDateTimeFormat = 'yyyy-MM-dd kk:mm';
const cDateTimeFormatWithMonth = 'dd MMMM yyyy';
const cTime12hFormat = 'hh:mm a';
const cTime24hFormat = 'HH:mm';

class Date {
  static Date? _date;

  Date._createInstance();

  static Date shared() {
    _date ??= Date._createInstance();
    return _date!;
  }

  // Get DateTime from string date
  DateTime dateFromString(String date, {String dateFormat = cDateFormat}) {
    return DateFormat(cDateFormat).parse(date);
    //return DateTime.parse(date);
  }

  String getCurrentDateFormatted() {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('MMM dd, yyyy').format(currentDate);
    return formattedDate;
  }

  int getTimeStamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  //... Get timestamp from DateTime
  int timestampFromDate(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  //... Get string date from DateTime
  String stringFromDate(DateTime date, {String format = cDateFormatDDMMYYYY}) {
    return DateFormat(format).format(date);
  }

  DateTime getOnlyDate(DateTime date) {
    var strDate = DateFormat("yyyy-MM-dd").format(date);
    return DateFormat("yyyy-MM-dd").parse(strDate);
  }

  String get12hTime(String timeIn24H, {String format = cTime12hFormat}) {
    var df = DateFormat("HH:mm");
    var dt = df.parse(timeIn24H);
    return DateFormat(format).format(dt);
  }

  String get24hTime(String timeIn12H, {String format = cTime24hFormat}) {
    var df = DateFormat("hh:mm a");
    var dt = df.parse(timeIn12H);
    return DateFormat(format).format(dt);
  }

  String getTwelveHourTime(DateTime date) {
    final convertLocal = date.toLocal();
    return DateFormat('hh:mm a').format(convertLocal);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }

  String getTwentyHourTime(DateTime date) {
    final convertLocal = date.toLocal();
    return DateFormat('HH:mm').format(convertLocal);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }

  //... Get date string from timestamp
  String dateStringFromTimestamp(int timestamp, {String format = cDateFormat}) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    return stringFromDate(date, format: format);
  }

  // Get DateTime from timestamp
  DateTime dateFromTimestamp(int timestamp, {String format = cDateTimeFormat}) {
    String strDate = dateStringFromTimestamp(timestamp, format: format);
    return dateFromString(strDate);
  }

  //... Get timestamp from date string
  int timestampFromString(String date) {
    DateTime dt = dateFromString(date);
    return timestampFromDate(dt);
  }

  DateTime getDateTimeFromString(String date, {String format = cDateFormat}) {
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.parse(date);
  }

  //... Convert date from one Date Format to another
  String convertFormatToFormat(
      DateTime date, String inputFormat, String outputFormat) {
    var inputF = DateFormat(inputFormat);
    var iDate = inputF.parse(stringFromDate(date, format: inputFormat));

    var outputF = DateFormat(outputFormat);
    return outputF.format(iDate);
  }

  String readFirebaseTimestamp(Timestamp timestamp, {String? format}) {
    var inputDate1 = DateTime.parse(timestamp.toDate().toString());
    var outputFormat1 = DateFormat(format ?? 'hh:mm a');
    var outputDate1 = outputFormat1.format(inputDate1);
    return outputDate1;
  }

  format(DateTime date) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat("d'$suffix' MMM, yyyy").format(date);
  }

  // Get duration from timestamp
  String duration(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    var currentDate = DateTime.now();
    var diff = currentDate.difference(date);

    String duration = 'Just Now';

    if (diff.inDays >= 1) {
      if (diff.inDays >= 365) {
        var year = diff.inDays / 365;
        duration = '${year.round()} yr ago';
      } else if (diff.inDays >= 30) {
        var month = diff.inDays / 30;
        duration = (month == 1)
            ? '${month.round()} month ago'
            : '${month.round()} months ago';
      } else {
        duration = (diff.inDays == 1)
            ? '${diff.inDays} day ago'
            : '${diff.inDays} days ago';
      }
    } else if (diff.inHours >= 1) {
      duration = '${diff.inHours} hr ago';
    } else if (diff.inMinutes >= 1) {
      duration = '${diff.inMinutes} min ago';
    } else if (diff.inSeconds >= 1) {
      duration = '${diff.inSeconds} sec ago';
    }

    return duration;
  }

  // Get two date differences in Day
  int datesDifferenceInDay(DateTime startDate, DateTime endDate) {
    var diff = endDate.difference(startDate);
    return diff.inDays;
  }

  int getAgeFromBirthdate(DateTime birthDate) {
    var diff = DateTime.now().difference(birthDate);
    int age = (diff.inDays / 365).floor();
    return age;
  }

  //... Check date is today date or not
  bool isToday(int timestamp) {
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    final conversationDate = DateTime(msgDate.year, msgDate.month, msgDate.day);
    return conversationDate == today;
  }

  //... Check date is yesterday or not
  bool isTomorrow(int timestamp) {
    final tomorrow = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    final conversationDate = DateTime(msgDate.year, msgDate.month, msgDate.day);
    return conversationDate == tomorrow;
  }

  //... Check date is yesterday or not
  bool isYesterday(int timestamp) {
    final yesterday = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
    final conversationDate = DateTime(msgDate.year, msgDate.month, msgDate.day);
    return conversationDate == yesterday;
  }

  String readTimestamp(int timestamp) {
    if (timestamp == 0) {
      return '';
    }
    //var now = DateTime.now();
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    //var diff = date.difference(now);
    var time = '';

    // if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
    // } else {
    //   if (diff.inDays == 1) {
    //     time = diff.inDays.toString() + 'DAY AGO';
    //   } else {
    //     time = diff.inDays.toString() + 'DAYS AGO';
    //   }
    // }

    return time;
  }

  String getDateFromUtc(DateTime date) {
    final convertLocal = date.toLocal();
    return DateFormat(cDateFormatDDMMYYYY).format(convertLocal);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }

  String getOnlyDateFromDateTime(DateTime date) {
    return DateFormat('dd').format(date);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }

  String getMonthNameFromDateTime(DateTime date) {
    return DateFormat('MMM').format(date);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }

  String getOnlyYearFromDateTime(DateTime date) {
    return DateFormat('yyyy').format(date);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }

  /* String getMonthNameFromUtc(DateTime date) {
    final convertLocal = date.toLocal();
    return DateFormat('MMM').format(convertLocal);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }*/

  String ordinalSuffixOf(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return '${dayNum}th';
    }

    switch (dayNum % 10) {
      case 1:
        return '${dayNum}st';
      case 2:
        return '${dayNum}nd';
      case 3:
        return '${dayNum}rd';
      default:
        return '${dayNum}th';
    }
  }

  /*String getOnlyDateFromUtc(DateTime date) {
    final convertLocal = date.toLocal();
    return DateFormat('dd').format(convertLocal);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }*/

  /*String getOnlyYearFromUtc(DateTime date) {
    final convertLocal = date.toLocal();
    return DateFormat('yyyy').format(convertLocal);
    // return DateFormat('MMM-dd-yyyy').format(convertLocal);
  }*/

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second ago';
    } else {
      return 'just now';
    }
  }

  getCurrentInUtc() {
    return DateTime.now().toUtc().toString().replaceAll(" ", "T");
  }

  String getDayName(String strDate, String dateFormat) {
    DateTime date = getDateTimeFromString(strDate, format: dateFormat);
    final dayFormat =
        DateFormat('EEE'); // 'EEE' represents the 3 letters of day name
    return dayFormat.format(date);
  }

  String getDayNameFromDateTime(DateTime date) {
    final dayFormat =
        DateFormat('EEE'); // 'EEE' represents the 3 letters of day name
    return dayFormat.format(date);
  }

  String getFutureDate(
      {int days = 7,
      String cDateFormat = cDateFormatMMDDYY,
      DateTime? dateTime}) {
    if (dateTime != null) {
      DateTime date =
          DateTime(dateTime.year, dateTime.month, dateTime.day + days);
      return DateFormat(cDateFormat).format(date);
    } else {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day + days);
      return DateFormat(cDateFormat).format(date);
    }
  }

  /*String timeAgo(DateTime utcDate) {
    final DateTime time1 = utcDate.toLocal();
    return timeago.format(time1, locale: Intl.defaultLocale);
  }*/

  getDifferenceInDaysWithNow(DateTime? date) {
    final now = DateTime.now();
    return now.difference(date!).inDays;
  }

  String dateConverter(String myDate, {String? format}) {
    String date;
    DateTime convertedDate =
        DateFormat(format ?? "dd MMM yyyy").parse(myDate.toString());
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = convertedDate;
    final checkDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (checkDate == today) {
      date = "Today";
    } else if (checkDate == yesterday) {
      date = "Yesterday";
    } else if (checkDate == tomorrow) {
      date = "Tomorrow";
    } else {
      date = myDate;
    }
    return date;
  }

  bool isDate1BeforeDate2(DateTime date1, DateTime date2) {
    return date1.isBefore(date2);
  }
}

extension DateHelper on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int getDifferenceInDaysWithNow(DateTime date) {
    final now = DateTime.now();
    return now.difference(date).inDays;
  }
}
