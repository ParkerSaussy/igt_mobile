import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/share_list.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/networking/request_manager.dart';
import '../../../models/added_guest_model.dart';
import '../../activities/activities_detail/activities_detail_controller.dart';

class ExpanseGuestListTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool unselected = false.obs;
  RxBool showCheckbox = true.obs;
  RxBool showRemainingAmount = false.obs;
  TabController? splitController;
  RxList<TextEditingController> textEditingController =
      <TextEditingController>[].obs;
  List<double> textFieldValues = [];
  RxList<AddedGuestmodel> tripGuestList = <AddedGuestmodel>[].obs;
  RxInt tripID = 0.obs;
  RxString amount = "".obs;
  RxBool isListAvailable = false.obs;
  var restorationId = "".obs;
  RxList<AddedGuestmodel> selectedGuestList = <AddedGuestmodel>[].obs;
  RxDouble amountDividedUnequally = 0.0.obs;
  final customDebouncer = CustomDebouncer(milliseconds: 1000);
  RxList<ShareList> shareList = <ShareList>[].obs;
  RxInt guestId = 0.obs;
  RxString remainingAmount = "".obs;
  RxString selectedTab = LabelKeys.equally.tr.obs;

  @override
  void onInit() {
    super.onInit();
    splitController = TabController(length: 2, vsync: this);
    tripID.value = Get.arguments[0];
    amount.value = Get.arguments[1];
    guestId.value = Get.arguments[2];
    printMessage("guestId.value ${guestId.value}");
    remainingAmount.value = amount.toString();
    callGuestListApi();
  }

  void callGuestListApi() {
    RequestManager.postRequest(
        uri: EndPoints.getTripGuestList,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {RequestParams.tripId: tripID.value},
        onSuccess: (responseBody, message, status) {
          tripGuestList.clear();
          tripGuestList.value = List<AddedGuestmodel>.from(
              responseBody.map((x) => AddedGuestmodel.fromJson(x)));
          if (tripGuestList.isNotEmpty) {
            isListAvailable.value = true;
          } else {
            isListAvailable.value = false;
          }
          for (var trip in tripGuestList) {
            trip.isSelected = true;
          }
          for (int i = 0; i < tripGuestList.length; i++) {
            textEditingController.add(TextEditingController());
          }
          for (int i = 0; i < tripGuestList.length; i++) {
            if (tripGuestList[i].id == guestId.value) {
              textEditingController[i].text = remainingAmount.value;
              textFieldValues.add(double.parse(textEditingController[i].text));
            }
          }
          selectedGuestList.addAll(tripGuestList);

          update();
        },
        onFailure: (error) {
          tripGuestList.clear();
          printMessage("error: $error");
        });
  }

  String amountDividedInGuest() {
    double amountDivided = 0;
    if (selectedGuestList.isEmpty) {
      RequestManager.getSnackToast(message: LabelKeys.selectedItemEmpty.tr);
      //amountDivided = double.parse(amount.value) / tripGuestList.length;
    } else {
      amountDivided = double.parse(amount.value) / selectedGuestList.length;
    }
    return amountDivided.toStringAsFixed(2);
  }
}
