import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

class AlertView {
  static showLoading() {
    return EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        status: 'Loading ...',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black);
  }

  static loadingDismiss() {
    return EasyLoading.dismiss();
  }

  showAlertViewWithTwoButton(
    BuildContext context,
    String message,
    String action1,
    String action2,
    Function? onPressedAction1,
    Function? onPressedAction2, {
    String title = LabelKeys.appName,
  }) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title.tr,
      ),
      content: Text(
        message,
      ),
      actions: [
        TextButton(
          onPressed: () => onPressedAction1!(),
          child: Text(
            action1,
          ),
        ),
        TextButton(
            onPressed: () => onPressedAction2!(),
            child: Text(
              action2,
            )),
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: alertDialog);
        });
  }

  showAlertView(BuildContext context, String message, String action1,
      Function? onPressedAction1,
      {String title = LabelKeys.appName, bool? isDismiss = true}) {
    final alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title.tr),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => onPressedAction1!(),
          child: Text(
            action1,
          ),
        ),
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: isDismiss ?? true,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: alertDialog);
        });
  }
}
