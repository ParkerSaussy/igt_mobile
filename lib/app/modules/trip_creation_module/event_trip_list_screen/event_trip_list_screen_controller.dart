import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_list_model.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/general_utils/common_stuff.dart';

class EventTripListScreenController extends GetxController {
  //TODO: Implement EventTripListScreenController

  RxList<TripListModel> lstTrip = <TripListModel>[].obs;
  RxList<TripListModel> lstTripSearch = <TripListModel>[].obs;
  RxString restorationId = "".obs;
  int? tripId;
  RxBool isTripFetch = false.obs;
  RxBool isDataLoading = true.obs;
  RxBool isHostOrCoHost = false.obs;
  RxBool isTripFinalized = false.obs;
  @override
  void onInit() {
    super.onInit();
    tripId = Get.arguments[0];
    isHostOrCoHost.value = Get.arguments[1];
    isTripFinalized.value = Get.arguments[2];
    callApiForGetTripList();
  }

  /// Gets list of trips from API.
  ///
  /// This method is used to get list of trips from API.
  /// It posts request to [EndPoints.getTripsList] with [RequestParams.tripType] set to "all".
  /// If request is successfull, it assigns response to [lstTrip] and sets [isTripFetch] based
  /// on whether the list is not empty. It also sets a random value to [restorationId] and
  /// sets [isDataLoading] to false.
  /// If request is failed, it sets [isTripFetch] to false and [isDataLoading] to false.
  void callApiForGetTripList() {
    RequestManager.postRequest(
        uri: EndPoints.getTripsList,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {RequestParams.tripType: "all"},
        onSuccess: (responseBody, message, status) {
          lstTrip.value = List<TripListModel>.from(
            responseBody.map(
              (x) => TripListModel.fromJson(x),
            ),
          );
          lstTripSearch.value = lstTrip;
          if (lstTrip.isNotEmpty) {
            isTripFetch.value = true;
          } else {
            isTripFetch.value = false;
          }
          isDataLoading.value = false;
          restorationId.value = getRandomString();
        },
        onFailure: (error) {
          printMessage("error: $error");
          isTripFetch.value = false;
          isDataLoading.value = false;
        });
  }
}
