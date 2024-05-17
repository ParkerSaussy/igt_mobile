import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/networking/request_manager.dart';
import '../../../models/added_guest_model.dart';
import '../../../models/share_list.dart';

class AddExpansesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController addExpenseController = TextEditingController();
  final TextEditingController addDescController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  var descCount = '250'.obs;
  RxString onDate = "".obs;
  RxInt tripID = 0.obs;
  var selectedGuestIndex = 0.obs;
  RxList<AddedGuestmodel> tripGuestList = <AddedGuestmodel>[].obs;
  RxBool isListAvailable = false.obs;
  var restorationId = "".obs;
  RxString paidBy = LabelKeys.pleaseSelect.tr.obs;
  RxInt guestId = 0.obs;
  RxList<ShareList> shareList = <ShareList>[].obs;
  RxString split = LabelKeys.cBlankAddExpenseSelectMembers.tr.obs;

  @override
  void onInit() {
    super.onInit();
    final currentDate = DateTime.now();
    final String strPickedDate = DateFormat("MMM dd, yyyy").format(currentDate);
    onDate.value = strPickedDate;
    descCount.value = (250 - (addDescController.text.length)).toString();
    tripID.value = Get.arguments[0];
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
          update();
        },
        onFailure: (error) {
          tripGuestList.clear();
          printMessage("error: $error");
        });
  }

  getSelectedGuest() {
    for (int i = 0; i < tripGuestList.length; i++) {
      if (tripGuestList[i].isSelected) {
        return tripGuestList[i];
      }
    }
    return null; // Return null if no guest is selected
  }

  void addExpense() {
    RequestManager.postRequest(
        uri: EndPoints.addExpense,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {
          RequestParams.tripID: tripID.value,
          RequestParams.paidBy: guestId.value,
          RequestParams.amount: amountController.text,
          RequestParams.description: addDescController.text,
          RequestParams.expenseName: addExpenseController.text,
          RequestParams.expenseOn: DateFormat('yyyy-MM-dd')
              .format(DateFormat('MMM dd, yyyy').parse(onDate.value)),
          RequestParams.type: 'Expense',
          RequestParams.shareList: shareList
        },
        onSuccess: (responseBody, message, status) {
          if (status) {
            RequestManager.getSnackToast(
                message: message,
                colorText: Get.context!.theme.colorScheme.onSurface,
                backgroundColor:
                    Get.context!.theme.colorScheme.primaryContainer);
            reset();
          }
        },
        onFailure: (error) {
          printMessage("error: $error");
        });
  }

  void reset() {
    final currentDate = DateTime.now();
    final String strPickedDate = DateFormat("MMM dd, yyyy").format(currentDate);
    onDate.value = strPickedDate;
    addExpenseController.text = "";
    addDescController.text = "";
    amountController.text = "";
    descCount.value = "250";
    paidBy.value = LabelKeys.pleaseSelect.tr;
    guestId.value = 0;
    shareList.clear();
    split.value = LabelKeys.cBlankAddExpenseSelectMembers.tr;
    activationMode.value = AutovalidateMode.disabled;
  }
}
