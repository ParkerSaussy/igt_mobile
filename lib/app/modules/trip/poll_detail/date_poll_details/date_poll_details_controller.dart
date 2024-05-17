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

  void onIndexChange(TripDetailsModel tripDetailsModel) async {
    tripDetailsModelObject = tripDetailsModel;
    printMessage(
        "Trip Id: ${tripDetailsModel.id} Trip Name: ${tripDetailsModel.tripName}");
    getTripDatePollList(tripDetailsModel.id.toString());
  }

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
