import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_paypal_native/models/approval/approval_data.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/models/SingleTripPlanModel.dart';
import 'package:lesgo/app/models/multi_date_selection_model.dart';
import 'package:lesgo/app/models/single_plan_model.dart';
import 'package:lesgo/app/models/trip_city_poll_model.dart';
import 'package:lesgo/app/models/trip_date_poll_model.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/app/modules/common_widgets/bottomsheet_with_close.dart';
import 'package:lesgo/app/modules/common_widgets/subscription_widget.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/paypal_payment.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../master/general_utils/images_path.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../master/session/preference.dart';
import '../../../models/city_model.dart';
import '../../../models/reminder_model.dart';
import '../../../models/user_data.dart';

class TripDetailController extends GetxController {
  //TODO: Implement TripDetailController

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  RxString responseSelectDeadline = "".obs;
  RxString responseSelectedDeadline = "Select Date".obs;
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode =
      RangeSelectionMode.toggledOn; // Can be toggled on/off by long pressing a
  var isSelectedReminder = false.obs;
  RxInt noOfReminderDays = 0.obs;
  RxInt maxReminderDays = 0.obs;
  var isError = false.obs;
  RxString arriveTime = "HH:MM".obs;
  RxString leaveTime = "HH:MM".obs;
  RxString arriveEventTime = "HH:MM".obs;
  RxString endEventTime = "HH:MM".obs;
  RxString arriveByTime = "HH:MM".obs;
  RxString leaveAfterTime = "HH:MM".obs;
  RxString leaveEventTime = "HH:MM".obs;
  var selectedCategory = 'New York, USA, (EST)'.obs;

  //var selectedReminder = '2 days'.obs;
  var isSelectedCategory = false.obs;
  List<ReminderModel> lstReminder = [];

  //ReminderModel? selectedRemainder;
  var reminderList = ''.obs;
  TextEditingController commentTextEditingController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController itineraryController = TextEditingController();
  TextEditingController tCommentController = TextEditingController();
  TextEditingController descController = TextEditingController();
  FocusNode eNameNode = FocusNode();
  FocusNode itineraryNode = FocusNode();
  FocusNode tCommentNode = FocusNode();
  FocusNode descNode = FocusNode();
  bool isTripFinalizingCommentError = false;
  RxString onDate = LabelKeys.selectDate.tr.obs;
  String onDateUTC = "";
  String oldResponseDeadLine = "";
  ScrollController scrollController = ScrollController();
  RxList<CitiesModel> lstCity = <CitiesModel>[].obs;
  RxList<CitiesModel> lstCitySearch = <CitiesModel>[].obs;
  RxList<CitiesModel> lstEmptyCity = <CitiesModel>[].obs;
  var refreshList = ''.obs;
  int? tripId;
  TripDetailsModel? tripDetailsModel;
  RxBool isTripDetailsLoaded = false.obs;
  RxString selectedTripImage = "".obs;
  RxString selectedTripImageURL = "".obs;
  List<MultiDateSelectionModel> lstEmptyDate = [];
  RxInt isEditable = 0.obs;
  RxString descCount = "500".obs;
  RxList<TripDetailsDatePollModel> lstTripDatePoll =
      <TripDetailsDatePollModel>[].obs;
  RxBool isDatePollExpanded = true.obs;
  final formKey = GlobalKey<FormState>();
  RxInt isTripToFinalised = 0.obs;
  RxString restorationId = "".obs;
  RxString restorationIdCity = "".obs;
  TripDetailsDatePollModel? selectedDateByHost;
  RxString startEndDateText = "".obs;
  RxList<TripDetailsCityPollModel> lstTripDetailsCityPoll =
      <TripDetailsCityPollModel>[].obs;
  RxBool isCityPollExpanded = true.obs;
  TripDetailsCityPollModel? selectedTripCityByHost;
  List<int> tripSelectedCitiesPollTemp = <int>[];
  List<int> tripSelectedDatesPollTemp = <int>[];
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  List<SingleTripPlanModel> lstSingleTripPlanModel = [];
  RxList<SinglePlanModel> lstSinglePlan = <SinglePlanModel>[].obs;
  TextEditingController paypalUsernameController = TextEditingController();
  TextEditingController venmoUsernameController = TextEditingController();
  RxBool isPremiumTrip = false.obs;

  List<GlobalKey> listGlobalKey = [GlobalKey(), GlobalKey(), GlobalKey()];

  /*final GlobalKey<FormState> datePollKey = GlobalKey<FormState>();
  final GlobalKey<FormState> finalizingCommentKey = GlobalKey<FormState>();
  final GlobalKey<FormState> cityPollKey = GlobalKey<FormState>();*/

  // calendar plugin variable
  final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
  var calenderId;
  TextEditingController searchCityController = TextEditingController();
  Timer? timer;
  String searchText = "";

  // Smart refresher
  RefreshController tripDetailController = RefreshController();

  @override
  void onInit() {
    super.onInit();
    tripId = Get.arguments[0];
    FireStoreServices.checkIfTripExists(tripId: tripId.toString());
    // listGlobalKey.add(GlobalKey()); // city 0
    //listGlobalKey.add(GlobalKey()); // date 1
    //listGlobalKey.add(GlobalKey()); // finalizingComment 2
    getTripDetails(false);
    addPlanDetailsData();
    addReminderListData();
  }

  //Refresh Data
  /// Refreshes the trip details.
  ///
  /// This method performs an asynchronous refresh of the trip details.
  /// It first delays for a second to simulate a loading time, then
  /// checks if the current trip exists using the firestore service.
  /// It retrieves the trip details with loading indicator, updates
  /// the plan details data and reminder list data, and finally marks
  /// the refresh operation as completed.

