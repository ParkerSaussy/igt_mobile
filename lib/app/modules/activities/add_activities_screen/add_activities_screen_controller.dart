import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../master/networking/request_manager.dart';
import '../../common_widgets/bottomsheet_with_close.dart';

class AddActivitiesScreenController extends GetxController {
  //TODO: Implement AddActivitiesScreenController

  RxInt selectedActivity = 0.obs;

  GlobalKey<FormState> hotelFormKey = GlobalKey<FormState>(debugLabel: "hotel");
  GlobalKey<FormState> flightFormKey =
      GlobalKey<FormState>(debugLabel: "flight");
  GlobalKey<FormState> diningFormKey =
      GlobalKey<FormState>(debugLabel: "dining");
  GlobalKey<FormState> eventFormKey = GlobalKey<FormState>(debugLabel: "event");

  Rx<AutovalidateMode> hotelActivationMode = AutovalidateMode.disabled.obs;
  Rx<AutovalidateMode> flightActivationMode = AutovalidateMode.disabled.obs;
  Rx<AutovalidateMode> diningActivationMode = AutovalidateMode.disabled.obs;
  Rx<AutovalidateMode> eventActivationMode = AutovalidateMode.disabled.obs;
  List<String> selectedActivityList = <String>[];

  // HOTEL VIEW VARIABLES
  TextEditingController hotelNameController = TextEditingController();
  TextEditingController avgNightlyController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController roomNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  RxString counter = "250".obs;
  RxString pickedDate = "".obs;
  RxInt numberOfNights = 0.obs;
  RxInt capacityPerRoom = 0.obs;
  RxString hotelCheckInTime = "04:00 PM".obs; // 04:00 PM
  TimeOfDay hotelCheckInTimeTD =
      const TimeOfDay(hour: 16, minute: 00); // 04:00 PM
  RxString hotelCheckOutTime = "11:00 PM".obs; // 11:00 PM
  TimeOfDay hotelCheckOutTimeTD =
      const TimeOfDay(hour: 23, minute: 00); // 11:00 PM

  // FLIGHT VIEW VARIABLES
  RxString onArrivalDate = "".obs;
  RxString onArrivalTime = "HH:MM".obs;
  RxString departureDate = "".obs;
  RxString departureTime = "HH:MM".obs;
  TextEditingController flightTextController = TextEditingController();
  TextEditingController flightNumberArrivalTextController =
      TextEditingController();
  TextEditingController flightNumberDepartureTextController =
      TextEditingController();
  TextEditingController tripDetailTextController = TextEditingController();
  RxString descFlightCount = "250".obs;

  // DINING VIEW VARIABLES
  RxString onSelectDate = "".obs;
  RxString onSelectTime = "HH:MM".obs;
  RxInt numberOfHours = 0.obs;
  RxString descriptionCounterDining = "250".obs;
  TextEditingController diningNameController = TextEditingController();
  TextEditingController diningLocationController = TextEditingController();
  TextEditingController costPersonController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();

//EVENT VIEW VARIABLES
  RxString onEventDate = "".obs;
  RxString timeSpent = "".obs;
  RxString timeIn = "HH:MM".obs;
  RxString timeOut = "HH:MM".obs;
  RxInt numberOfEventHours = 0.obs;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationAddressController =
      TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController totalCostPerPersonController = TextEditingController();
  RxString locationCounter = "250".obs;
  RxString descriptionCounter = "250".obs;
  TextEditingController eventUrlController = TextEditingController();

  RxInt? tripID = 0.obs;
  RxString? activityID = "".obs;

  Map<String, dynamic>? activityDetailsModel = <String, dynamic>{};

  @override
  void onInit() {
    super.onInit();
    final currentDate = DateTime.now();
    final String strPickedDate = DateFormat("MMM dd, yyyy").format(currentDate);
    pickedDate.value = strPickedDate;
    onArrivalDate.value = strPickedDate;
    departureDate.value = strPickedDate;
    onSelectDate.value = strPickedDate;
    onEventDate.value = strPickedDate;
    activityID!.value = Get.arguments[0];
    tripID!.value = Get.arguments[1];

    if (activityDetailsModel != null) {
      activityDetailsModel = Get.arguments[2];
      if (activityDetailsModel?["activity_type"] == "hotel") {
        selectedActivity.value = 0;
        setDataIntoHotel();
      } else if (activityDetailsModel?["activity_type"] == "flight") {
        selectedActivity.value = 1;
        setDataIntoFlight();
      } else if (activityDetailsModel?["activity_type"] == "dining") {
        selectedActivity.value = 2;
        setDataIntoDining();
      } else if (activityDetailsModel?["activity_type"] == "event") {
        selectedActivity.value = 3;
        setDataIntoEvent();
      }
    }
  }

