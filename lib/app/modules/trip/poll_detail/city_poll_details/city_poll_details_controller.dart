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

  void onIndexChange(TripDetailsModel tripDetailsModel) async {
    tripDetailsModelObject = tripDetailsModel;
    isTripDetailsLoaded.value = true;
    getTripCityPollList();
  }

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
