import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/models/city_model.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../master/general_utils/date.dart';
import '../../../models/multi_date_selection_model.dart';
import '../../../models/trip_details_model.dart';

class CreateTripController extends GetxController {
  //TODO: Implement CreateTripController

  RxBool isReset = true.obs;
  var selectedCategory = ''.obs;
  //var selectedReminder = ''.obs;
  var isSelectedCategory = false.obs;
  var isSelectedReminder = false.obs;
  RxInt noOfReminderDays = 0.obs;
  RxInt maxReminderDays = 0.obs;
  RxList<CitiesModel> lstCity = <CitiesModel>[].obs;
  RxList<CitiesModel> lstCitySearch = <CitiesModel>[].obs;
  RxList<CitiesModel> lstEmptyCity = <CitiesModel>[].obs;
  //List<ReminderModel> lstReminder = [];
  //ReminderModel? selectedRemainder;
  var refreshList = ''.obs;
  List<MultiDateSelectionModel> lstEmptyDate = [];
  var refreshListDate = ''.obs;
  //var reminderList = ''.obs;
  RxString arriveTime = "HH:MM".obs;
  RxString leaveTime = "HH:MM".obs;
  RxString descCount = "250".obs;
  TextEditingController tripDetailController = TextEditingController();
  TextEditingController tripNameController = TextEditingController();
  TextEditingController tripItineraryController = TextEditingController();
  TextEditingController commentTextEditingController = TextEditingController();
  TextEditingController searchCityController = TextEditingController();
  FocusNode selectDisplayImageNode = FocusNode();
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  RxString responseSelectedDeadline = LabelKeys.selectDate.tr.obs;
  String responseSelectedDeadlineUTC = "";

  final formKey = GlobalKey<FormState>();
  RxString uploadedImageName = "".obs;
  Timer? timer;
  String searchText = "";

  @override
  void onInit() {
    super.onInit();
    getCities();
    //lstReminder = Constants.getReminderDaysList();
  }

  /// Adds a date range to the list of empty dates if it does not already exist.
  ///
  /// Checks if the current date range defined by [rangeStart] and [rangeEnd] 
  /// is not already present in [lstEmptyDate]. If not present, it creates a 
  /// new `MultiDateSelectionModel` with details including the start and end 
  /// dates, arrival and leave times, and comments, then adds it to the list.
  /// Resets the range selection and times, clears the comment, and updates 
  /// [refreshListDate] to trigger a UI update.
  ///
  /// If the date range already exists, it shows a snackbar with an error 
  /// message indicating that the date range is not addable.

  void onDateAdded() {
    final isAddable = lstEmptyDate.where((element) =>
        element.startDate == rangeStart && element.endDate == rangeEnd);
    if (isAddable.toString() == "()") {
      lstEmptyDate.add(MultiDateSelectionModel(
          displayName:
              "${getDays(rangeStart!, rangeEnd!)} - (${getDateString(rangeStart!)} - "
              "${getDateString(rangeEnd!)}), "
              "${getYear(rangeStart!)} ",
          /*displayName:
              "${getDays(rangeStart!, rangeEnd!)} - (${getDateString(rangeStart!)}, "
              "${Date.shared().getDayNameFromDateTime(rangeStart!)} - "
                  "${getDateString(rangeEnd!)}, ${Date.shared().getDayNameFromDateTime(rangeEnd!)}), "
                  "${getYear(rangeStart!)} ",*/
          startDate: rangeStart!,
          endDate: rangeEnd!,
          startTime: arriveTime.value,
          endTime: leaveTime.value,
          comment: commentTextEditingController.text));
      rangeStart = null;
      rangeEnd = null;
      arriveTime.value = "HH:MM";
      leaveTime.value = "HH:MM";
      commentTextEditingController.clear();
      refreshListDate.value = getRandomString();
      Get.back();
    } else {
      Get.snackbar("", LabelKeys.dateRangeMsg.tr,
          backgroundColor: Get.theme.colorScheme.error,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Get.theme.colorScheme.onError);
    }
  }

  /// Resets the date range selection and times, clears the comment, and
  /// goes back to the previous screen.
  ///
  /// Called when the user taps on the cancel button while selecting a date
  /// range.
  void onDateCancel() {
    rangeStart = null;
    rangeEnd = null;
    arriveTime.value = "HH:MM";
    leaveTime.value = "HH:MM";
    commentTextEditingController.clear();
    Get.back();
  }

