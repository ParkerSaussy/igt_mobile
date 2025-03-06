import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../app/base/GeneralController.dart';
import '../../app/routes/app_pages.dart';
import '../general_utils/common_stuff.dart';
import '../general_utils/constants.dart';
import '../general_utils/label_key.dart';
import '../session/preference.dart';
import 'logger.dart';

GeneralController gc = Get.put(GeneralController(), permanent: true);

class EndPoints {
  static const baseUrl = 'https://lesgo.dashtechinc.com/api/v1/';
  //static const baseUrl = 'http://192.168.5.164:8000/api/v1/';
  //static const baseUrl = 'http://192.168.121.155:8081/api/v1/';

  static var signUp = "auth/register";
  static var login = "auth/signin";
  static var getEmailForApple = "auth/getEmailForApple";
  static var forgotPassword = "auth/forgotPassword";
  static var verifyOtp = "auth/verifyOtp";
  static var resetPassword = "auth/resetPassword";
  static var changePassword = "auth/changePassword";
  static var sendOtp = "auth/sendOtp";
  static var getCms = "auth/getCms";
  static var uploadImage = "auth/uploadImage";
  static var editProfile = "auth/editProfile";
  static var updateMobileNumber = "auth/updateMobileNumber";
  static var getProfile = "auth/getProfile";
  static var updateNotificationStatus = "auth/updatenotficationStatus";
  static var logout = "auth/logout";
  //CREATE TRIP MODULE API
  //static var getCities = "trip/getcities";
  static var getCities = "trip/getCitiesSearched";
  static var createTrip = "trip/createtrip";
  static var addGuestToTrip = "trip/addGuestToTrip";
  static var uploadTripCoverImage = "trip/uploadTripCoverImage";
  static var getCoverImages = "trip/getcoverimages";
  static var getTripGuestList = "trip/getTripGuestList";
  static var sendInvitation = "trip/sendInvitation";
  static var removeInvitee = "trip/removeInvitee";
  static var updateGuestRole = "trip/updateGuestRole";
  static var getTripsList = "trip/getTripsList";
  static var getTripDocuments = "trip/gettripdocuments";
  static var uploadTripDocument = "trip/uploadtripdocument";
  static var getTripDetail = "trip/getTripDetail";
  static var addCitiesToTrip = "trip/addCitiesToTrip";
  static var addDatesToTrip = "trip/adddatestotrip";
  static var getDatesPollDetails = "trip/getDatesPollDetails";
  static var getCityPollDetails = "trip/getCityPollDetails";
  static var deleteTripDocuments = "trip/deleteTripDocuments";
  static var saveFinalTrip = "trip/saveFinalTrip";
  static var addDatePoll = "trip/addDatePoll";
  static var addCityPoll = "trip/addCityPoll";
  static var actionOnInvitation = "trip/actionOnInvitation";
  static var deleteTrip = "trip/deleteTrip";
  static var getPlans = "plan/getPlans";
  static var purchasePlan = "plan/purchasePlan";

  static var updateUsernames = "auth/updateUsernames";

  //TRIP MEMORY
  static var getActivityName = "memories/getActivityName";
  static var addMemory = "memories/addMemory";
  static var memoryListing = "memories/memoryListing";
  static var deleteMemory = "memories/deleteMemory";
  static var addDropboxUrl = "trip/addDropboxUrl";

  //ADD ACTIVITY
  static var addEditActivity = "activity/addEditActivity";
  static var getActivityDetail = "activity/getActivityDetail";
  static var deleteActivity = "activity/deleteActivity";
  static var likeDislikeIdeas = "activity/likeDislikeIdeas";
  static var makeItineary = "activity/makeItineary";

  //FAQ
  static var faqList = "faq/faqList";

  //walkthrough
  static var youtubeUrls = "walkthrough/youtubeUrls";

  //CONTACT US
  static var addInquiry = "contact/addInquiry";

  //NOTIFICATION
  static var notificationGet = "notification/get";
  static var notificationDelete = "notification/delete";

  // Expense
  static var addExpense = "expense/addExpense";
  static var getActivities = "expense/getActivities";
  static var getResolutions = "expense/getResolutions";
  static var payExpense = "expense/payExpense";
  static var expReport = "expense/expReport";
}

