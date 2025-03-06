import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_date_poll_model.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class DatePollDetailsController extends GetxController {
  //TODO: Implement DatePollDetailsController

  RxList<TripDetailsDatePollModel> lstTripDatePoll =
      <TripDetailsDatePollModel>[].obs;
  RxString restorationId = ''.obs;
  TripDetailsModel? tripDetailsModelObject;

  /// Called when the user changes the index of the bottom tab bar.
  ///
  /// It assigns the selected trip to [tripDetailsModelObject] and
  /// calls [getTripDatePollList] to populate [lstTripDatePoll]
  /// with date poll details associated with the selected trip.
  void onIndexChange(TripDetailsModel tripDetailsModel) async {
    tripDetailsModelObject = tripDetailsModel;
    printMessage(
        "Trip Id: ${tripDetailsModel.id} Trip Name: ${tripDetailsModel.tripName}");
    getTripDatePollList(tripDetailsModel.id.toString());
  }

  /// Gets trip date poll details from API.
  ///
  /// This method is used to get trip date poll details from API.
  /// It takes trip id as parameter and returns trip date poll details
  /// associated with the trip.
  /// If request is successfull, it assigns response to [lstTripDatePoll]
  /// and sets [restorationId] with a random string.
  /// If request is failed, it shows easy loading.
  void getTripDatePollList(String tripId) {
    RequestManager.postRequest(
      uri: EndPoints.getDatesPollDetails,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: {RequestParams.tripId: tripId},
      onSuccess: (responseBody, message, status) {
        lstTripDatePoll.value.clear();
        lstTripDatePoll.value = List<TripDetailsDatePollModel>.from(
            responseBody.map((x) => TripDetailsDatePollModel.fromJson(x)));
        restorationId.value = getRandomString();
        printMessage("lstTripDatePoll.value: ${lstTripDatePoll.value.length}");
      },
      onFailure: (error) {},
    );
  }
}
