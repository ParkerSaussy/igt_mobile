import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/bottomsheet_with_close.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class ContactusController extends GetxController {
  //TODO: Implement ContactusController

  TextEditingController fNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  FocusNode fNameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode messageNode = FocusNode();
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> contactusFormKey =
      GlobalKey<FormState>(debugLabel: "contactus");

  submit() {
    contactUs();
  }

  void contactUs() {
    var body = {
      RequestParams.firstName: fNameController.text.trim(),
      RequestParams.email: emailController.text.trim(),
      RequestParams.message: messageController.text.trim(),
    };
    RequestManager.postRequest(
      uri: EndPoints.addInquiry,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        printMessage(response);
        clear();
        Get.bottomSheet(
          isScrollControlled: true,
          BottomSheetWithClose(
            widget: successBottomSheet(),
          ),
        );
      },
      onFailure: (error) {
        activationMode.value = AutovalidateMode.disabled;
        printMessage(error);
      },
    );
  }

  void clear() {
    fNameController.clear();
    emailController.clear();
    messageController.clear();
    activationMode.value = AutovalidateMode.disabled;
    Get.focusScope?.unfocus();
  }

  Widget successBottomSheet() {
    return SizedBox(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppDimens.paddingLarge.ph,
          SvgPicture.asset(IconPath.contactUsFeedbackSuccess),
          AppDimens.paddingLarge.ph,
          Text(
            LabelKeys.successText.tr,
            style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
          ),
          AppDimens.paddingXXLarge.ph,
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: MasterButtonsBounceEffect.gradiantButton(
                btnText: LabelKeys.ok.tr,
                onPressed: () {
                  activationMode.value = AutovalidateMode.disabled;
                  hideKeyboard();
                  Get.back();
                },
              )),
          AppDimens.paddingXXLarge.ph,
        ],
      ),
    );
  }
}