  /// Resets all the values to their default state.
  ///
  /// This function is called when the user navigates to the create trip screen
  /// and is used to clear all the previously entered data.
  void reset() {
    selectedCategory.value = '';
    //selectedReminder.value = '';
    isSelectedCategory.value = false;
    isSelectedReminder.value = false;
    noOfReminderDays.value = 0;
    maxReminderDays.value = 0;
    // lstCity = [];
    lstEmptyCity.clear();
    refreshList.value = getRandomString();
    lstEmptyDate = [];
    refreshListDate.value = getRandomString();
    //reminderList.value = '';
    arriveTime.value = "HH:MM";
    leaveTime.value = "HH:MM";
    descCount.value = "250";
    tripDetailController.text = "";
    changeParameterForAllCityList();
    focusedDay = DateTime.now();
    selectedDay = null;
    rangeStart = null;
    rangeEnd = null;
    responseSelectedDeadline.value = "Select Date";
    responseSelectedDeadlineUTC = "";
    commentTextEditingController.text = "";
    tripNameController.text = "";
    tripItineraryController.text = "";
    uploadedImageName.value = "";
  }

  /// Resets the `isSelected` property of all the items in `lstCitySearch`
  /// to `false`.
  ///
  /// This function is used to clear all the previously selected cities when
  /// the user navigates to the create trip screen and is used to clear all the
  /// previously entered data.
  void changeParameterForAllCityList() {
    for (var item in lstCitySearch) {
      item.isSelected = false;
    }
  }

  /// Returns a date string in the format of "dd MMM" from the given
  /// [DateTime] object.
  ///
  /// The date string is in the format of "dd MMM", where "dd" is the day of
  /// the month with an ordinal suffix (e.g. 1st, 2nd, 3rd, etc.) and "MMM"
  /// is the abbreviated month name (e.g. Jan, Feb, Mar, etc.).
  String getDateString(DateTime date) {
    //return Date.shared().stringFromDate(date, format: cDateFormatDDMMM);
    return "${Date.shared().ordinalSuffixOf(int.parse(Date.shared().getOnlyDateFromDateTime(date)))} ${Date.shared().getMonthNameFromDateTime(date)}";
  }

  /// Returns a string representation of the number of days between two dates.
  ///
  /// The method takes two [DateTime] objects and returns a string in the format
  /// "X days" or "X day" depending on whether the number of days is greater than
  /// one. The string is translated according to the current locale.
  String getDays(DateTime startDate, DateTime endDate) {
    int days = Date.shared().datesDifferenceInDay(startDate, endDate);

    return days > 1
        ? '$days ${LabelKeys.days.tr}'
        : '$days ${LabelKeys.day.tr}';
  }

  /// Returns the year as a string from the given [DateTime] object.
  ///
  /// The method extracts and returns only the year component of the [startDate]
  /// in string format.

  String getYear(DateTime startDate) {
    return Date.shared().getOnlyYearFromDateTime(startDate);
  }

  /// Fetches a list of cities based on the search text entered by the user.
  ///
  /// Sends a POST request to the [EndPoints.getCities] endpoint with the
  /// search text from [searchCityController]. If the request succeeds,
  /// it populates [lstCity] and [lstCitySearch] with the response data,
  /// updates the selection status of cities present in [lstEmptyCity],
  /// and refreshes the city list. If the request fails, it logs the error
  /// message.