// api's request parameters
class RequestParams {
  static const firstName = "firstName";
  static const lastName = "lastName";
  static const displayName = "displayName";
  static const email = "email";
  static const mobile = "mobile";
  static const forgot = "forgot";
  static const countryCode = "countryCode";
  static const mobileNumber = "mobileNumber";
  static const password = "password";
  static const loginType = "loginType";
  static const fcmToken = "fcmToken";
  static const deviceType = "deviceType";
  static const deviceId = "deviceId";
  static const platform = "platform";
  static const reciverType = "reciverType";
  static const reciver = "reciver";
  static const otpType = "otpType";
  static const otp = "otp";
  static const verify = "verify";

  static const tripType = "tripType";
  //SEND INVITE PARAMS
  static const guestId = "guestId";
  //ADD GUEST PARAMS
  static const tripId = "tripId";
  static const isTripFinalised = "isTripFinalised";
  static const tripFinalizingComments = "tripFinalizingComments";
  static const emailId = "emailId";
  static const phone = "phone";
  static const role = "role";
  static const isCoHost = "isCoHost";
  static const inviteStatus = "inviteStatus";
  static const tripGuestsList = "tripGuestsList";
  //CREATE TRIP PARAMS
  static const tripName = "tripName";
  static const itinaryDetails = "itinaryDetails";
  static const responseDeadline = "responseDeadline";
  static const tripDescription = "tripDescription";
  static const reminderDays = "reminderDays";
  static const tripImgUrl = "tripImgUrl";
  static const tripFinalStartDate = "tripFinalStartDate";
  static const tripFinalEndDate = "tripFinalEndDate";
  static const tripFinalCityId = "tripFinalCityId";
  static const tripDatesList = "tripDatesList";
  static const tripCitiesList = "tripCitiesList";
  static const startDate = "startDate";
  static const endDate = "endDate";
  static const comment = "comment";
  static const cityName = "cityName";
  static const cityId = "cityId";
  static const status = "status";
  //UPLOAD TRIP DOCUMENT PARAMS
  static const documentName = "documentName";
  static const document = "document";
  static const documentId = "documentId";
  static const size = "size";
  //ADD MEMORY IMAGE PARAMS
  static const caption = "caption";
  static const location = "location";
  static const activityName = "activityName";
  static const memoryId = "memoryId";
  static const dropboxUrl = "dropboxUrl";

  //TRIP IMAGE
  static const coverImage = "coverImage";

  //ADD ACTIVITY
  static const activityId = "activityId";
  static const activityType = "activityType";
  static const name = "name";
  static const date = "date";
  static const time = "time";
  static const utcTime = "utcTime";
  static const checkoutTime = "checkoutTime";
  static const description = "description";
  static const expenseName = "name";
  static const url = "url";
  static const address = "address";
  static const cost = "cost";
  static const spentHours = "spentHours";
  static const numberOfNights = "numberOfNights";
  static const averageNightlyCost = "averageNightlyCost";
  static const capacityPerRoom = "capacityPerRoom";
  static const roomNumber = "roomNumber";
  static const departureFlightDate = "departureFlightDate";
  static const arrivalFlightNumber = "arrivalFlightNumber";
  static const departureFlightNumber = "departureFlightNumber";

  //GET ACTIVITY DETAILS
  static const filterEventType = "filterEventType";
  static const searchText = "searchText";

  //LIKE OR DISLIKE IDEAS
  static const likeOrDislike = "likeOrDislike";

  //MAKE ITINERARY
  static const isItineary = "isItineary";

  //PAYPAL VENMO USERNAME
  static const paypalUsername = "paypalUsername";
  static const venmoUsername = "venmoUsername";

  //ADD EXPENSE
  static const paidBy = "paid_by";
  static const amount = "amount";
  static const expenseOn = "expense_on";
  static const shareList = "shareList";

  static const eventName = "eventName";
  static const djId = "djId";
  static const djPhoto = "djPhotos";
  static const djDetails = "djDetails";
  static const rating = "rating";
  static const ratingDjId = "ratingdjId";
  static const userId = "userId";
  static const hostId = "hostId";
  static const country = "country";
  static const userName = "userName";
  static const profileUserName = "userName";
  static const image = "image";
  static const oldPassword = "oldPassword";
  static const cPassword = "cPassword";
  static const profileImage = "profileImage";
  static const auth = "auth";
  static const sortBy = "sortBy";

  static const socialId = "socialId";
  static const socialType = "socialType";
  static const signInType = "signInType";
  static const profilePicture = "profilePicture";
  static const type = "type";

