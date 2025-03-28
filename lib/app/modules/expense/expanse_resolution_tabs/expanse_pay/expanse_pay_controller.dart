import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../../../../../master/networking/request_manager.dart';
import '../../../../models/expense_resolutions.dart';

class ExpansePayController extends GetxController {
  //TODO: Implement ExpansePayController
  final TextEditingController unequalController = TextEditingController();
  RxString payment = "0".obs;
  int tripId = 0;
  ExpenseResolutions? model;
  double? amount;
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> expenseFormKey =
      GlobalKey<FormState>(debugLabel: "expense");
  @override
  void onInit() {
    super.onInit();
    tripId = Get.arguments[0];
    model = Get.arguments[1];
    printMessage("tripId $tripId");
    printMessage("amount $amount");
    amount = model?.amount;
    if (amount! < 0) {
      amount = (amount! * (-1));
    }
    unequalController.text = amount!.toStringAsFixed(2);
  }

  @override
  void onClose() {
    unequalController.dispose();
    super.onClose();
  }

  /// Returns a Venmo payment link.
  ///
  /// If [userName] is null, returns the base URL for Venmo payment links.
  /// Otherwise, returns a payment link with the user name, transaction type
  /// set to "pay" and the amount set to [amount].
  ///
  String getVenmoPaymentLink(String? userName, String amount) {
    String url = "";
    url = "https://account.venmo.com/";
    if (userName != null) {
      url = "${url}payment-link?recipients=%2$userName";
      url = "$url&txn=pay&amount=$amount";
    }
    return url;
  }

  /// Returns a PayPal payment link.
  ///
  /// If [userName] is null, returns the base URL for PayPal payment links.
  /// Otherwise, returns a payment link with the user name.
  ///
  String getPaypalLink(String? userName) {
    String url = "";
    url = "https://paypal.me/";
    if (userName != null) {
      url = "$url$userName";
    }
    return url;
  }

  /// Initiates a payment to a user for a specific trip expense.
  ///
  /// This method sends a POST request to the [EndPoints.payExpense] endpoint
  /// with the trip ID, creditor ID, amount to be paid, and the ID of the user
  /// making the payment. Upon a successful request, it displays a success toast
  /// message and navigates back. If the request fails, it logs the error and
  /// navigates back.

  void payToUser() {
    RequestManager.postRequest(
        uri: EndPoints.payExpense,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {
          RequestParams.tripID: tripId.toString(),
          RequestParams.creditor: model?.opp.toString(),
          RequestParams.amount: unequalController.text,
          RequestParams.paidBy: gc.loginData.value.id,
        },
        onSuccess: (responseBody, message, status) {
          if (status) {
            RequestManager.getSnackToast(
                message: message,
                colorText: Get.context!.theme.colorScheme.onSurface,
                backgroundColor:
                    Get.context!.theme.colorScheme.primaryContainer);
          }
          Get.back();
        },
        onFailure: (error) {
          printMessage("error: $error");
          Get.back();
        });
  }
}
