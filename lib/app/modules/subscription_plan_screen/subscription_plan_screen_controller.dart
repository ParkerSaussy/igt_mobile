import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/single_plan_model.dart';
import 'package:lesgo/app/models/user_data.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/generic_class/paypal_payment.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';
import 'package:pay/pay.dart';

class SubscriptionPlanScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxString planRestorationId = "".obs;
  RxString purchasedRestorationId = "".obs;
  RxList<SinglePlanModel> lstSinglePlan = <SinglePlanModel>[].obs;
  SinglePlanModel? singlePlanModel;
  RxBool planFatch = false.obs;
  List<PaymentItem> paymentItems = [];

  @override
  void onInit() {
    super.onInit();
    getSingleTripPlan();
  }

  /// Gets single trip plan from API.
  ///
  /// This method sends a POST request to the [EndPoints.getPlans] endpoint.
  /// It shows an easy loader while the request is in progress.
  /// If the request is successful, it updates the [lstSinglePlan] with the response
  /// data, sets the first single trip plan as selected, and opens the subscription
  /// bottom sheet.
  /// If the request fails, it dismisses the easy loader.
  void getSingleTripPlan() {
    RequestManager.postRequest(
      uri: EndPoints.getPlans,
      hasBearer: true,
      isLoader: true,
      body: {RequestParams.type: PlanType.normalPlan},
      onSuccess: (responseBody, message, status) {
        lstSinglePlan.value = List<SinglePlanModel>.from(
            responseBody.map((x) => SinglePlanModel.fromJson(x)));
        if (lstSinglePlan.isNotEmpty) {
          for (int i = 0; i < lstSinglePlan.length; i++) {
            if (gc.loginData.value.planId == lstSinglePlan[i].id) {
              lstSinglePlan[i].isPlanPurchased = true;
              singlePlanModel = lstSinglePlan[i];
              purchasedRestorationId.value = getRandomString();
              lstSinglePlan.removeAt(i);
            }
          }
        }
        selectedIndex.value = -1;
        planRestorationId.value = getRandomString();
        planFatch.value = true;
      },
      onFailure: (error) {},
    );
  }

  /// Calculates the plan duration in years and months.
  ///
  /// This method takes the index of a plan from [lstSinglePlan] and calculates its
  /// duration in terms of years and months. If the duration is 12 months or more,
  /// it converts the duration into years and months. If the duration is less than
  /// 12 months, it returns the duration in months. The result is formatted as a
  /// string with translated year and month labels.
  ///
  /// Returns a formatted string representing the plan's duration.

  String yearCalculate(int index) {
    String totalYear = "";
    if (lstSinglePlan[index].duration >= 12) {
      double year = lstSinglePlan[index].duration / 12;
      final months = lstSinglePlan[index].duration % 12;
      if (months > 0) {
        totalYear =
            "${(((year.abs()).floor()))} ${LabelKeys.years.tr} $months ${LabelKeys.months.tr}";
      } else {
        totalYear = "${year.toStringAsFixed(0)} ${LabelKeys.planYears.tr}";
      }
    } else {
      totalYear =
          "${lstSinglePlan[index].duration.toString()} ${LabelKeys.planMonths.tr}";
    }
    return totalYear;
  }

  /// Calculates the duration of an activated plan in years and months.
  ///
  /// This method takes a duration in months and calculates its duration in terms
  /// of years and months. If the duration is 12 months or more, it converts the
  /// duration into years and months. If the duration is less than 12 months, it
  /// returns the duration in months. The result is formatted as a string with
  /// translated year and month labels.
  ///
  /// Returns a formatted string representing the plan's duration.
  String activatedYearCalculate(int duration) {
    String totalYear = "";
    if (duration >= 12) {
      double year = duration / 12;
      final months = duration % 12;
      if (months > 0) {
        totalYear =
            "${(((year.abs()).floor()))} ${LabelKeys.years.tr} $months ${LabelKeys.months.tr}";
      } else {
        totalYear = "${year.toStringAsFixed(0)} ${LabelKeys.planYears.tr}";
      }
    } else {
      totalYear = "${duration.toString()} ${LabelKeys.planMonths.tr}";
    }
    return totalYear;
  }

  /// Calculates the percentage discount for a given plan.
  ///
  /// This method takes the index of a plan from [lstSinglePlan] and calculates its
  /// discount percentage. The discount percentage is calculated by subtracting
  /// the discounted price from the actual price and then dividing the result by
  /// the actual price, multiplied by 100.
  ///
  /// Returns the discount percentage as a double.
  double percentageCalculate(int index) {
    double percentageValue = 0.0;
    final discountedPrice = lstSinglePlan[index].discountedPrice;
    final actualPrice = lstSinglePlan[index].price;
    percentageValue = 100 -
        (double.parse(discountedPrice.toString()) *
            100 /
            (double.parse(actualPrice.toString())));
    return percentageValue;
  }

  /// Makes a request to the server to purchase a plan.
  ///
  /// This method takes the payment data from either PayPal or Apple Pay and
  /// makes a POST request to the [EndPoints.purchasePlan] endpoint to purchase a
  /// plan. If the request is successful, it updates the user data and navigates
  /// back to the previous screen.
  ///
  /// The [data] parameter is the payment data from either PayPal or Apple Pay.
  /// The [fromApple] parameter is a boolean indicating whether the payment data
  /// comes from Apple Pay or PayPal. The [transactionIdentifier] parameter is the
  /// transaction identifier for the payment if it comes from Apple Pay.
  void purchasePlanAPI(data, bool fromApple, String transactionIdentifier) {
    RequestManager.postRequest(
      uri: EndPoints.purchasePlan,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: true,
      body: {
        RequestParams.planType: PlanType.normalPlan,
        RequestParams.planId: lstSinglePlan[selectedIndex.value].id,
        RequestParams.price: lstSinglePlan[selectedIndex.value].price,
        RequestParams.duration: lstSinglePlan[selectedIndex.value].duration,
        RequestParams.transactionId:
            fromApple ? transactionIdentifier : data.orderId,
        RequestParams.paymentThrough: fromApple ? 'apple_pay' : 'paypal',
      },
      onSuccess: (responseBody, message, status) {
        var userModel = userDataFromJson(jsonEncode(responseBody));
        Preference.setLoginResponse(userModel);
        getSingleTripPlan();
        planRestorationId.value = getRandomString();
        purchasedRestorationId.value = getRandomString();
        planFatch.value = false;
      },
      onFailure: (error) {},
    );
  }

  /// Handles the result of an Apple Pay payment.
  ///
  /// This method is called when the Apple Pay payment sheet is completed.
  /// It prints the payment result and transaction identifier to the console,
  /// and then calls [purchasePlanAPI] to send the payment result to the server.
  ///
  /// The [paymentResult] parameter is a map containing the result of the Apple
  /// Pay payment sheet. The map must contain the "transactionIdentifier" key.
  ///
  void onApplePayResult(paymentResult) {
    printMessage("paymentResult: $paymentResult");
    printMessage(
        "transactionIdentifier: ${paymentResult["transactionIdentifier"]}");
    purchasePlanAPI(null, true, paymentResult["transactionIdentifier"]);
    // Send the resulting Apple Pay token to your server / PSP
  }

  /// Makes a payment using PayPal.
  ///
  /// This method is called when the user taps on the "Unlock Trip" button.
  /// It shows an easy loader and makes a payment request using the PayPal
  /// payment service. When the payment is successful, it calls
  /// [purchasePlanAPI] to send the payment result to the server.
  void makePayment() {
    RequestManager.showEasyLoader();
    payPalCallBackMethods();
    PayPalPayment.makePayment(
      amount: double.parse(lstSinglePlan[selectedIndex.value].discountedPrice!),
    );
  }

  /// Sets callbacks for PayPal payment service.
  ///
  /// This method sets callbacks for the PayPal payment service. The callbacks
  /// are called when the user cancels the payment, when the payment is successful,
  /// or when there is an error with the payment. The callbacks are also called
  /// when the shipping address is changed.
  ///
  /// The callbacks are set using the [FPayPalOrderCallback] class, which provides
  /// a set of methods that can be overridden to handle the different callback
  /// events. The callbacks are called with a [FPayPalApprovalData] object as an
  /// argument, which contains the result of the payment.
  void payPalCallBackMethods() {
    //call backs for payment
    PayPalPayment.flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          EasyLoading.dismiss();
        },
        onSuccess: (data) {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          purchasePlanAPI(data, false, "");
        },
        onError: (data) {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          EasyLoading.dismiss();
          RequestManager.getSnackToast(message: data.reason);
        },
        onShippingChange: (data) {
          EasyLoading.dismiss();
          RequestManager.getSnackToast(
              message: data.shippingChangeAddress?.adminArea1 ?? "");
        },
      ),
    );
  }
}