  //ADD POLL PARAMS
  static const tripDatesListId = 'tripDatesListId';
  static const tripCityListId = 'tripCityListId';
  static const isSelected = 'isSelected';
  static const message = 'message';

  //NOTIFICATION PARAMS
  static const notificationId = 'id';

  //PURCHASE PLAB PARAMS
  static const planType = 'plan_type';
  static const planId = 'plan_id';
  static const price = 'price';
  static const duration = 'duration';
  static const transactionId = 'transaction_id';
  static const paymentThrough = 'payment_through';
  static const tripID = 'trip_id';

  // Expense Params
  static const trip_id = "trip_id";
  static const creditor = "creditor";

// Update Notification Status Params
  static const chatNotification = "chatNotification";
  static const pushNotification = "pushNotification";
}

// api request manager
class RequestManager {
  // snackbar activation state;
  static bool isRefreshingToken = false;
  static bool isActive = false;

// api post request
  /// This function makes a POST request to the given [uri] with the
  /// given [body] and [header] parameters. If [jsonEncoded] is true,
  /// the [body] is JSON encoded before being sent.
  ///
  /// If [hasBearer] is true, the bearer token is added to the [header].
  ///
  /// If [isLoader] is true, an EasyLoading loader is shown while the request is in progress.
  ///
  /// If the request is successful, the [onSuccess] callback is called
  /// with the response body, message, and status as parameters.
  ///
  /// If the request fails, the [onFailure] callback is called
  /// with the error message as a parameter.
  ///
  /// If the request fails with a 401 status code, the user is logged out
  /// and the [onFailure] callback is called with the error message as a parameter.
  ///
  /// If the request fails with a 404 status code, a snack toast is shown
  /// with the error message and the [onFailure] callback is called with the
  /// error message as a parameter.
  ///
  /// If the request fails with a 500 status code, a snack toast is shown
  /// with the error message "Something went wrong, Try again later..."
  /// and the [onFailure] callback is called with the error message as a parameter.
  ///
  /// If the request fails with a timeout, a snack toast is shown
  /// with the error message "Error : TimeOut" and the [onFailure] callback is called
  /// with the error message as a parameter.
  ///
  /// The [onConnectionFailed] callback is called if the device is not connected
  /// to the internet. If [onConnectionFailed] is null, a snack toast is shown
  /// with the error message "Check your internet connection".
  static void postRequest({
    required String uri,
    body,
    bool jsonEncoded = true,
    bool hasBearer = true,
    bool isLoader = false,
    bool isBtnLoader = false,
    bool isSuccessMessage = false,
    bool isFailedMessage = true,
    required Function(dynamic responseBody, String message, bool status)
        onSuccess,
    required Function onFailure,
    Function? onConnectionFailed,
  }) async {
    if (!await isConnectedNetwork()) {
      getSnackToast(
          message: LabelKeys.checkInternet.tr,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError);
      onFailure(LabelKeys.checkInternet.tr);
      return;
    }
    Map<String, String> header = {
      'Content-Type': 'application/json',
    };
    if (hasBearer) {
      header = {
        'Content-Type': 'application/json',
        RequestParams.auth: Preference.getBearerToken(),
      };
    }

    printWarning("getBearerToken:- $header");
    if (jsonEncoded) {
      body = jsonEncode(body);
    }

    var url = EndPoints.baseUrl + uri;
    if (isLoader) showEasyLoader();
    await http
        .post(Uri.parse(url), body: body, headers: header)
        .then((response) {
      if (isLoader) EasyLoading.dismiss();
      if (response.statusCode == 404) {
        getSnackToast(
            message: LabelKeys.checkInternet.tr,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError);
        onFailure(LabelKeys.checkInternet.tr);
        return;
      }
      Log.displayResponse(payload: body, res: response, requestType: 'POST');

      dynamic json = jsonDecode(response.body);

      if (json['meta']['success']) {
        if (json['meta']['authToken'] != null &&
            json['meta']['authToken'] != '') {
          Preference.setBearerToken(json['meta']['authToken']);
        }
        if (isSuccessMessage) {
          getSnackToast(
              message: json['meta']['message'],
              colorText: Get.context!.theme.colorScheme.onSurface,
              backgroundColor: Get.context!.theme.colorScheme.primaryContainer);
        }
        onSuccess(
          json['data'],
          json['meta']['message'],
          json['meta']['success'],
        );
      } else {
        if (response.statusCode == 200) {
          if (isFailedMessage) {
            getSnackToast(
                message: json['meta']['message'],
                colorText: Colors.white,
                backgroundColor: Colors.red);
          }
          onFailure(json['meta']['message']);
        } else if (response.statusCode == 401) {
          if (isFailedMessage) {
            getSnackToast(
                message: json['meta']['message'],
                colorText: Colors.white,
                backgroundColor: Colors.red);
          }
          onFailure(json['meta']['message']);
          Future.delayed(const Duration(milliseconds: 500)).then((value) {
            handleUnauthorizedError();
          });
        } else if (response.statusCode == 500) {
          RequestManager.getSnackToast(
              message: 'Something went wrong, Try again later...');
        } else if (response.statusCode == 404) {
          RequestManager.getSnackToast(
              message: LabelKeys.checkInternet.tr,
              backgroundColor: Get.theme.colorScheme.error,
              colorText: Get.theme.colorScheme.onError);
        } else {
          responseFailed(
              isBtnLoader, isLoader, json['meta']['message'], onFailure);
        }
      }
    }).catchError((error) {
      printMessage("catchError: $error");
      responseFailed(isBtnLoader, isLoader, error.toString(), onFailure);
    }).timeout(const Duration(seconds: Constants.REQUEST_MAX_TIMEOUT),
            onTimeout: () {
      responseFailed(isBtnLoader, isLoader, 'Error : TimeOut', onFailure);
    });
  }

