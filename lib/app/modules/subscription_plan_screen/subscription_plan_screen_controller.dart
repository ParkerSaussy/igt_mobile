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

  void onApplePayResult(paymentResult) {
    printMessage("paymentResult: $paymentResult");
    printMessage(
        "transactionIdentifier: ${paymentResult["transactionIdentifier"]}");
    purchasePlanAPI(null, true, paymentResult["transactionIdentifier"]);
    // Send the resulting Apple Pay token to your server / PSP
  }

  void makePayment() {
    RequestManager.showEasyLoader();
    payPalCallBackMethods();
    PayPalPayment.makePayment(
      amount: double.parse(lstSinglePlan[selectedIndex.value].discountedPrice!),
    );
  }

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
