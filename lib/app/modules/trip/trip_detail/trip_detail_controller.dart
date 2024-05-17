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
  void onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    FireStoreServices.checkIfTripExists(tripId: tripId.toString());
    getTripDetails(true);
    addPlanDetailsData();
    addReminderListData();
    tripDetailController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  getWidth() => ((Get.width - 49) / (4));

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

  String getDateString(DateTime date) {
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

  bool isDate1BeforeDate2(DateTime date1, DateTime date2) {
    return date1.isBefore(date2);
  }

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

  bool compareArrays(List<dynamic> array1, List<dynamic> array2) {
    Set<dynamic> set1 = Set.from(array1);
    Set<dynamic> set2 = Set.from(array2);
    printMessage(array1);
    printMessage(array2);
    return set1.length == set2.length && set1.containsAll(set2);
  }

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

  // To create calendar
  createCalendar() async {
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
  createEvent() async {
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
  deleteCalendar(String? calenderId) async {
    var result = await deviceCalendarPlugin.deleteCalendar(calenderId!);
    printMessage("DELETE CALENDAR ${result.data}");
  }

  // To add plan details static data
  void addPlanDetailsData() {
    lstSingleTripPlanModel = Constants.getSingleTripPlanList();
  }

  //To add reminder list static data
  void addReminderListData() {
    lstReminder = Constants.getReminderDaysList();
  }

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
  void scrollToContainer(GlobalKey globalKey) {
    Scrollable.ensureVisible(globalKey.currentContext!,
        duration: const Duration(seconds: 1), // duration for scrolling time
        alignment: .5, // 0 mean, scroll to the top, 0.5 mean, half
        curve: Curves.easeInOutCubic);
  }

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