  /// Make a GET request to the specified [uri].
  ///
  /// The following parameters can be specified:
  ///
  /// * [body]: The request body. If [jsonEncoded] is true, the body is
  ///   first encoded as a JSON string.
  /// * [isBtnLoader]: Whether to display a loader button.
  /// * [jsonEncoded]: Whether to encode the request body as JSON.
  /// * [hasBearer]: Whether to include the bearer token in the request header.
  /// * [isLoader]: Whether to display a full screen loader.
  /// * [isSuccessMessage]: Whether to display a success message.
  /// * [isFailedMessage]: Whether to display a failure message.
  /// * [onSuccess]: The callback that is called when the request is successful.
  /// * [onFailure]: The callback that is called when the request fails.
  /// * [onConnectionFailed]: The callback that is called when the request fails due to a connection error.
  ///
  /// If the request fails, the [onFailure] callback is called with the error
  /// message as a parameter. If the request fails due to a connection error,
  /// the [onConnectionFailed] callback is called instead. If the request is
  /// successful, the [onSuccess] callback is called with the response body
  /// and message as parameters.

  static getRequest(
      {required uri,
      body,
      isBtnLoader = false,
      jsonEncoded = true,
      bool hasBearer = true,
      bool isLoader = false,
      bool isSuccessMessage = true,
      bool isFailedMessage = true,
      required Function(dynamic responseBody, String message) onSuccess,
      required Function onFailure,
      Function? onConnectionFailed}) async {
    if (!await isConnectedNetwork()) {
      getSnackToast(
          message: LabelKeys.checkInternet.tr,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError);
      onFailure(LabelKeys.checkInternet.tr);
      return;
    }
    Map<String, String> header = {
      'Content-Type': 'application/json',
    };
    if (hasBearer) {
      header = {
        'Content-Type': 'application/json-patch+json',
        RequestParams.auth: Preference.getBearerToken()
        //SessionImpl.getToken(),
      };
    }

    if (jsonEncoded) {
      body = jsonEncode(body);
    }

    var url = EndPoints.baseUrl + uri;
    printMessage("URL : $url");
    printMessage("HEADER : ${header.toString()}");
    if (isLoader) showEasyLoader();
    http.get(Uri.parse(url), headers: header).then((response) {
      Log.displayResponse(payload: body, res: response, requestType: 'GET');
      if (isLoader) EasyLoading.dismiss();
      //if (isBtnLoader) gc.isBtnLoading(false);
      var json = jsonDecode(response.body);
      if (json['meta']['success']) {
        if (json['meta']['authToken'] != null &&
            json['meta']['authToken'] != '') {
          Preference.setBearerToken(json['meta']['authToken']);
        }
        if (isSuccessMessage) {
          getSnackToast(
              message: json['meta']['message'],
              colorText: Get.context!.theme.colorScheme.onSurface
                  .withAlpha(Constants.darkAlfa),
              backgroundColor: Get.context!.theme.colorScheme.primaryContainer);
        }
        onSuccess(json['data'], json['meta']['message']);
      } else {
        if (isFailedMessage) {
          responseFailed(
              isBtnLoader, isLoader, json['meta']['message'], onFailure);
        } else {
          onFailure(json['meta']['message']);
        }
      }
    }).catchError((error) {
      responseFailed(isBtnLoader, isLoader, error.toString(), onFailure);
    }).timeout(const Duration(seconds: Constants.REQUEST_MAX_TIMEOUT),
        onTimeout: () {
      responseFailed(isBtnLoader, isLoader, 'Error : TimeOut', onFailure);
    });
  }