  void onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    FireStoreServices.checkIfTripExists(tripId: tripId.toString());
    getTripDetails(true);
    addPlanDetailsData();
    addReminderListData();
    tripDetailController.refreshCompleted();
  }

  /// Simulates a loading time by delaying for a second.
  ///
  /// This method is used for simulating a loading time when the user
  /// pulls down the screen to refresh the trip details. It simply
  /// delays for a second before the refresh operation is completed.
  void onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  getWidth() => ((Get.width - 49) / (4));

  /// Gets trip details from API
  ///
  /// This method is used to get trip details from API.
  /// It takes trip id as parameter and returns trip details.
  /// If request is successfull, it sets [isDataLoaded] to true and
  /// assigns response to [tripDetailsModel].
  /// If request is failed, it shows easy loading and sets [isDataLoaded] to false.
  /// It also calls [changeTabIndex] with current [tabBarIndex] value.
  ///
  /// [isLoader] is used to show loader or not.
  void getTripDetails(bool isLoader) {
    isTripDetailsLoaded.value = false;
    RequestManager.showEasyLoader();
    RequestManager.postRequest(
      uri: EndPoints.getTripDetail,
      hasBearer: true,
      isLoader: false,
      body: {RequestParams.tripId: tripId.toString()},
      isSuccessMessage: false,
      onSuccess: (responseBody, message, status) {
        var tripDetailsData =
            tripDetailsModelFromJson(jsonEncode(responseBody));
        tripDetailsModel = tripDetailsData;
        tripDetailsModel!.responseDeadline =
            tripDetailsModel!.responseDeadline!.toLocal();
        isTripDetailsLoaded.value = true;
        eventNameController.text = tripDetailsModel!.tripName ?? "";
        descController.text = tripDetailsModel!.tripDescription ?? "";
        final descLength = 500 - tripDetailsModel!.tripDescription!.length;
        descCount.value = descLength.toString();
        tCommentController.text = tripDetailsModel!.tripFinalizingComment ?? "";
        selectedCategory.value = tripDetailsModel!.tripFinalCity ?? "";
        itineraryController.text = tripDetailsModel!.itinaryDetails ?? "";
        onDate.value = Date.shared().convertFormatToFormat(
            tripDetailsModel!.responseDeadline!,
            'yyyy-MM-dd hh:mm:ss',
            'yyyy/MM/dd hh:mm:ss');
        onDateUTC = Date.shared().convertFormatToFormat(
            tripDetailsModel!.responseDeadline!.toUtc(),
            'yyyy-MM-dd hh:mm:ss',
            'yyyy/MM/dd hh:mm:ss');
        printMessage(
            "Trip details Dead line local ${onDate.value} utc ${onDateUTC}");
        isSelectedReminder.value = true;
        oldResponseDeadLine = onDate.value;
        maxReminderDays.value = Date.shared().datesDifferenceInDay(
            DateTime.now(), tripDetailsModel!.responseDeadline!);

        noOfReminderDays.value = tripDetailsModel!.reminderDays!;

        isPremiumTrip.value = tripDetailsModel?.isPaid == 0 ? false : true;
        /*selectedReminder.value =
            "${tripDetailsModel!.reminderDays.toString()} days";*/
        selectedTripImage.value =
            getFileNameFromURL(tripDetailsModel!.tripImgUrl ?? "");
        selectedTripImageURL.value = tripDetailsModel!.tripImgUrl ?? "";
        /* for (int i = 0; i < lstReminder.length; i++) {
          if (tripDetailsModel!.reminderDays.toString() ==
              lstReminder[i].daysForApi!) {
            selectedRemainder = lstReminder[i];
          }
        }*/
        //noOfReminderDays.value = tripDetailsModel!.reminderDays!;

        if (tripDetailsModel!.isTripFinalised!) {
          isEditable.value = 2;
        } else {
          if (tripDetailsModel!.role == "Host") {
            isEditable.value = 1;
          } else if (tripDetailsModel!.isCoHost! == 1) {
            if (tripDetailsModel!.inviteStatus == "Approved") {
              isEditable.value = 1;
            } else {
              isEditable.value = 0;
            }
          } else {
            isEditable.value = 0;
          }
        }
        getCities();
        getTripDatePollList(false);
        getTripCityPollList(false);
        getSingleTripPlan();
        if (isLoader) {
          EasyLoading.dismiss();
        }
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  /// Starts a periodic timer to search for cities based on the search text
  /// input by the user. If the search text changes, it cancels the previous
  /// timer and starts a new one to search for cities with the new search text.
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

  /// Calls the API to get the list of cities based on the search text.
  ///
  /// Calls [RequestManager.postRequest] with the [EndPoints.getCities] API,
  /// search text as the body, and no loading indicator. If the request is
  /// successful, it sets [lstCity] with the response body and assigns
  /// [lstCitySearch] with [lstCity]. If the request fails, it shows an
  /// easy loading indicator.
  void getCities() {
    RequestManager.postRequest(
      uri: EndPoints.getCities,
      isLoader: false,
      hasBearer: false,
      body: {RequestParams.searchText: searchCityController.text.toString()},
      onSuccess: (responseBody, message, status) {
        lstCity.value = List<CitiesModel>.from(
            responseBody.map((x) => CitiesModel.fromJson(x)));
        lstCitySearch.value = lstCity;
        printMessage(
            "lstCitySearch ${lstCitySearch.length} - lstCity ${lstCity.length}");
        /*for (var city in lstCitySearch) {
          var cityExistsInEmptyCity =
              lstEmptyCity.any((emptyCity) => city.id == emptyCity.id);
          if (cityExistsInEmptyCity) {
            city.isSelected = true;
          }
        }*/
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  /// Adds selected cities to the trip.
  ///
  /// This method is used to add cities to trip. It shows easy loading,
  /// posts a request to [EndPoints.addCitiesToTrip] with selected cities
  /// and trip id as body, and no loading indicator. If the request is
  /// successful, it clears [lstEmptyCity], sets all cities in [lstCitySearch]
  /// to not selected, and calls [getTripCityPollList] with [isShowLoader] set
  /// to true. If the request fails, it does nothing.
  void addCityToTrip() {
    RequestManager.showEasyLoader();
    var tripCities = lstEmptyCity.map((e) {
      return {
        RequestParams.cityName: e.cityName,
        RequestParams.cityId: e.id,
      };
    }).toList();
    RequestManager.postRequest(
      uri: EndPoints.addCitiesToTrip,
      hasBearer: true,
      isSuccessMessage: true,
      isLoader: false,
      body: {
        RequestParams.tripId: tripId.toString(),
        RequestParams.tripCitiesList: tripCities
      },
      onSuccess: (responseBody, message, status) {
        Get.back();
        lstEmptyCity.clear();
        for (int i = 0; i < lstCitySearch.length; i++) {
          lstCitySearch[i].isSelected = false;
        }
        getTripCityPollList(true);
      },
      onFailure: (error) {},
    );
  }

  /// Adds a new date range to the trip.
  ///
  /// This method adds the selected date range to the list of dates (`lstEmptyDate`) for the trip.
  /// It constructs a list of date objects (`tripDateMap`) by converting the start and end dates
  /// from UTC to local time and formatting them as strings. Then, it sends a request to add these
  /// dates to the trip using the `RequestManager.postRequest` method.
  ///
  /// Upon successful addition, it resets the date range, arrival and departure times, clears the
  /// comment text field, and refreshes the trip date poll list. If the operation fails, it clears
  /// the list of empty dates.

  void onDateAdded() {
    lstEmptyDate.add(MultiDateSelectionModel(
        displayName:
            "${getDays(rangeStart!, rangeEnd!)} - (${getDateString(rangeStart!)} - ${getDateString(rangeEnd!)}), ${getYear(rangeStart!)} ",
        startDate: rangeStart!,
        endDate: rangeEnd!,
        startTime: arriveTime.value,
        endTime: leaveTime.value,
        comment: commentTextEditingController.text));

    var tripDateMap = lstEmptyDate.map((e) {
      var startTempDate = convertUTCtoLocal(
          addTime(e.startDate, e.startTime)); //convert time offset local to UTC
      var endTempDate = convertUTCtoLocal(
          addTime(e.endDate, e.endTime)); //convert time offset local to UTC
      String startDate =
          DateFormat('yyyy/MM/dd HH:mm:ss').format(startTempDate);
      String endDate = DateFormat('yyyy/MM/dd HH:mm:ss').format(endTempDate);
      return {
        RequestParams.startDate: startDate, // "$startDate ${e.startTime}",
        RequestParams.endDate: endDate, //"$endDate ${e.endTime}",
        RequestParams.comment: e.comment
      };
    }).toList();
    RequestManager.postRequest(
      uri: EndPoints.addDatesToTrip,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: true,
      body: {
        RequestParams.tripId: tripId.toString(),
        RequestParams.tripDatesList: tripDateMap
      },
      onSuccess: (responseBody, message, status) {
        rangeStart = null;
        rangeEnd = null;
        arriveTime.value = "HH:MM";
        leaveTime.value = "HH:MM";
        commentTextEditingController.clear();
        lstEmptyDate.clear();
        getTripDatePollList(true);
        Get.back();
      },
      onFailure: (error) {
        lstEmptyDate.clear();
      },
    );
  }

  /// Converts a given date to a string in the format "ddth MMMM" (e.g. "24th December").
  ///
  /// This method uses the `ordinalSuffixOf` and `getMonthNameFromDateTime` methods of the
  /// `Date` class to generate the string representation of the date.
  String getDateString(DateTime date) {
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

  /// Returns the year component of the given [startDate] as a string.
  ///
  /// This method extracts the year from a [DateTime] object using the
  /// `getOnlyYearFromDateTime` method of the `Date` class and returns it
  /// as a string.
  ///
  /// [startDate]: The date from which to extract the year.
  /// 
  /// Returns a string representation of the year.

  String getYear(DateTime startDate) {
    return Date.shared().getOnlyYearFromDateTime(startDate);
  }

  /// Gets the list of trip date polls from the server.
  ///
  /// This method takes a boolean parameter [isShowLoader] which determines whether to show a
  /// loading dialog or not. If [isShowLoader] is true, it shows the loading dialog and sends a
  /// request to the server to get the trip date polls. If the request is successful, it
  /// converts the start and end dates of each poll to local time and assigns the response to
  /// [lstTripDatePoll]. It also sets [restorationId] with a random string. If the request
  /// fails, it shows an error message.
  void getTripDatePollList(bool isShowLoader) {
    if (isShowLoader) {
      RequestManager.showEasyLoader();
    }
    RequestManager.postRequest(
      uri: EndPoints.getDatesPollDetails,
      hasBearer: true,
      isLoader: false,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: {RequestParams.tripId: tripId.toString()},
      onSuccess: (responseBody, message, status) {
        tripSelectedDatesPollTemp.clear();
        lstTripDatePoll.value = List<TripDetailsDatePollModel>.from(
            responseBody.map((x) => TripDetailsDatePollModel.fromJson(x)));
        if (lstTripDatePoll.isNotEmpty) {
          for (var element in lstTripDatePoll.value) {
            printMessage("Trip Details Date UTC ${element.startDate} Local ${element.startDate!.toLocal()}");
            element.startDate = element.startDate!.toLocal();
            element.endDate = element.endDate!.toLocal();
            if (element.userVoted == 1) {
              tripSelectedDatesPollTemp.add(element.id!);
            }
          }
          if (isEditable.value == 1 && tripSelectedDatesPollTemp.length > 1) {
            for (var element in lstTripDatePoll.value) {
              element.userVoted = 0;
            }
            tripSelectedDatesPollTemp.clear();
          }
        }
        restorationId.value = getRandomString();
        if (isShowLoader) {
          EasyLoading.dismiss();
        }
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  /// Checks whether [date1] is before [date2].
  ///
  /// This method is used to compare two dates and returns true if [date1] is
  /// before [date2], otherwise it returns false.
  bool isDate1BeforeDate2(DateTime date1, DateTime date2) {
    return date1.isBefore(date2);
  }

  /// Checks whether the response deadline date is valid or not.
  ///
  /// This method takes into account the following conditions to validate the response deadline date:
  /// 1. The date should not be before the current date.
  /// 2. The date should not be the same as the old response deadline date.
  /// 3. The date should not be before any of the dates in the trip date poll.
  /// If any of these conditions are not met, the method returns false. Otherwise, it returns true.
  bool checkResponseDeadLine() {
    printMessage(
        "Check response deadline date size ${lstTripDatePoll.length} date ${onDate.value}");
    printMessage("Old date $oldResponseDeadLine New date ${onDate.value}");
    if (oldResponseDeadLine == onDate.value) {
      return true;
    }
    if (DateTime.parse(onDate.value.replaceAll('/', '-')).isBefore(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      return false;
    }
    for (int i = 0; i < lstTripDatePoll.length; i++) {
      if (lstTripDatePoll[i].isDefault != 1) {
        DateTime date1 = DateTime.parse(onDate.value.replaceAll('/', '-'));
        DateTime date2 = DateTime(
            lstTripDatePoll[i].startDate!.year,
            lstTripDatePoll[i].startDate!.month,
            lstTripDatePoll[i].startDate!.day);
        if (!isDate1BeforeDate2(date1, date2)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Compares two lists and returns true if they contain the same elements, false otherwise.
  ///
  /// The lists are compared by converting them to sets and then checking if the two sets
  /// have the same length and if the first set contains all the elements of the second set.
  ///
  bool compareArrays(List<dynamic> array1, List<dynamic> array2) {
    Set<dynamic> set1 = Set.from(array1);
    Set<dynamic> set2 = Set.from(array2);
    printMessage(array1);
    printMessage(array2);
    return set1.length == set2.length && set1.containsAll(set2);
  }

  /// Updates the user's invitation status.
  ///
  /// This method handles updating the invitation status of a user. If the
  /// status is approved, it checks user's selections for trip dates and 
  /// cities. If either the date or city selection is empty, it shows an 
  /// appropriate message and scrolls to the relevant section. Otherwise, 
  /// it proceeds to call the API to update the user status with the given 
  /// invitation status. If the status is not approved, it directly calls 
  /// the API to update the user status.

  void updateUserStatus(String invitationStatus) {
    printMessage(invitationStatus);
    if (invitationStatus == InvitationAcceptReject.approved) {
      List<int> currentSelectionDate = [];
      for (var item in lstTripDatePoll) {
        if (item.userVoted == 1) {
          currentSelectionDate.add(item.id!);
        }
      }
      List<int> currentSelectionCity = [];
      for (var item in lstTripDetailsCityPoll) {
        if (item.userVoted == 1) {
          currentSelectionCity.add(item.id!);
        }
      }
      if (currentSelectionDate.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripDate.tr,
        );
        scrollToContainer(listGlobalKey[1]);
      } else if (currentSelectionCity.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripCity.tr,
        );
        scrollToContainer(listGlobalKey[0]);
      } else {
        updateUserStatusApiCall(invitationStatus);
      }
    } else {
      updateUserStatusApiCall(invitationStatus);
    }
  }

  /// Updates user status via API.
  ///
  /// This method sends a POST request to the [EndPoints.actionOnInvitation]
  /// endpoint with the specified [invitationStatus] to update the user's
  /// invitation status for a trip. If the [invitationStatus] is approved,
  /// it checks current date selections and adds them if they differ from
  /// previously selected dates, otherwise it compares city poll selections.
  /// If the status is not approved, it simply navigates back.
  /// Displays appropriate success or failure messages based on the response.

  void updateUserStatusApiCall(String invitationStatus) {
    RequestManager.postRequest(
      uri: EndPoints.actionOnInvitation,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: {
        RequestParams.tripId: tripId.toString(),
        RequestParams.status: invitationStatus,
      },
      onSuccess: (responseBody, message, status) {
        printMessage("Invitation status: $invitationStatus");
        if (invitationStatus == InvitationAcceptReject.approved) {
          //for date
          printMessage("In If condition");
          List<int> currentSelection = [];
          for (var item in lstTripDatePoll) {
            if (item.userVoted == 1) {
              currentSelection.add(item.id!);
            }
          }
          if (!compareArrays(tripSelectedDatesPollTemp, currentSelection)) {
            addDatePoll(currentSelection);
          } else {
            compareCityPoll();
          }
        } else {
          Get.back();
        }
      },
      onFailure: (error) {},
    );
  }

  /// Compares current city poll selections with previously stored selections.
  ///
  /// If the selections have changed, it calls [addCityPoll] to add the new
  /// selections to the database. Otherwise, it navigates back.
  void compareCityPoll() {
    //for cities
    List<int> currentSelectionCity = [];
    for (var item in lstTripDetailsCityPoll) {
      if (item.userVoted == 1) {
        currentSelectionCity.add(item.id!);
      }
    }
    if (!compareArrays(tripSelectedCitiesPollTemp, currentSelectionCity)) {
      addCityPoll(currentSelectionCity);
    } else {
      Get.back();
    }
  }

  /// Adds the given list of date poll IDs to the database for the current trip.
  ///
  /// This method sends a POST request to the [EndPoints.addDatePoll] endpoint
  /// with the given list of date poll IDs and the current trip ID.
  /// If the request is successful, it calls [compareCityPoll] to compare current
  /// city poll selections with previously stored selections. If the request fails,
  /// it also calls [compareCityPoll].
  void addDatePoll(List<int> tripDatesList) {
    RequestManager.postRequest(
      uri: EndPoints.addDatePoll,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: {
        RequestParams.tripId: tripId.toString(),
        RequestParams.tripDatesListId: tripDatesList.toList(),
        RequestParams.isSelected: true,
      },
      onSuccess: (responseBody, message, status) {
        printMessage("Sdfsdfjhb");
        compareCityPoll();
        //getTripDatePollList(true);
      },
      onFailure: (error) {
        compareCityPoll();
      },
    );
  }

  /// Gets city poll details from API.
  ///
  /// This method is used to get city poll details associated with the current trip.
  /// It takes a boolean parameter [isShowLoader] which determines whether to show
  /// a loading dialog or not. If [isShowLoader] is true, it shows the loading dialog
  /// and sends a request to the server to get the city poll details. If the request
  /// is successful, it converts the start and end dates of each poll to local time
  /// and assigns the response to [lstTripDetailsCityPoll]. It also sets
  /// [restorationIdCity] with a random string. If the request fails, it shows an
  /// error message.
  void getTripCityPollList(bool isShowLoader) {
    if (isShowLoader) {
      RequestManager.showEasyLoader();
    }
    RequestManager.postRequest(
      uri: EndPoints.getCityPollDetails,
      hasBearer: true,
      isLoader: false,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: {RequestParams.tripId: tripId.toString()},
      onSuccess: (responseBody, message, status) {
        tripSelectedCitiesPollTemp.clear();
        lstTripDetailsCityPoll.value = List<TripDetailsCityPollModel>.from(
            responseBody.map((x) => TripDetailsCityPollModel.fromJson(x)));
        if (lstTripDetailsCityPoll.isNotEmpty) {
          for (var element in lstTripDetailsCityPoll.value) {
            if (element.userVoted == 1) {
              tripSelectedCitiesPollTemp.add(element.id!);
            }
          }
          if (isEditable.value == 1 && tripSelectedCitiesPollTemp.length > 1) {
            for (var element in lstTripDetailsCityPoll.value) {
              element.userVoted = 0;
            }
            tripSelectedCitiesPollTemp.clear();
          }
        }
        if (isShowLoader) {
          EasyLoading.dismiss();
        }
        restorationIdCity.value = getRandomString();
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  /// Gets single trip plan from API.
  ///
  /// This method sends a POST request to the [EndPoints.getPlans] endpoint.
  /// It shows an easy loader while the request is in progress.
  /// If the request is successful, it updates the [lstSinglePlan] with the response
  /// data and dismisses the easy loader.
  /// If the request fails, it dismisses the easy loader.
  void getSingleTripPlan() {
    RequestManager.postRequest(
      uri: EndPoints.getPlans,
      hasBearer: true,
      isLoader: false,
      body: {RequestParams.type: PlanType.singlePlan},
      onSuccess: (responseBody, message, status) {
        lstSinglePlan.value = List<SinglePlanModel>.from(
            responseBody.map((x) => SinglePlanModel.fromJson(x)));
        EasyLoading.dismiss();
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  /// Adds the given list of city poll IDs to the database for the current trip.
  ///
  /// This method sends a POST request to the [EndPoints.addCityPoll] endpoint
  /// with the given list of city poll IDs, the current trip ID, and selected
  /// status as true.
  /// If the request is successful, it calls [getTripCityPollList] with [isShowLoader]
  /// set to true and navigates back. If the request fails, it navigates back.
  void addCityPoll(List<int> tripCityList) {
    RequestManager.postRequest(
      uri: EndPoints.addCityPoll,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: {
        RequestParams.tripId: tripId.toString(),
        RequestParams.tripCityListId: tripCityList.toList(),
        RequestParams.isSelected: true,
      },
      onSuccess: (responseBody, message, status) {
        getTripCityPollList(true);
        Get.back();
      },
      onFailure: (error) {
        Get.back();
      },
    );
  }

/// Updates the time for the selected date by host.
///
/// This method updates either the start date or end date of the selected
/// date by host with a new time specified by [timeString]. If [isStartDate]
/// is true, the start date's time is updated; otherwise, the end date's
/// time is updated. It prints the updated start and end dates.

  void updateTimeForFinalizingDate(bool isStartDate, TimeOfDay timeString) {
    if (isStartDate) {
      final startDate = DateTime(
          selectedDateByHost!.startDate!.year,
          selectedDateByHost!.startDate!.month,
          selectedDateByHost!.startDate!.day,
          timeString.hour,
          timeString.minute);
      selectedDateByHost!.startDate = startDate;
    } else {
      final endDate = DateTime(
          selectedDateByHost!.endDate!.year,
          selectedDateByHost!.endDate!.month,
          selectedDateByHost!.endDate!.day,
          timeString.hour,
          timeString.minute);
      selectedDateByHost!.endDate = endDate;
    }
    printMessage("Start Date: ${selectedDateByHost!.startDate}");
    printMessage("End Date: ${selectedDateByHost!.endDate}");
  }

  /// Saves the trip details to the database.
  ///
  /// This method sends a POST request to the [EndPoints.saveFinalTrip] endpoint
  /// with the current trip ID, whether the trip is finalised, the trip name,
  /// description, itinerary, response deadline, reminder days, and trip image URL.
  /// If the request is successful, it updates the trip details in Firebase and
  /// calls [getTripDetails] with [isShowLoader] set to false. If the request fails,
  /// it does nothing.
  void saveFinalTrip() {
    /*final startDate = selectedDateByHost != null
        ? Date.shared().convertFormatToFormat(selectedDateByHost!.startDate!,
            'yyyy-MM-dd hh:mm:ss.sss', 'yyyy/MM/dd hh:mm:ss')
        : null;
    final endDate = selectedDateByHost != null
        ? Date.shared().convertFormatToFormat(selectedDateByHost!.endDate!,
            'yyyy-MM-dd hh:mm:ss.sss', 'yyyy/MM/dd hh:mm:ss')
        : null;*/
    final body = {
      RequestParams.tripId: tripId.toString(),
      RequestParams.isTripFinalised: isTripToFinalised.value,
      RequestParams.tripFinalizingComments: "",
      RequestParams.tripName: eventNameController.text,
      RequestParams.tripDescription: descController.text,
      RequestParams.itinaryDetails: itineraryController.text,
      //RequestParams.responseDeadline: onDate.value,
      RequestParams.responseDeadline: onDateUTC,
      RequestParams.reminderDays: noOfReminderDays.value,
      RequestParams.tripImgUrl: getFileNameFromURL(selectedTripImageURL.value),
      /*RequestParams.tripFinalStartDate: startDate,
      RequestParams.tripFinalEndDate: endDate,
      RequestParams.tripFinalCityId: selectedTripCityByHost!.cityId ?? "",*/
    };
    RequestManager.postRequest(
      uri: EndPoints.saveFinalTrip,
      hasBearer: true,
      isSuccessMessage: true,
      isFailedMessage: true,
      isLoader: true,
      body: body,
      onSuccess: (responseBody, message, status) {
        // Update in Firebase
        selectedDateByHost = null;
        selectedTripCityByHost = null;
        getGroupData(eventNameController.text, selectedTripImageURL.value, () {
          getTripDetails(false);
        });
      },
      onFailure: (error) {},
    );
  }

  /// Finalizes a trip.
  ///
  /// This method is called when the user presses the "Finalize Trip" button.
  /// It takes the current trip details, including the trip name, description,
  /// itinerary, response deadline, and trip image and sends them to the server
  /// to finalize the trip. It also takes the trip final start date, end date,
  /// and city id and sends them to the server.
  ///
  /// The method also hides the keyboard and shows an easy loader.
  ///
  /// If the request is successful, it calls the [getGroupData] method to
  /// update the UI and then dismisses the easy loader and pops the current
  /// screen.
  ///
  /// If the request fails, it prints an error message and dismisses the easy
  /// loader.
  void finalizeTrip() {
    Get.focusScope?.unfocus();
    hideKeyboard();
    RequestManager.showEasyLoader();
    final startDate = Date.shared().convertFormatToFormat(
        selectedDateByHost!.startDate!,
        'yyyy-MM-dd hh:mm:ss.sss',
        'yyyy/MM/dd hh:mm:ss');
    final endDate = Date.shared().convertFormatToFormat(
        selectedDateByHost!.endDate!,
        'yyyy-MM-dd hh:mm:ss.sss',
        'yyyy/MM/dd hh:mm:ss');
    final body = {
      RequestParams.tripId: tripId.toString(),
      RequestParams.isTripFinalised: isTripToFinalised.value,
      RequestParams.tripFinalizingComments: tCommentController.text,
      RequestParams.tripName: eventNameController.text,
      RequestParams.tripDescription: descController.text,
      RequestParams.itinaryDetails: itineraryController.text,
      //RequestParams.responseDeadline: onDate.value,
      RequestParams.responseDeadline: onDateUTC,
      RequestParams.reminderDays: noOfReminderDays.value,
      RequestParams.tripImgUrl: getFileNameFromURL(selectedTripImageURL.value),
      RequestParams.tripFinalStartDate: startDate,
      RequestParams.tripFinalEndDate: endDate,
      RequestParams.tripFinalCityId: selectedTripCityByHost!.cityId!,
    };
    printMessage("body: $body");
    RequestManager.postRequest(
      uri: EndPoints.saveFinalTrip,
      hasBearer: true,
      isSuccessMessage: true,
      isFailedMessage: true,
      isLoader: false,
      body: body,
      onSuccess: (responseBody, message, status) {
        // Update in Firebase
        getGroupData(eventNameController.text, selectedTripImageURL.value, () {
          printMessage("then method called");
          EasyLoading.dismiss();
          Get.back();
        });
      },
      onFailure: (error) {
        printMessage(error);
        EasyLoading.dismiss();
      },
    );
  }

  /// Deletes a trip.
  ///
  /// This method is called when the user presses the "Delete Trip" button.
  /// It sends a POST request to the [EndPoints.deleteTrip] endpoint
  /// with the current trip ID.
  /// If the request is successful, it deletes the trip document from Firebase
  /// and dismisses the easy loader.
  /// If the request fails, it dismisses the easy loader.
  void deleteTrip() {
    RequestManager.showEasyLoader();
    RequestManager.postRequest(
      uri: EndPoints.deleteTrip,
      hasBearer: true,
      isLoader: false,
      isSuccessMessage: true,
      isFailedMessage: true,
      body: {RequestParams.tripId: tripId},
      onSuccess: (responseBody, message, status) {
        //printMessage(responseBody);
        FirebaseFirestore.instance
            .collection(FireStoreCollection.tripGroupCollection)
            .doc(tripId.toString())
            .delete()
            .then((value) {
          // Get.back();
          EasyLoading.dismiss();
        });
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  /// Opens a subscription bottom sheet with a single trip plan.
  ///
  /// If the user is a host, it navigates to the subscription plan screen.
  /// If the user is a guest, it shows a bottom sheet with the single trip plan
  /// details. If there are no single trip plans available, it shows a snackbar
  /// with a message saying "No plans found".
  void openSubscriptionBottomSheet(
      {required SingleTripPlanModel singleTripPlanModel}) {
    if (tripDetailsModel?.role == 'Host') {
      Get.toNamed(Routes.SUBSCRIPTION_PLAN_SCREEN)
          ?.then((value) => getTripDetails(true));
    } else {
      if (lstSinglePlan.isNotEmpty) {
        Get.bottomSheet(
            isScrollControlled: true,
            ignoreSafeArea: true,
            BottomSheetWithClose(
              widget: planBottomSheet(
                singleTripPlanModel: singleTripPlanModel,
              ),
              titleWidget: Text(
                singleTripPlanModel.title,
                textAlign: TextAlign.center,
                style: onBackgroundTextStyleSemiBold(
                    fontSize: AppDimens.textLarge),
              ),
            )
            /*planBottomSheet(
          singleTripPlanModel: singleTripPlanModel,
        ),*/
            );
      } else {
        RequestManager.getSnackToast(message: LabelKeys.noPlansFound.tr);
      }
    }
  }

  Widget planBottomSheet({required SingleTripPlanModel singleTripPlanModel}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SubscriptionWidget(
          singleTripPlan: lstSingleTripPlanModel,
          singleTripPlanModel: singleTripPlanModel,
          singlePlanModel: lstSinglePlan[0],
          onUnlockTripTap: () {
            RequestManager.showEasyLoader();
            payPalCallBackMethods();
            PayPalPayment.makePayment(
              amount: double.parse(lstSinglePlan[0].discountedPrice!),
            );
            //
          },
        );
      },
    );
  }

  /// Sets callbacks for PayPal payment service.
  ///
  /// This method sets callbacks for the PayPal payment service. The callbacks
  /// are called when the user cancels the payment, when the payment is successful,
  /// or when there is an error with the payment. The callbacks are also called
  /// when the shipping address is changed.
  ///
  /// The callbacks are set using the [FPayPalOrderCallback] class, which provides
  /// a set of methods that can be overridden to handle the different callback
  /// events. The callbacks are called with a [FPayPalApprovalData] object as an
  /// argument, which contains the result of the payment.
  void payPalCallBackMethods() {
    //call backs for payment
    PayPalPayment.flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          EasyLoading.dismiss();
        },
        onSuccess: (data) {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          purchasePlanAPI(data);
        },
        onError: (data) {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          EasyLoading.dismiss();
          RequestManager.getSnackToast(message: data.reason);
        },
        onShippingChange: (data) {
          EasyLoading.dismiss();
          RequestManager.getSnackToast(
              message: data.shippingChangeAddress?.adminArea1 ?? "");
        },
      ),
    );
  }

  /// Makes a request to the server to purchase a plan.
  ///
  /// This method takes the payment data from PayPal and makes a POST request to the
  /// [EndPoints.purchasePlan] endpoint to purchase a plan. If the request is successful,
  /// it navigates back to the trip list screen and refreshes the trip details.
  /// If the request fails, it does nothing.
  ///
  /// The [data] parameter is the payment data from PayPal.
  void purchasePlanAPI(FPayPalApprovalData data) {
    RequestManager.postRequest(
      uri: EndPoints.purchasePlan,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: true,
      body: {
        RequestParams.planType: PlanType.singlePlan,
        RequestParams.planId: lstSinglePlan[0].id,
        RequestParams.price: lstSinglePlan[0].price,
        RequestParams.tripID: tripDetailsModel!.id,
        RequestParams.transactionId: data.orderId,
        RequestParams.paymentThrough: 'paypal',
      },
      onSuccess: (responseBody, message, status) {
        Get.back();
        getTripDetails(true);
      },
      onFailure: (error) {},
    );
  }

  
  /// Creates a new calendar on the device if it does not exist.
  ///
  /// This method requests permission to access the device's calendars and
  /// then checks if a calendar named "Its Go Time Event" exists. If it does
  /// not exist, it creates a new calendar with that name. The calendar color
  /// is set to the primary color of the app and the local account name is set
  /// to the first name of the user.
  ///
  /// If the calendar exists, it retrieves the ID of the calendar.
  /// After creating the calendar or retrieving the ID, it calls the
  /// [getCurrentLocation] method to get the current location of the user.
  ///
  void createCalendar() async {
    var permissionsGranted = await deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess &&
        (permissionsGranted.data == null || permissionsGranted.data == false)) {
      permissionsGranted = await deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess ||
          permissionsGranted.data == null ||
          permissionsGranted.data == false) {
        return;
      }
    }
    //  retrieveCalendar();
    List<Calendar> calendars = [];
    final calendarsResult = await deviceCalendarPlugin.retrieveCalendars();
    calendars = calendarsResult.data as List<Calendar>;

    if (calendars.isNotEmpty) {
      for (int i = 0; i < calendars.length; i++) {
        printMessage(
            "Checking calendar: ${calendars[i].name} - ${calendars[i].accountName}  FirstName: ${gc.loginData.value.firstName}");
        if (calendars[i].name == "Its Go Time Event") {
          calenderId = calendars[i].id;
          //deleteCalendar(calenderId);
          printMessage("User found");
        }
      }
      printMessage("calenderId from not empty : $calenderId");
    }
    if (calenderId == null) {
      var calenderData = await deviceCalendarPlugin.createCalendar(
        LabelKeys.itsGoTimeEvent.tr,
        calendarColor: Get.theme.colorScheme.primary,
        localAccountName: gc.loginData.value.firstName,
      );
      calenderId = calenderData.data;
      printMessage("calenderId from empty : $calenderId");
    }
    getCurrentLocation();
  }

  String timeZoneName = 'Etc/UTC';
  late Location? currentLocation;

  /// Gets the current location of the user.
  ///
  /// It first tries to get the local timezone using [FlutterNativeTimezone].
  /// If it fails, it shows a toast with the message "Unable to add trip".
  /// Then it gets the [Location] object from the [timeZoneDatabase] map using
  /// the local timezone name as the key.
  /// Finally it calls the [createEvent] method to create the event.
  void getCurrentLocation() async {
    try {
      timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      RequestManager.getSnackToast(message: LabelKeys.unableAddTrip.tr);
      printMessage('Could not get the local timezone');
    }
    currentLocation = timeZoneDatabase.locations[timeZoneName];
    createEvent();
    printMessage('currentLocation $currentLocation');
  }

  TZDateTime getTzDateTime(DateTime datetime) {
    DateTime dateTime = datetime;
    /*String dateTimes = Date.shared().convertFormatToFormat(
        dateTime, "yyyy-MM-dd hh:mm:ss", "dd MMM yyyy HH:mm");*/
    return TZDateTime(
      currentLocation!,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }

  // To add event to calender
  /// Adds a trip to the user's device calendar.
  ///
  /// If the platform is Android, it first tries to retrieve the events from the
  /// calendar with the given [calenderId] and [RetrieveEventsParams] that
  /// matches the trip's start and end dates. If the event does not exist, it
  /// creates the event in the calendar. If the event exists, it shows a toast
  /// with the message "Trip already exists".
  ///
  /// If the platform is iOS, it does the same as in Android, but it uses the
  /// [TZDateTime] objects as the start and end dates of the [RetrieveEventsParams].
  void createEvent() async {
    if (Platform.isAndroid) {
      Event event = Event(calenderId,
          title: tripDetailsModel?.tripName,
          start: getTzDateTime(tripDetailsModel!.tripFinalStartDate!),
          end: getTzDateTime(tripDetailsModel!.tripFinalEndDate!));

      RetrieveEventsParams retrieveEventsParams = RetrieveEventsParams(
          startDate: tripDetailsModel!.tripFinalStartDate!,
          endDate: tripDetailsModel!.tripFinalEndDate!);

      var queryResults = await deviceCalendarPlugin.retrieveEvents(
          calenderId, retrieveEventsParams);
      printMessage("queryResults: ${queryResults.data}");
      if (queryResults.data!.isEmpty) {
        var createEventResult =
            await deviceCalendarPlugin.createOrUpdateEvent(event);
        if (createEventResult?.isSuccess == true) {
          RequestManager.getSnackToast(
              message: LabelKeys.tripAddedSuccessfully.tr);
        } else {
          RequestManager.getSnackToast(
              message: createEventResult?.errors
                  .map((err) => '[${err.errorCode}] ${err.errorMessage}')
                  .join(' | ') as String);
        }
      } else {
        RequestManager.getSnackToast(message: LabelKeys.tripAlreadyExists.tr);
      }
    }
    if (Platform.isIOS) {
      Event event = Event(calenderId,
          title: tripDetailsModel?.tripName,
          start: getTzDateTime(tripDetailsModel!.tripFinalStartDate!),
          end: getTzDateTime(tripDetailsModel!.tripFinalEndDate!));

      RetrieveEventsParams retrieveEventsParams = RetrieveEventsParams(
          startDate: getTzDateTime(tripDetailsModel!.tripFinalStartDate!),
          endDate: getTzDateTime(tripDetailsModel!.tripFinalEndDate!));

      var queryResults = await deviceCalendarPlugin.retrieveEvents(
          calenderId, retrieveEventsParams);

      printMessage("queryResults: ${queryResults.data}");
      if (queryResults.data!.isEmpty) {
        var createEventResult =
            await deviceCalendarPlugin.createOrUpdateEvent(event);
        if (createEventResult?.isSuccess == true) {
          RequestManager.getSnackToast(
              message: LabelKeys.tripAddedSuccessfully.tr);
        } else {
          RequestManager.getSnackToast(
              message: createEventResult?.errors
                  .map((err) => '[${err.errorCode}] ${err.errorMessage}')
                  .join(' | ') as String);
        }
      } else {
        RequestManager.getSnackToast(message: LabelKeys.tripAlreadyExists.tr);
      }
    }
  }

  // To delete calendar
  /// Delete a calendar with the given [calenderId].
  ///
  /// This is a destructive operation and cannot be undone.
  ///
  /// If the calendar does not exist, this is a no-op.
  ///
  /// Returns a boolean indicating whether the calendar was deleted.
  ///
  /// Throws a [PlatformException] if something goes wrong.
  void deleteCalendar(String? calenderId) async {
    var result = await deviceCalendarPlugin.deleteCalendar(calenderId!);
    printMessage("DELETE CALENDAR ${result.data}");
  }

  // To add plan details static data
  /// To add plan details static data
  ///
  /// This method is used to add premium features list.
  void addPlanDetailsData() {
    lstSingleTripPlanModel = Constants.getSingleTripPlanList();
  }

  //To add reminder list static data
  /// To add reminder list static data
  ///
  /// This method is used to add the list of reminders which are shown in the
  /// reminder list of the trip creation screen. The list is fetched from the
  /// [Constants.getReminderDaysList()] method.
  void addReminderListData() {
    lstReminder = Constants.getReminderDaysList();
  }

  /// Updates PayPal and Venmo usernames via an API call.
  ///
  /// This method sends a POST request to the [EndPoints.updateUsernames] endpoint
  /// with the PayPal and Venmo usernames from their respective controllers.
  /// If the request is successful, it updates the user data in the preferences,
  /// clears the username input fields, and navigates to the
  /// [Routes.EXPANSE_RESOLUTION_TABS] screen, passing the trip details model id
  /// as an argument. In the case of an error, it logs the error message.

  void updatePaypalVenmoUsernameApi() {
    RequestManager.postRequest(
        uri: EndPoints.updateUsernames,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {
          RequestParams.paypalUsername: paypalUsernameController.text,
          RequestParams.venmoUsername: venmoUsernameController.text
        },
        onSuccess: (responseBody, message, status) {
          if (status) {
            var userModel =
                userDataFromJson(jsonEncode(responseBody['userData']));
            Preference.setLoginResponse(userModel);
            paypalUsernameController.clear();
            venmoUsernameController.clear();
            Get.toNamed(Routes.EXPANSE_RESOLUTION_TABS,
                arguments: [tripDetailsModel?.id]);
          }
        },
        onFailure: (error) {
          printMessage("error: $error");
        });
  }

  /// Increments or decrements the number of reminder days based on the value of
  /// the [add] parameter.
  ///
  /// If [add] is true, the [noOfReminderDays] is incremented by 1 if it is less
  /// than the [maxReminderDays] value. Otherwise, a toast message showing the
  /// [LabelKeys.maximumLimitReached] string is displayed.
  ///
  /// If [add] is false, the [noOfReminderDays] is decremented by 1 if it is
  /// greater than 0.
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

  /// Handles the finalize button click event.
  ///
  /// This method validates the form and checks several conditions to determine
  /// if the trip can be finalized. If the form is valid, it checks if the date,
  /// image URL, final date, and city are selected. If any of these are missing,
  /// it displays a toast message with the appropriate error message and scrolls
  /// to the relevant section of the form. If all conditions are satisfied, it
  /// displays a success bottom sheet. If the form is not valid, it checks for
  /// specific comment errors and scrolls to the comment section if necessary.

  void finalizeButtonClick() {
    //Get.focusScope?.unfocus();
    isTripToFinalised.value = 1;
    if (formKey.currentState!.validate()) {
      printMessage("if part");
      if (onDate.value == "Select Date") {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripResponseDeadline.tr,
        );
      } else if (selectedTripImageURL.value.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripDisplayImage.tr,
        );
      } else if (selectedDateByHost == null) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripFinalDate.tr,
        );
        scrollToContainer(listGlobalKey[1]);
      } else if (selectedTripCityByHost == null) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripFinalCity.tr,
        );
        scrollToContainer(listGlobalKey[0]);
      } else {
        Get.bottomSheet(
          isScrollControlled: true,
          BottomSheetWithClose(widget: successBottomSheet()),
        );
      }
    } else {
      printMessage("else part ${tCommentNode.hasFocus}");
      if (isTripFinalizingCommentError) {
        scrollToContainer(listGlobalKey[2]);
      }
    }
  }

  // Function to scroll to the container's position
  /// Ensures that the widget identified by [globalKey] is visible by scrolling to
  /// it if necessary.
  ///
  /// The scrolling is animated and takes one second. The widget is scrolled to
  /// the middle of the screen.
  void scrollToContainer(GlobalKey globalKey) {
    Scrollable.ensureVisible(globalKey.currentContext!,
        duration: const Duration(seconds: 1), // duration for scrolling time
        alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
        curve: Curves.easeInOutCubic);
  }

/// Displays a bottom sheet with trip details and a confirmation button.
///
/// This widget presents a column layout containing an icon, various trip details
/// such as start date, end date, and city name, and a note related to the trip.
/// The bottom of the sheet includes an "OK" button which, when pressed, finalizes
/// the trip and closes the bottom sheet.

  Widget successBottomSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppDimens.paddingLarge.ph,
        SvgPicture.asset(IconPath.locationTripIcon),
        AppDimens.paddingLarge.ph,
        Text(
          LabelKeys.readyCities.tr,
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingMedium.ph,
        Text(
          "${LabelKeys.tripStartDate.tr} ${Date.shared().convertFormatToFormat(selectedDateByHost!.startDate!, 'yyyy-MM-dd hh:mm:ss.sss', 'dd MMM yyyy hh:mm a')}",
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingSmall.ph,
        Text(
          "${LabelKeys.tripEndDate.tr} ${Date.shared().convertFormatToFormat(selectedDateByHost!.endDate!, 'yyyy-MM-dd hh:mm:ss.sss', 'dd MMM yyyy hh:mm a')}",
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingSmall.ph,
        Text(
          "${LabelKeys.tripCity.tr} ${selectedTripCityByHost!.cityNameDetails?.cityName!}",
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingMedium.ph,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: Text(
            LabelKeys.noteTrip.tr,
            style: onBackgroundTextStyleRegular(
                fontSize: AppDimens.textLarge, alpha: Constants.lightAlfa),
            textAlign: TextAlign.center,
          ),
        ),
        AppDimens.paddingLarge.ph,
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
            child: MasterButtonsBounceEffect.gradiantButton(
              btnText: LabelKeys.ok.tr,
              onPressed: () {
                finalizeTrip();
                Get.back();
              },
            )),
        AppDimens.padding3XLarge.ph,
      ],
    );
  }

  /// Save trip button click event handler.
  ///
  /// This function is invoked when the user clicks the "Save" button on the trip
  /// detail screen. It validates the form, checks for a valid response deadline,
  /// and ensures a trip display image is selected. If all these checks pass,
  /// then the trip is saved. Otherwise, a toast message is displayed with an
  /// appropriate error message.
  void saveButtonClicked() {
    isTripToFinalised.value = 0;
    if (formKey.currentState!.validate()) {
      if (onDate.value == "Select Date") {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripResponseDeadline.tr,
        );
      } else if (!checkResponseDeadLine()) {
        RequestManager.getSnackToast(
          message: LabelKeys.validTripResponseDeadline.tr,
        );
      } else if (selectedTripImageURL.value.isEmpty) {
        RequestManager.getSnackToast(
          message: LabelKeys.cBlankTripDisplayImage.tr,
        );
      } else {
        saveFinalTrip();
      }
    }
  }

  /// Updates the group name and image in the Firestore database.
  ///
  /// This method first fetches the document from Firestore and checks if it
  /// exists. If it does, it creates a new map with the updated group name and
  /// image, and then updates the document with the new data. If the document
  /// does not exist, it prints a message indicating that the document does not
  /// exist.
  ///
  /// Parameters:
  /// - [name]: The new group name.
  /// - [imageUrl]: The new group image URL.
  /// - [onThen]: A callback function that is called after the document has
  ///   been updated.
  void getGroupData(String name, String imageUrl, Function onThen) {
    FirebaseFirestore.instance
        .collection(FireStoreCollection.tripGroupCollection)
        .doc(tripId.toString())
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        // Create a copy of the original data with the updated groupName
        final updatedData = {
          ...data,
          "groupData": {
            ...data["groupData"],
            "groupName": name,
            "groupImage": imageUrl,
          },
        };

        FirebaseFirestore.instance
            .collection(FireStoreCollection.tripGroupCollection)
            .doc(tripId.toString())
            .update(updatedData)
            .then((value) {
          onThen();
        });

        printMessage("Groupname: ${data['groupData']["groupName"]}");
      } else {
        EasyLoading.dismiss();
        printMessage('Document does not exist');
      }
    });
  }
}
