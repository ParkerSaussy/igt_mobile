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

  void onDateCancel() {
    rangeStart = null;
    rangeEnd = null;
    arriveTime.value = "HH:MM";
    leaveTime.value = "HH:MM";
    commentTextEditingController.clear();
    Get.back();
  }

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

  void changeParameterForAllCityList() {
    for (var item in lstCitySearch) {
      item.isSelected = false;
    }
  }

  String getDateString(DateTime date) {
    //return Date.shared().stringFromDate(date, format: cDateFormatDDMMM);
    return "${Date.shared().ordinalSuffixOf(int.parse(Date.shared().getOnlyDateFromDateTime(date)))} ${Date.shared().getMonthNameFromDateTime(date)}";
  }

  String getDays(DateTime startDate, DateTime endDate) {
    int days = Date.shared().datesDifferenceInDay(startDate, endDate);

    return days > 1
        ? '$days ${LabelKeys.days.tr}'
        : '$days ${LabelKeys.day.tr}';
  }

  String getYear(DateTime startDate) {
    return Date.shared().getOnlyYearFromDateTime(startDate);
  }

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

  bool isDate1BeforeDate2(DateTime date1, DateTime date2) {
    return date1.isBefore(date2);
  }

  String formatDateToMMDDYYYY(String date) {
    printMessage("Date: $date");
    return DateFormat('MM/dd/yyyy')
        .format(DateTime.parse(date.replaceAll('/', '-')));
  }

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
