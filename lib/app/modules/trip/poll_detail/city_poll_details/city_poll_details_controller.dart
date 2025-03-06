import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_city_poll_model.dart';
import 'package:lesgo/app/models/trip_details_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class CityPollDetailsController extends GetxController {
  //TODO: Implement CityPollDetailsController

  RxString restorationIdCity = ''.obs;
  TripDetailsModel? tripDetailsModelObject;
  RxBool isTripDetailsLoaded = false.obs;
  RxList<TripDetailsCityPollModel> lstTripDetailsCityPoll =
      <TripDetailsCityPollModel>[].obs;

  /// Called when the user changes the index of the bottom tab bar.
  ///
  /// It assigns the selected trip to [tripDetailsModelObject] and
  /// sets [isTripDetailsLoaded] to true.
  /// It then calls [getTripCityPollList] to populate [lstTripDetailsCityPoll]
  /// with city poll details associated with the selected trip.
  void onIndexChange(TripDetailsModel tripDetailsModel) async {
    tripDetailsModelObject = tripDetailsModel;
    isTripDetailsLoaded.value = true;
    getTripCityPollList();
  }

  /// Fetches the list of city poll details for the current trip.
  ///
  /// This method sends a post request to the server to retrieve city poll
  /// details associated with the trip identified by [tripDetailsModelObject.id].
  /// If the request is successful, [lstTripDetailsCityPoll] is populated with
  /// the response data mapped to [TripDetailsCityPollModel] objects, and
  /// [restorationIdCity] is updated with a new random string.
  /// The request includes a bearer token and displays a loader during the
  /// process. No success or failure messages are displayed.

  void getTripCityPollList() {
    RequestManager.postRequest(
      uri: EndPoints.getCityPollDetails,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: false,
      isFailedMessage: false,
      body: {RequestParams.tripId: tripDetailsModelObject!.id!},
      onSuccess: (responseBody, message, status) {
        lstTripDetailsCityPoll.value = List<TripDetailsCityPollModel>.from(
            responseBody.map((x) => TripDetailsCityPollModel.fromJson(x)));
        restorationIdCity.value = getRandomString();
      },
      onFailure: (error) {},
    );
  }
}