  void getCities() {
    RequestManager.postRequest(
      uri: EndPoints.getCities,
      isLoader: true,
      hasBearer: false,
      body: {RequestParams.searchText: searchCityController.text.toString()},
      onSuccess: (responseBody, message, status) {
        lstCity.value = List<CitiesModel>.from(
            responseBody.map((x) => CitiesModel.fromJson(x)));
        lstCitySearch.value = lstCity.value;
        for (var city in lstCitySearch) {
          var cityExistsInEmptyCity =
              lstEmptyCity.any((emptyCity) => city.id == emptyCity.id);
          if (cityExistsInEmptyCity) {
            city.isSelected = true;
          }
        }
        refreshList.value = getRandomString();
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  /// Validates all the trip data.
  ///
  /// This function is used to validate all the input fields of the trip data,
  /// including the city list, date list, response deadline, reminder, and the
  /// display image. It shows the appropriate error message if any of the
  /// fields are blank. If all the fields are valid, it calls the [createTripAPI]
  /// method to create a new trip.
  void validateTripData() {
    if (formKey.currentState!.validate()) {
      if (lstEmptyCity.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripCities.tr,
        );
      } else if (lstEmptyDate.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripDates.tr,
        );
      } else if (responseSelectedDeadline.value == "Select Date") {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripResponseDeadline.tr,
        );
      } else if (!checkResponseDeadLine()) {
        RequestManager.getSnackToast(
          message: LabelKeys.validTripResponseDeadline.tr,
        );
      } /*else if (selectedRemainder == null) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripRemainderDays.tr,
        );
      }*/
      else if (uploadedImageName.value.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripDisplayImage.tr,
        );
      } else {
        createTripAPI();
      }
    }
  }

  /// Checks whether [date1] is before [date2].
  ///
  /// This method takes two dates and returns true if [date1] is before [date2],
  /// otherwise it returns false.
  bool isDate1BeforeDate2(DateTime date1, DateTime date2) {
    return date1.isBefore(date2);
  }

  /// Formats a given date string to MM/dd/yyyy format.
  ///
  /// This method takes a date string in the format of dd/mm/yyyy and
  /// returns a new string in the format of MM/dd/yyyy.
  String formatDateToMMDDYYYY(String date) {
    printMessage("Date: $date");
    return DateFormat('MM/dd/yyyy')
        .format(DateTime.parse(date.replaceAll('/', '-')));
  }

  /// Checks whether the response deadline date is valid or not.
  ///
  /// This method takes into account the following conditions to validate the response deadline date:
  /// 1. The date should not be before the current date.
  /// 2. The date should not be the same as the old response deadline date.
  /// 3. The date should not be before any of the dates in the trip date poll.
  /// If any of these conditions are not met, the method returns false. Otherwise, it returns true.
  bool checkResponseDeadLine() {
    for (int i = 0; i < lstEmptyDate.length; i++) {
      DateTime date1 =
          DateTime.parse(responseSelectedDeadline.value.replaceAll('/', '-'));
      DateTime date2 = DateTime.parse(
          DateFormat('yyyy-MM-dd').format(lstEmptyDate[i].startDate));
      if (!isDate1BeforeDate2(date1, date2)) {
        return false;
      }
    }
    return true;
  }

  /// Sends a request to create a new trip with the provided trip details.
  ///
  /// This method constructs request body data including trip dates, cities, image URL,
  /// and other trip details. It makes a POST request to the [EndPoints.createTrip] 
  /// endpoint. If the request is successful, it initializes a [TripDetailsModel] from 
  /// the response and calls [createGroup] to create a group for the trip.
  ///
  /// The request body includes:
  /// - [RequestParams.tripName]: Name of the trip.
  /// - [RequestParams.tripDescription]: Description of the trip.
  /// - [RequestParams.itinaryDetails]: Itinerary details of the trip.
  /// - [RequestParams.responseDeadline]: Deadline for trip response.
  /// - [RequestParams.reminderDays]: Number of reminder days.
  /// - [RequestParams.tripImgUrl]: URL of the trip image.
  /// - [RequestParams.tripDatesList]: List of trip dates with start and end times.
  /// - [RequestParams.tripCitiesList]: List of city IDs for the trip.
  ///
  /// On success, it processes the trip details and creates a group. On failure, it logs
  /// the error message.

  void createTripAPI() {
    var tripDateMap = lstEmptyDate.map((e) {
      var startTempDate = convertUTCtoLocal(
          addTime(e.startDate, e.startTime)); //convert time offset local to UTC
      var endTempDate = convertUTCtoLocal(
          addTime(e.endDate, e.endTime)); //convert time offset local to UTC
      String startDate =
          DateFormat('yyyy/MM/dd HH:mm:ss').format(startTempDate);
      String endDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(endTempDate);
      return {
        RequestParams.startDate: startDate, //"$startDate ${e.startTime}",
        RequestParams.endDate: endDate, //"$endDate ${e.endTime}",
        RequestParams.comment: e.comment
      };
    }).toList();

    printMessage(tripDateMap.toString());

    var tripCities = lstEmptyCity.map((e) {
      return {
        RequestParams.cityId: e.id,
      };
    }).toList();
    final fileName = getFileNameFromURL(uploadedImageName.value);
    final body = {
      RequestParams.tripName: tripNameController.text,
      RequestParams.tripDescription: tripDetailController.text,
      RequestParams.itinaryDetails: tripItineraryController.text,
      RequestParams.responseDeadline: responseSelectedDeadlineUTC,
      RequestParams.reminderDays: noOfReminderDays.value.toString(),
      RequestParams.tripImgUrl: fileName,
      RequestParams.tripDatesList: tripDateMap,
      RequestParams.tripCitiesList: tripCities
    };
    printMessage("body: $body");
    RequestManager.postRequest(
      uri: EndPoints.createTrip,
      isLoader: true,
      hasBearer: true,
      isSuccessMessage: true,
      body: body,
      onSuccess: (responseBody, message, status) {
        var tripDetailsData =
            tripDetailsModelFromJson(jsonEncode(responseBody));
        TripDetailsModel tripDetailsModel = tripDetailsData;
        createGroup(tripDetailsModel, responseBody["created_by"]);
      },
      onFailure: (error) {
        printMessage("error: $error");
      },
    );
  }

  /// This function is used to create a group in the firestore database.
  ///
  /// It takes TripDetailsModel and int as parameters.
  /// It adds the data to the firestore database with the document id as the trip id.
  /// The data that is added contains the trip id, file name, file type, group data, member ids, message, sender id, and timestamp.
  /// The group data contains the group admin, group created at, group image, and group name.
  /// If the data is added successfully, it will navigate to the AddedGuestListScreen with the trip details model, Constants.fromCreateTrip, and created by as arguments.
  void createGroup(TripDetailsModel tripDetailsModel, int createdBy) {
    FireStoreServices.addDataWithDocumentId(
      isLoader: true,
      body: {
        FireStoreParams.tripId: tripDetailsModel.id.toString(),
        FireStoreParams.fileName: '',
        FireStoreParams.fileType: '',
        FireStoreParams.groupData: {
          FireStoreParams.groupAdmin: gc.loginData.value.id.toString(),
          FireStoreParams.groupCreatedAt: DateTime.now(),
          FireStoreParams.groupImage: uploadedImageName.value,
          FireStoreParams.groupName: tripNameController.text
        },
        FireStoreParams.memberIds: [],
        FireStoreParams.message: '',
        FireStoreParams.senderId: '',
        FireStoreParams.timestamp: DateTime.now(),
      },
      documentId: tripDetailsModel.id.toString(),
      collectionName: FireStoreCollection.tripGroupCollection,
      onSuccess: (response) {
        Get.offNamed(Routes.ADDED_GUEST_LIST,
            arguments: [tripDetailsModel, Constants.fromCreateTrip, createdBy]);
      },
      onFailure: (error) {},
    );
  }

  /// Starts a periodic timer that checks for changes in the search city text field.
  ///
  /// This method initializes a timer that triggers every second. If the text in the
  /// `searchCityController` differs from the `searchText`, it updates `searchText`
  /// and calls the `getCities` function to fetch city data based on the new input.
  /// If a timer already exists, it is canceled before starting a new one.

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (searchCityController.text != searchText) {
          searchText = searchCityController.text;
          getCities();
        }
      },
    );
  }

/// Adjusts the number of reminder days.
///
/// This method increments or decrements the [noOfReminderDays] based on the 
/// value of the [add] parameter. If [add] is true, it increments the 
/// [noOfReminderDays] by 1 until the [maxReminderDays] is reached. If the 
/// maximum limit is reached, it displays a toast message indicating that the 
/// maximum limit has been reached. If [add] is false, it decrements the 
/// [noOfReminderDays] by 1, stopping at zero.

  void reminderDateStepper(bool add) {
    if (add) {
      if (noOfReminderDays < maxReminderDays.value) {
        noOfReminderDays++;
      } else {
        RequestManager.getSnackToast(message: LabelKeys.maximumLimitReached.tr);
      }
    } else {
      if (noOfReminderDays > 0) {
        noOfReminderDays--;
      }
    }
  }
}