  /// Uploads a file to the server.
  ///
  /// This method takes a [File], a url and a boolean value to show a loader or not.
  /// It also takes two functions, one for success and one for failure.
  /// This method will add the bearer token to the request if the boolean value `hasBearer` is true.
  /// If the connection is not available, it will show a toast with a message to check the internet connection.
  /// If the request is successful, it will execute the [onSuccess] function and if the request fails, it will execute the [onFailure] function.
  /// If the boolean value `isSuccessMessage` is true, it will show a toast with a success message.
  /// It will also show a toast with an error message if the request fails.
  /// If the request times out, it will also show a toast with an error message.
  ///
  static uploadImage({
    @required uri,
    required File file,
    Map<String, String>? parameters,
    bool hasBearer = true,
    bool isLoader = false,
    required Function onSuccess,
    required Function onFailure,
    bool isSuccessMessage = true,
    required Function onConnectionFailed,
    required String fileName,
  }) async {
    bool isConnected = await isConnectedNetwork();
    if (!isConnected) {
      onConnectionFailed("Check your internet connection and try again");
      getSnackToast(
        message: "Check your internet connection and try again",
      );
      return;
    }

    Map<String, String> header = {'auth': Preference.getBearerToken()};

    if (isLoader) showEasyLoader();

    var url = EndPoints.baseUrl + uri;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header);
    var stream = http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();
    var multipartFile = http.MultipartFile(fileName, stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);

    if (parameters != null) {
      request.fields.addAll(parameters);
    }