  /// This function is used to set the data in hotel view.
  /// It will take the data from the activityDetailsModel and set it in the respective controllers and variables.
  /// The data includes hotel name, picked date, number of nights, average nightly cost, total cost, capacity per room, address, room number, check-in time, check-out time, description and URL.
  void setDataIntoHotel() {
    hotelNameController.text = activityDetailsModel?["name"];
    pickedDate.value = DateFormat('MMM dd, yyyy').format(
        DateFormat('yyyy-MM-dd').parse(activityDetailsModel?["event_date"]));
    numberOfNights.value = activityDetailsModel?["number_of_nights"];
    avgNightlyController.text = activityDetailsModel?["average_nightly_cost"];
    totalCostController.text = activityDetailsModel?["cost"];
    capacityPerRoom.value = activityDetailsModel?["capacity_per_room"];
    addressController.text = activityDetailsModel?["address"];
    roomNoController.text = activityDetailsModel?["room_number"];
    hotelCheckInTime.value = DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(activityDetailsModel?["event_time"]));
    hotelCheckOutTime.value = DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(activityDetailsModel?["checkout_time"]));
    descriptionController.text = activityDetailsModel?["discription"];
    counter.value = (250 - (descriptionController.text.length)).toString();
    urlController.text = activityDetailsModel?["url"];
  }


  /// This function is used to set the data in flight view.
  /// It will take the data from the activityDetailsModel and set it in the respective controllers and variables.
  /// The data includes flight name, arrival flight number, arrival date, arrival time, departure flight number, departure date, departure time, trip detail and description.
  void setDataIntoFlight() {
    flightTextController.text = activityDetailsModel?["name"];
    flightNumberArrivalTextController.text =
        activityDetailsModel?["arrival_flight_number"];
    onArrivalDate.value = DateFormat('MMM dd, yyyy').format(
        DateFormat('yyyy-MM-dd').parse(activityDetailsModel?["event_date"]));
    onArrivalTime.value = DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(activityDetailsModel?["event_time"]));
    flightNumberDepartureTextController.text =
        activityDetailsModel?["departure_flight_number"];
    departureDate.value = DateFormat('MMM dd, yyyy').format(
        DateFormat('yyyy-MM-dd')
            .parse(activityDetailsModel?["departure_date"]));
    departureTime.value = DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(activityDetailsModel?["checkout_time"]));
    tripDetailTextController.text = activityDetailsModel?["discription"];
    descFlightCount.value =
        (250 - tripDetailTextController.text.length).toString();
  }

  /// This function is used to set the data in dining view.
  /// It will take the data from the activityDetailsModel and set it in the respective controllers and variables.
  /// The data includes dining name, location, selected date, selected time, cost per person, spent hours, description and description counter.
  void setDataIntoDining() {
    diningNameController.text = activityDetailsModel?["name"];
    diningLocationController.text = activityDetailsModel?["address"];
    onSelectDate.value = DateFormat('MMM dd, yyyy').format(
        DateFormat('yyyy-MM-dd').parse(activityDetailsModel?["event_date"]));
    onSelectTime.value = DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(activityDetailsModel?["event_time"]));
    costPersonController.text = activityDetailsModel?["cost"];
    numberOfHours.value = activityDetailsModel?["spent_hours"];
    addDescriptionController.text = activityDetailsModel?["discription"];
    descriptionCounterDining.value =
        (250 - addDescriptionController.text.length).toString();
  }

  /// This function is used to set the data in event view.
  /// It will take the data from the activityDetailsModel and set it in the respective controllers and variables.
  /// The data includes event name, event date, time in, time out, number of hours spent, 
  /// event location address, location counter, total cost per person, event description, 
  /// description counter, and event URL.

  void setDataIntoEvent() {
    eventNameController.text = activityDetailsModel?["name"];
    onEventDate.value = DateFormat('MMM dd, yyyy').format(
        DateFormat('yyyy-MM-dd').parse(activityDetailsModel?["event_date"]));
    timeIn.value = DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(activityDetailsModel?["event_time"]));
    timeOut.value = DateFormat('h:mm a').format(
        DateFormat('HH:mm:ss').parse(activityDetailsModel?["checkout_time"]));
    numberOfEventHours.value = activityDetailsModel?["spent_hours"];
    eventLocationAddressController.text = activityDetailsModel?["address"];
    locationCounter.value =
        (250 - eventLocationAddressController.text.length).toString();
    totalCostPerPersonController.text = activityDetailsModel?["cost"];
    eventDescriptionController.text = activityDetailsModel?["discription"];
    descriptionCounter.value =
        (250 - eventDescriptionController.text.length).toString();
    eventUrlController.text = activityDetailsModel?["url"];
  }

  /// This function is used to reset the data in all the views.
  /// It will reset all the controllers and variables of the respective views.
  /// The data includes hotel name, average nightly cost, total cost, address, room number, check-in time, check-out time, description, URL,
  /// flight name, arrival date, arrival time, departure date, departure time, trip detail, event name, event date, time in, time out,
  /// number of hours spent, event location address, location counter, total cost per person, event description, description counter, and event URL.
  void reset() {
    final currentDate = DateTime.now();
    final String strPickedDate = DateFormat("MMM dd, yyyy").format(currentDate);
    switch (selectedActivity.value) {
      case 0: // Hotel View
        hotelNameController.text = "";
        avgNightlyController.text = "";
        totalCostController.text = "";
        addressController.text = "";
        roomNoController.text = "";
        descriptionController.text = "";
        urlController.text = "";
        counter.value = "250";
        pickedDate.value = strPickedDate;
        numberOfNights.value = 0;
        capacityPerRoom.value = 0;
        hotelCheckInTime.value = "04:00 PM";
        hotelCheckOutTime.value = "11:00 PM";
        hotelActivationMode.value = AutovalidateMode.disabled;

        break;
      case 1: //Flight View
        onArrivalDate.value = strPickedDate;
        onArrivalTime.value = "HH:MM";
        departureDate.value = strPickedDate;
        departureTime.value = "HH:MM";
        flightTextController.text = "";
        flightNumberArrivalTextController.text = "";
        flightNumberDepartureTextController.text = "";
        tripDetailTextController.text = "";
        descFlightCount.value = "250";
        flightActivationMode.value = AutovalidateMode.disabled;

        break;
      case 2: // Dining View
        onSelectDate.value = strPickedDate;
        onSelectTime.value = "HH:MM";
        numberOfHours.value = 0;
        descriptionCounterDining.value = "250";
        diningNameController.text = "";
        diningLocationController.text = "";
        costPersonController.text = "";
        addDescriptionController.text = "";
        diningActivationMode.value = AutovalidateMode.disabled;

        break;
      case 3: // Event View
        onEventDate.value = strPickedDate;
        timeIn.value = "HH:MM";
        timeOut.value = "HH:MM";
        numberOfEventHours.value = 0;
        locationCounter.value = "250";
        descriptionCounter.value = "250";
        eventNameController.text = "";
        eventLocationAddressController.text = "";
        eventDescriptionController.text = "";
        totalCostPerPersonController.text = "";
        eventUrlController.text = "";
        eventActivationMode.value = AutovalidateMode.disabled;
        break;
    }
  }

  /// This function is used to validate the form according to the selected activity.
  /// It will check the form fields and show the error messages accordingly.
  /// If the form is valid, it will call the addEditActivity function and change the selected activity
  /// to the respective activity.
  void onDataSubmitted() {
    switch (selectedActivity.value) {
      case 0: // Hotel View
        if (hotelFormKey.currentState!.validate()) {
          if (hotelCheckInTime.value == "HH:MM") {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivitySelectCheckInTime.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else if (hotelCheckOutTime.value == "HH:MM") {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivitySelectCheckOutTime.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else if (numberOfNights.value == 0) {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityNumberOfNight.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else if (capacityPerRoom.value == 0) {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityRoomCapacity.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else {
            addEditActivity();
            selectedActivityList = ["hotel", "flight"];
          }
        } else {
          hotelActivationMode.value = AutovalidateMode.onUserInteraction;
        }
        break;
      case 1: //Flight View
        if (flightFormKey.currentState!.validate()) {
          if (onArrivalTime.value == "HH:MM") {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankTripArrivalTime.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else if (departureTime.value == "HH:MM") {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityDepartureTime.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else {
            addEditActivity();
            selectedActivityList = ["hotel", "flight"];
          }
        } else {
          flightActivationMode.value = AutovalidateMode.onUserInteraction;
        }

        break;
      case 2: // Dining View
        if (diningFormKey.currentState!.validate()) {
          if (onSelectTime.value == "HH:MM") {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityDiningTime.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else if (numberOfHours.value == 0) {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityNumberOfHours.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else {
            addEditActivity();
            selectedActivityList = ["dining", "event"];
          }
        } else {
          diningActivationMode.value = AutovalidateMode.onUserInteraction;
        }

        break;
      case 3: // Event View

        if (eventFormKey.currentState!.validate()) {
          if (timeIn.value == "HH:MM") {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityTimeIn.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else if (timeOut.value == "HH:MM") {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityTimeOut.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else if (numberOfEventHours.value == 0) {
            RequestManager.getSnackToast(
                message: LabelKeys.cBlankActivityNumberOfHoursSpent.tr,
                backgroundColor: Get.theme.colorScheme.error,
                colorText: Get.theme.colorScheme.onError);
          } else {
            addEditActivity();
            selectedActivityList = ["dining", "event"];
          }
        } else {
          eventActivationMode.value = AutovalidateMode.onUserInteraction;
        }
        break;
    }
  }

  /// This function is used to add/edit activity in trip.
  /// It will call api according to selected activity type.
  /// If selected activity is hotel then it will call hotel api.
  /// If selected activity is flight then it will call flight api.
  /// If selected activity is dining or event then it will call dining/api.
  /// It will also show success bottomsheet after successfully added/edited activity.
  /// It will reset all fields after successfully added/edited activity.
  void addEditActivity() {
    hideKeyboard();
    Get.focusScope?.unfocus();
    var body = {
      RequestParams.activityId: activityID!.value,
      RequestParams.tripId: tripID!.value,
      RequestParams.activityType: activityTypeAccordingToActivity(),
      RequestParams.name: nameAccordingToActivity(),
      RequestParams.date: dateAccordingToActivity(),
      RequestParams.time: timeAccordingToActivity(),
      RequestParams.utcTime: timeAccordingToActivityUtc(),
      RequestParams.checkoutTime: checkoutTimeAccordingToActivity(),
      RequestParams.description: descriptionAccordingToActivity(),
      RequestParams.url: urlAccordingToActivity(),
      RequestParams.address: addressAccordingToActivity(),
      RequestParams.cost: costAccordingToActivity(),
      RequestParams.spentHours: spentHoursAccordingToActivity(),
      RequestParams.numberOfNights:
          selectedActivity.value == 0 ? numberOfNights.value : "",
      RequestParams.averageNightlyCost: selectedActivity.value == 0
          ? avgNightlyController.text.toString().trim()
          : "",
      RequestParams.capacityPerRoom:
          selectedActivity.value == 0 ? capacityPerRoom.value : "",
      RequestParams.roomNumber: selectedActivity.value == 0
          ? roomNoController.text.toString().trim()
          : "",
      RequestParams.departureFlightDate: selectedActivity.value == 1
          ? DateFormat('yyyy-MM-dd')
              .format(DateFormat('MMM dd, yyyy').parse(departureDate.value))
          : "",
      RequestParams.arrivalFlightNumber: selectedActivity.value == 1
          ? flightNumberArrivalTextController.text.toString().trim()
          : "",
      RequestParams.departureFlightNumber: selectedActivity.value == 1
          ? flightNumberDepartureTextController.text.toString().trim()
          : "",
    };

    RequestManager.postRequest(
      uri: EndPoints.addEditActivity,
      isLoader: true,
      hasBearer: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          reset();
          // Show bottomsheet
          Get.bottomSheet(
            isScrollControlled: true,
            BottomSheetWithClose(widget: successBottomSheet()),
          );
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }

  /// Displays a success bottom sheet after an activity is added or updated.
  ///
  /// The bottom sheet shows a message indicating whether the activity
  /// was added or updated successfully, followed by a prompt asking
  /// if the user wants to add more. It contains "Yes" and "No" buttons
  /// to let the user decide whether to add another activity or not.

  Widget successBottomSheet() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppDimens.paddingLarge.ph,
          Text(
            activityID?.value == ""
                ? LabelKeys.activityAddedSuccessfully.tr
                : LabelKeys.activityUpdatedSuccessfully.tr,
            style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
          ),
          AppDimens.paddingMedium.ph,
          Text(
            LabelKeys.youWantAddMore.tr,
            style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
          ),
          AppDimens.padding3XLarge.ph,
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.yes.tr,
                      onPressed: () {
                        activityID!.value = "";
                        Get.back();
                      },
                    ),
                  ),
                  AppDimens.paddingLarge.pw,
                  Expanded(
                    child: MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.no.tr,
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                    ),
                  ),
                ],
              )),
          AppDimens.padding3XLarge.ph,
        ],
      ),
    );
  }

  /// This function returns the activity type as a string
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: "hotel"
  /// - 1: "flight"
  /// - 2: "dining"
  /// - 3: "event"
  /// 
  /// This value is used in the API call to add or edit an activity.
  String activityTypeAccordingToActivity() {
    String activityType = "";
    switch (selectedActivity.value) {
      case 0:
        activityType = "hotel";
        break;
      case 1:
        activityType = "flight";
        break;
      case 2:
        activityType = "dining";
        break;
      case 3:
        activityType = "event";
        break;
    }
    return activityType;
  }

  /// This function returns the name of the activity as a string
  /// based on the selectedActivity.value. 
  ///
  /// The mapping is as follows:
  /// - 0: Retrieves the hotel name from hotelNameController.
  /// - 1: Retrieves the flight name from flightTextController.
  /// - 2: Retrieves the dining name from diningNameController.
  /// - 3: Retrieves the event name from eventNameController.
  ///
  /// This value is used in the API call to add or edit an activity.

  String nameAccordingToActivity() {
    String name = "";
    switch (selectedActivity.value) {
      case 0:
        name = hotelNameController.text.toString().trim();
        break;
      case 1:
        name = flightTextController.text.toString().trim();
        break;
      case 2:
        name = diningNameController.text.toString().trim();
        break;
      case 3:
        name = eventNameController.text.toString().trim();
        break;
    }
    return name;
  }

  /// This function returns the date of the activity as a string in 'yyyy-MM-dd' format,
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: Retrieves the date from pickedDate.value (hotel).
  /// - 1: Retrieves the date from onArrivalDate.value (flight).
  /// - 2: Retrieves the date from onSelectDate.value (dining).
  /// - 3: Retrieves the date from onEventDate.value (event).
  /// 
  /// This value is used in the API call to add or edit an activity.
  String dateAccordingToActivity() {
    String date = "";
    switch (selectedActivity.value) {
      case 0:
        date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('MMM dd, yyyy').parse(pickedDate.value));
        break;
      case 1:
        date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('MMM dd, yyyy').parse(onArrivalDate.value));
        break;
      case 2:
        date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('MMM dd, yyyy').parse(onSelectDate.value));
        break;
      case 3:
        date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('MMM dd, yyyy').parse(onEventDate.value));
        break;
    }
    return date;
  }

  /// This function returns the time of the activity as a string in 'HH:mm:ss' format,
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: Retrieves the time from hotelCheckInTime.value (hotel).
  /// - 1: Retrieves the time from onArrivalTime.value (flight).
  /// - 2: Retrieves the time from onSelectTime.value (dining).
  /// - 3: Retrieves the time from timeIn.value (event).
  /// 
  /// This value is used in the API call to add or edit an activity.
  String timeAccordingToActivity() {
    String time = "";
    switch (selectedActivity.value) {
      case 0:
        time = DateFormat('HH:mm:ss')
            .format(DateFormat('h:mm a').parse(hotelCheckInTime.value));
        break;
      case 1:
        time = DateFormat('HH:mm:ss')
            .format(DateFormat('h:mm a').parse(onArrivalTime.value));
        break;
      case 2:
        time = DateFormat('HH:mm:ss')
            .format(DateFormat('h:mm a').parse(onSelectTime.value));
        break;
      case 3:
        time = DateFormat('HH:mm:ss')
            .format(DateFormat('h:mm a').parse(timeIn.value));
        break;
    }
    return time;
  }

  /// This function returns the UTC time of the activity as a string in 'yyyy-MM-dd HH:mm:ss' format,
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: Parses the date and time from pickedDate.value and hotelCheckInTime.value (hotel).
  /// - 1: Parses the date and time from onArrivalDate.value and onArrivalTime.value (flight).
  /// - 2: Parses the date and time from onSelectDate.value and onSelectTime.value (dining).
  /// - 3: Parses the date and time from onEventDate.value and timeIn.value (event).
  /// 
  /// The parsed time is then converted to UTC format.

  String timeAccordingToActivityUtc() {
    String time = "";
    switch (selectedActivity.value) {
      case 0:
        time = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateFormat('MMM dd, yyyy h:mm a')
                .parse("${pickedDate.value} ${hotelCheckInTime.value}")
                .toUtc());
        break;
      case 1:
        time = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateFormat('MMM dd, yyyy h:mm a')
                .parse("${onArrivalDate.value} ${onArrivalTime.value}")
                .toUtc());
        break;
      case 2:
        time = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateFormat('MMM dd, yyyy h:mm a')
                .parse("${onSelectDate.value} ${onSelectTime.value}")
                .toUtc());
        break;
      case 3:
        time = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateFormat('MMM dd, yyyy h:mm a')
                .parse("${onEventDate.value} ${timeIn.value}")
                .toUtc());
        break;
    }
    return time;
  }

  /// This function returns the checkout time of the activity as a string in 'HH:mm:ss' format,
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: Parses the time from hotelCheckOutTime.value (hotel).
  /// - 1: Parses the time from departureTime.value (flight).
  /// - 2: Calculates the checkout time by adding numberOfHours.value to onSelectTime.value (dining).
  /// - 3: Parses the time from timeOut.value (event).
  /// 
  /// This value is used in the API call to add or edit an activity.

  String checkoutTimeAccordingToActivity() {
    String checkOutTime = "";
    switch (selectedActivity.value) {
      case 0:
        checkOutTime = DateFormat('HH:mm:ss')
            .format(DateFormat('h:mm a').parse(hotelCheckOutTime.value));
        break;
      case 1:
        checkOutTime = DateFormat('HH:mm:ss')
            .format(DateFormat('h:mm a').parse(departureTime.value));
        break;
      case 2:
        checkOutTime = addHoursToTime(onSelectTime.value, numberOfHours.value);
        break;
      case 3:
        checkOutTime = DateFormat('HH:mm:ss')
            .format(DateFormat('h:mm a').parse(timeOut.value));
        break;
    }
    return checkOutTime;
  }

  /// Returns a new string representing the time after adding [hoursToAdd] hours to [time].
  /// 
  /// [time] is expected to be in 'h:mm a' format.
  /// 
  /// The result is returned in 'HH:mm:ss' format.
  String addHoursToTime(String time, int hoursToAdd) {
    DateTime parsedTime = DateFormat('h:mm a').parse(time);
    DateTime newTime = parsedTime.add(Duration(hours: hoursToAdd));
    return DateFormat('HH:mm:ss').format(newTime);
  }

  /// Returns the description of the activity as a string,
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: Retrieves the description from descriptionController.text (hotel).
  /// - 1: Retrieves the description from flightTextController.text (flight).
  /// - 2: Retrieves the description from addDescriptionController.text (dining).
  /// - 3: Retrieves the description from eventDescriptionController.text (event).
  /// 
  /// This value is used in the API call to add or edit an activity.
  String descriptionAccordingToActivity() {
    String description = "";
    switch (selectedActivity.value) {
      case 0:
        description = descriptionController.text.toString().trim();
        break;
      case 1:
        description = flightTextController.text.toString().trim();
        break;
      case 2:
        description = addDescriptionController.text.toString().trim();
        break;
      case 3:
        description = eventDescriptionController.text.toString().trim();
        break;
    }
    return description;
  }

  /// Returns the url of the activity as a string,
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: Retrieves the url from urlController.text (hotel).
  /// - 1: Returns an empty string (flight).
  /// - 2: Returns an empty string (dining).
  /// - 3: Retrieves the url from eventUrlController.text (event).
  /// 
  /// This value is used in the API call to add or edit an activity.
  String urlAccordingToActivity() {
    String url = "";
    switch (selectedActivity.value) {
      case 0:
        url = urlController.text.toString().trim();
        break;
      case 1:
        url = "";
        break;
      case 2:
        url = "";
        break;
      case 3:
        url = eventUrlController.text.toString().trim();
        break;
    }
    return url;
  }

  /// Returns the address of the activity as a string,
  /// depending on the selectedActivity.value.
  /// 
  /// The mapping is as follows:
  /// - 0: Retrieves the address from addressController.text (hotel).
  /// - 1: Returns an empty string (flight).
  /// - 2: Retrieves the address from diningLocationController.text (dining).
  /// - 3: Retrieves the address from eventLocationAddressController.text (event).
  /// 
  /// This value is used in the API call to add or edit an activity.
  String addressAccordingToActivity() {
    String address = "";
    switch (selectedActivity.value) {
      case 0:
        address = addressController.text.toString().trim();
        break;
      case 1:
        address = "";
        break;
      case 2:
        address = diningLocationController.text.toString().trim();
        break;
      case 3:
        address = eventLocationAddressController.text.toString().trim();
        break;
    }
    return address;
  }

  costAccordingToActivity() {
    dynamic cost;
    switch (selectedActivity.value) {
      case 0:
        cost = totalCostController.text.toString().trim();
        break;
      case 1:
        cost = "";
        break;
      case 2:
        cost = costPersonController.text.toString().trim();
        break;
      case 3:
        cost = totalCostPerPersonController.text.toString().trim();
        break;
    }
    return cost;
  }

  spentHoursAccordingToActivity() {
    dynamic spentHours = 0;
    switch (selectedActivity.value) {
      case 0:
        spentHours = "";
        break;
      case 1:
        spentHours = "";
        break;
      case 2:
        spentHours = numberOfHours.value;
        break;
      case 3:
        spentHours = numberOfEventHours.value;
        break;
    }
    return spentHours;
  }

  /// This function is used to calculate the time difference between two
  /// given times in the format of HH:MM. The result is then passed to
  /// the formatDuration function for formatting.
  void timeDifferentCalculator() {
    if (timeIn.value != "HH:MM" && timeOut.value != "HH:MM") {
      DateTime time1 = DateFormat("hh:mm a").parse(timeIn.value);
      DateTime time2 = DateFormat("hh:mm a").parse(timeOut.value);
      Duration timeDuration;
      if (time1.isBefore(time2)) {
        print("time1 is earlier than time2");
        timeDuration = time2.difference(time1);
      } else if (time1.isAfter(time2)) {
        print("time1 is later than time2");
        timeDuration = time1.difference(time2);
      } else {
        timeDuration = time2.difference(time1);
        print("time1 and time2 are equal");
      }
      formatDuration(timeDuration);
    }
  }

  /// This function takes a duration in the format of a
  /// [Duration] object and formats it into a string in
  /// the format of 'HHH MM' where HH is the number of
  /// hours and MM is the number of minutes.
  ///
  /// The function takes the duration, parses it into its
  /// component hours and minutes, and then formats them
  /// into a string. The string is then set as the value
  /// of the [timeSpent] variable.
  ///
  /// A message is also printed to the console with the
  /// value of [timeSpent] for debugging purposes.
  ///
  /// This function is used in the [timeDifferentCalculator]
  /// function to format the duration between two given
  /// times.
  void formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60).abs();
    /*double timeDiffrence =
        double.parse('$hours.${minutes.toString().padLeft(2, '0')}');
    if (timeDiffrence < 0) {
      timeDiffrence = timeDiffrence * -1;
    }*/
    timeSpent.value = '${hours}H ${minutes.toString().padLeft(2, '0')}M';
    printMessage("timeSpent-${timeSpent.value}");
  }
}
