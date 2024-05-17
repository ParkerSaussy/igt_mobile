import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';

import '../general_utils/common_stuff.dart';

class PayPalPayment {
  static final flutterPaypalNativePlugin = FlutterPaypalNative.instance;
  static const returnUrl = 'com.itsgotime.app://paypalpay';
  static const paypalClientId =
      'AWFxLytLxhrfif4uA_zOkUTeVgp2k5q7dG8X_KvYXvWENVuhkFto5pJUOCbDlqYIU0eGBz2yqnBgUGaq';

  static initPayPal() async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode = true;

    //initiate payPal plugin
    await flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: returnUrl,
      //client id from developer dashboard
      clientID: paypalClientId,
      //sandbox, staging, live etc
      payPalEnvironment: FPayPalEnvironment.sandbox,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );
  }

  static makePayment({required double amount}) {
    if (PayPalPayment.flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      PayPalPayment.flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          // random prices
          amount: amount,

          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: FPayPalStrHelper.getRandomString(16),
        ),
      );
    }
    // initPayPal();
    flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
  }

  void payPalCallBackMethods() {
    //call backs for payment
    PayPalPayment.flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          printMessage("cancel 123");
        },
        onSuccess: (data) {
          //purchasePlanAPI();
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          String visitor = data.cart?.shippingAddress?.firstName ?? 'Visitor';
          String address =
              data.cart?.shippingAddress?.line1 ?? 'Unknown Address';
          printMessage(
              "Order successful ${data.payerId ?? ""} - ${data.orderId ?? ""} - $visitor -$address");
        },
        onError: (data) {
          printMessage("error: ${data.reason}");
        },
        onShippingChange: (data) {
          printMessage(
            "shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}",
          );
        },
      ),
    );
  }
}