    printMessage("req : $url ${request.files.length}");
    printMessage("req param : ${request.fields.toString()}");
    await request.send().then((resStream) async {
      resStream.stream.transform(utf8.decoder).listen((response) {
        printMessage(response);
        final responseBody = jsonDecode(response.toString());
        Log.displayResponse(
            payload: request.fields, res: responseBody, requestType: 'POST');
        if (isLoader) EasyLoading.dismiss();
        if (isSuccessMessage) {
          getSnackToast(
              message: responseBody['meta']['message'],
              colorText: Get.context!.theme.colorScheme.onSurface
                  .withAlpha(Constants.darkAlfa),
              backgroundColor: Get.context!.theme.colorScheme.primaryContainer);
        }
        onSuccess(responseBody);
      });
    }).catchError((error) {
      if (isLoader) EasyLoading.dismiss();
      printMessage('Error : catchError $error');
      printMessage(url);
      RequestManager.getSnackToast(
          message: error.toString(),
          colorText: Colors.white,
          backgroundColor: Colors.red);

      onFailure(error);
    }).timeout(const Duration(seconds: Constants.REQUEST_MAX_TIMEOUT),
        onTimeout: () {
      if (isLoader) EasyLoading.dismiss();
      printMessage(url);
      printMessage('Error : TimeOut');
      RequestManager.getSnackToast(
          message: 'Error : TimeOut',
          colorText: Colors.white,
          backgroundColor: Colors.red);
      onFailure('Error : TimeOut');
    });
  }

  /// This method is used to upload the image to the server.
  ///
  /// It requires a uri which is the server url to be sent in the request.
  /// It also requires a file which is the image to be uploaded.
  /// It also requires a loader to be shown while the image is being uploaded.
  /// It also requires the bearer token to be sent in the request header.
  /// It also requires the fileName of the image which is the image to be uploaded.
  /// It also requires the fileNameThumb of the image which is the thumbnail of
  /// the image to be uploaded.
  /// If the image is uploaded successfully, it will return the uploaded
  /// image name in the response body.
  /// If the image is not uploaded successfully, it will return the error
  /// message in the response body.
  static uploadImageThumb(
      {@required uri,
      required File file,
      required File fileThumb,
      Map<String, String>? parameters,
      bool hasBearer = true,
      bool isLoader = false,
      required Function onSuccess,
      required Function onFailure,
      required Function onConnectionFailed,
      required String fileName,
      required String fileNameThumb}) async {
    bool isConnected = await isConnectedNetwork();
    if (!isConnected) {
      onConnectionFailed("Check your internet connection and try again");
      getSnackToast(
        message: "Check your internet connection and try again",
      );
      return;
    }

    Map<String, String> header = {'auth': Preference.getBearerToken()};

    if (isLoader) showEasyLoader();

    var url = EndPoints.baseUrl + uri;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header);

    List<http.MultipartFile> newList = [];

    for (int i = 0; i < 2; i++) {
      if (i == 0) {
        var stream = http.ByteStream(Stream.castFrom(file.openRead()));
        var length = await file.length();
        printMessage("file length $length");
        var multipartFile = http.MultipartFile(fileName, stream, length,
            filename: basename(file.path));
        newList.add(multipartFile);
      } else {
        var streamThumb =
            http.ByteStream(Stream.castFrom(fileThumb.openRead()));
        var lengthThumb = await fileThumb.length();
        printMessage("fileThumb length $lengthThumb");
        var multipartFileThumb = http.MultipartFile(
            fileNameThumb, streamThumb, lengthThumb,
            filename: basename(fileThumb.path));
        newList.add(multipartFileThumb);
      }
    }

    /* var stream = http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();
    var multipartFile = await http.MultipartFile(fileName, stream, length,
        filename: basename(file.path));

    var streamThumb = http.ByteStream(Stream.castFrom(fileThumb.openRead()));
    var lengthThumb = await fileThumb.length();
    var multipartFileThumb = await http.MultipartFile(
        fileNameThumb, streamThumb, lengthThumb,
        filename: basename(fileThumb.path));*/

    request.files.addAll(newList);
    // request.files.add(multipartFileThumb);

    if (parameters != null) {
      request.fields.addAll(parameters);
    }
    //printMessage("req : $url ${request.files.length}");
    for (int i = 0; i < request.files.length; i++) {
      printMessage("FILE : ${request.files[i].toString()}");
    }
    for (int i = 0; i < request.fields.length; i++) {
      printMessage("req param : ${request.fields[i].toString()}");
    }
    try {
      await request.send().then((resStream) async {
        resStream.stream.transform(utf8.decoder).listen((response) {
          printMessage(response);
          final responseBody = jsonDecode(response.toString());
          Log.displayResponse(
              payload: request.fields, res: responseBody, requestType: 'POST');
          if (isLoader) EasyLoading.dismiss();
          onSuccess(responseBody);
        });
      }).catchError((error) {
        if (isLoader) EasyLoading.dismiss();
        printMessage('Error : catchError $error');
        printMessage(url);
        RequestManager.getSnackToast(
            message: error.toString(),
            colorText: Colors.white,
            backgroundColor: Colors.red);
        onFailure(error);
      }).timeout(const Duration(seconds: Constants.REQUEST_MAX_TIMEOUT),
          onTimeout: () {
        if (isLoader) EasyLoading.dismiss();
        printMessage(url);
        printMessage('Error : TimeOut');
        RequestManager.getSnackToast(
            message: 'Error : TimeOut',
            colorText: Colors.white,
            backgroundColor: Colors.red);
        onFailure('Error : TimeOut');
      });
    } catch (e) {
      printMessage("Catch error ${e.toString()}");
    }
  }

  /// This method is used to upload an image to the server.
  ///
  /// It requires a uri which is the server url to be sent in the request.
  /// It also requires a file which is the image to be uploaded.
  /// It also requires a loader to be shown while the image is being uploaded.
  /// It also requires the bearer token to be sent in the request header.
  /// If the image is uploaded successfully, it will return the uploaded
  /// image name in the response body.
  /// If the image is not uploaded successfully, it will return the error
  /// message in the response body.
  static uploadEventImage({
    @required uri,
    required File file,
    Map<String, String>? parameters,
    bool hasBearer = true,
    bool isLoader = false,
    required Function onSuccess,
    required Function onFailure,
    required Function onConnectionFailed,
  }) async {
    bool isConnected = await isConnectedNetwork();
    if (!isConnected) {
      onConnectionFailed("Check your internet connection and try again");
      getSnackToast(
        message: "Check your internet connection and try again",
      );
      return;
    }

    Map<String, String> header = {'auth': Preference.getBearerToken()};

    if (isLoader) showEasyLoader();

    var url = EndPoints.baseUrl + uri;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header);

    var stream = http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();
    var multipartFile = http.MultipartFile('eventPhotos', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);

    if (parameters != null) {
      request.fields.addAll(parameters);
    }

    printMessage("req : $url ${request.files.length}");
    printMessage("req param : ${request.fields.toString()}");
    await request.send().then((resStream) async {
      resStream.stream.transform(utf8.decoder).listen((response) {
        final responseBody = jsonDecode(response.toString());
        Log.displayResponse(
            payload: request.fields, res: responseBody, requestType: 'POST');
        if (isLoader) EasyLoading.dismiss();
        onSuccess(responseBody);
      });
    }).catchError((error) {
      if (isLoader) EasyLoading.dismiss();
      printMessage('Error : catchError $error');
      printMessage(url);
      RequestManager.getSnackToast(
          message: error.toString(),
          colorText: Colors.white,
          backgroundColor: Colors.red);

      onFailure(error);
    }).timeout(const Duration(seconds: Constants.REQUEST_MAX_TIMEOUT),
        onTimeout: () {
      if (isLoader) EasyLoading.dismiss();
      printMessage(url);
      printMessage('Error : TimeOut');
      RequestManager.getSnackToast(
          message: 'Error : TimeOut',
          colorText: Colors.white,
          backgroundColor: Colors.red);
      onFailure('Error : TimeOut');
    });
  }

  /// Uploads an artwork image to the server.
  ///
  /// This method uploads an image file to the specified [uri] using a multipart
  /// POST request. It supports optional parameters and headers, including a
  /// bearer token if [hasBearer] is set to true.
  ///
  /// The [file] parameter is the image file to be uploaded.
  ///
  /// If [parameters] are provided, they are included as form fields in the request.
  ///
  /// If [isLoader] is true, a loading indicator is shown during the upload.
  ///
  /// The [onSuccess] callback is invoked with the response data if the upload is successful.
  ///
  /// The [onFailure] callback is invoked with an error message if the upload fails.
  ///
  /// The [onConnectionFailed] callback is invoked with a message if there is no internet connection.
  ///
  /// Throws a timeout error if the request takes longer than the specified timeout duration.

  static uploadArtworkImage({
    @required uri,
    required File file,
    Map<String, String>? parameters,
    bool hasBearer = true,
    bool isLoader = false,
    required Function onSuccess,
    required Function onFailure,
    required Function onConnectionFailed,
  }) async {
    bool isConnected = await isConnectedNetwork();
    if (!isConnected) {
      onConnectionFailed("Check your internet connection and try again");
      getSnackToast(
        message: "Check your internet connection and try again",
      );
      return;
    }

    Map<String, String> header = {'auth': Preference.getBearerToken()};

    if (isLoader) showEasyLoader();

    var url = EndPoints.baseUrl + uri;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header);

    var stream = http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();
    var multipartFile = http.MultipartFile('artworkImage', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);

    if (parameters != null) {
      request.fields.addAll(parameters);
    }

    printMessage("req : $url ${request.files.length}");
    printMessage("req param : ${request.fields.toString()}");
    await request.send().then((resStream) async {
      resStream.stream.transform(utf8.decoder).listen((response) {
        final responseBody = json.decode(response);
        Log.displayResponse(
            payload: request.fields, res: responseBody, requestType: 'POST');
        if (isLoader) EasyLoading.dismiss();
        onSuccess(responseBody['data']);
      });
    }).catchError((error) {
      if (isLoader) EasyLoading.dismiss();
      printMessage('Error : catchError $error');
      printMessage(url);
      RequestManager.getSnackToast(
          message: error.toString(),
          colorText: Colors.white,
          backgroundColor: Colors.red);

      onFailure(error);
    }).timeout(const Duration(seconds: Constants.REQUEST_MAX_TIMEOUT),
        onTimeout: () {
      if (isLoader) EasyLoading.dismiss();
      printMessage(url);
      printMessage('Error : TimeOut');
      RequestManager.getSnackToast(
          message: 'Error : TimeOut',
          colorText: Colors.white,
          backgroundColor: Colors.red);
      onFailure('Error : TimeOut');
    });
  }

  
  /// Handles failed responses from the API.
  ///
  /// This method is called when an API request fails.
  ///
  /// If [isBtnLoader] is true, a button loader is hidden.
  ///
  /// If [isLoader] is true, a full-screen loader is hidden.
  ///
  /// A toast message is shown with the [message] provided.
  ///
  /// The [onFailure] callback is invoked with the [message] provided.
  ///
  /// If the message is "Token Mismatched.", "Token is mismatched", or
  /// "Authorization token is required", the user is logged out after a 2
  /// second delay.
  static void responseFailed(
      bool isBtnLoader, bool isLoader, String message, Function onFailure) {
    printMessage(message);
    if (isLoader) EasyLoading.dismiss();
    getSnackToast(
        message: message, colorText: Colors.white, backgroundColor: Colors.red);
    onFailure(message);

    if (message == 'Token Mismatched.' ||
        message == "Token is mismatched" ||
        message == 'Authorization token is required') {
      Future<void>.delayed(const Duration(seconds: 2)).then((value) {
        handleUnauthorizedError();
      });
    }
  }

  
  /// Shows a snack bar with a message.
  ///
  /// The message is specified by [message]. If [message] is not provided, a
  /// default message of "Alert" is used.
  ///
  /// The color of the text is specified by [colorText]. If [colorText] is not
  /// provided, the default text color of the theme is used.
  ///
  /// The background color of the snack bar is specified by [backgroundColor].
  /// If [backgroundColor] is not provided, the default background color of the
  /// theme is used.
  ///
  /// The style of the text is specified by [contentTextStyle]. If
  /// [contentTextStyle] is not provided, the default text style of the theme is
  /// used.
  ///
  /// The snack bar is shown using [ScaffoldMessenger.showSnackBar].
  ///
  /// The snack bar is floating, meaning it will not block the underlying
  /// content.
  static void getSnackToast(
      {String message = "Alert",
      Color? colorText,
      Color? backgroundColor,
      TextStyle? contentTextStyle}) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: contentTextStyle ?? TextStyle(color: colorText),
      ),
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  /*static getSnackToast({
    title = "Alert",
    message = '',
    snackPosition = SnackPosition.TOP,
    backgroundColor = Colors.red,
    colorText = Colors.white,
    Widget? icon,
    Duration duration = const Duration(milliseconds: 3000),
    Function? onTapSnackBar,
    Function? onTapButton,
    bool withButton = false,
    buttonText = 'Ok',
    Function? onDismissed,
  }) {
    if (isActive) {
      return;
    }
    isActive = true;
    Get.snackbar(
      title,
      message,
      mainButton: withButton
          ? TextButton(
              onPressed: () {
                if (onTapButton != null) onTapButton();
              },
              child: Text(buttonText))
          : null,
      onTap: (tap) {
        if (onTapSnackBar != null) onTapSnackBar(tap);
      },
      margin: const EdgeInsets.all(AppDimens.paddingLarge),
      duration: duration,
      isDismissible: true,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      icon: icon,
      colorText: Colors.white,
      snackbarStatus: (status) {
        if (kDebugMode) {
          print(status);
        }
        if (status == SnackbarStatus.CLOSED) {
          isActive = false;
          if (onDismissed != null) onDismissed();
        }
      },
    );
  }*/

  /// Show a loading indicator using the EasyLoading package, with a custom appearance.
  ///
  /// The indicator is a three-bounce animation with a custom color and font, and is
  /// displayed for 3 seconds. The user cannot interact with the app while the indicator
  /// is visible.
  static void showEasyLoader() {
    EasyLoading.instance
      ..displayDuration = const Duration(seconds: 3)
      ..indicatorType = EasyLoadingIndicatorType.threeBounce
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 50.0
      ..radius = 10.0
      ..progressColor = Colors.transparent
      ..backgroundColor = Colors.transparent
      ..boxShadow = <BoxShadow>[]
      ..indicatorColor = Get.theme.colorScheme.primary
      ..textColor = Colors.white
      ..textStyle = const TextStyle(fontSize: 22, fontStyle: FontStyle.italic)
      ..maskColor = Colors.grey.withOpacity(0.5)
      ..userInteractions = false
      ..maskType = EasyLoadingMaskType.custom;
    EasyLoading.show();
  }


  /// Handle unauthorized error by refreshing the token if not already in progress.
  ///
  /// This method checks if token refreshing is currently not in progress, sets
  /// the flag to indicate token refreshing, clears user preferences, and navigates
  /// the user to the login screen.

  static void handleUnauthorizedError() {
    if (!isRefreshingToken) {
      isRefreshingToken = true;
      Preference.clearPreference();
      Get.offAllNamed<void>(Routes.LOGIN);
    }
  }
}
