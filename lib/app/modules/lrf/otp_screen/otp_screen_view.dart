import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:pinput/pinput.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/lesgo_appbar_logo.dart';
import 'otp_screen_controller.dart';

class OtpScreenView extends GetView<OtpScreenController> {
  const OtpScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: onBackgroundTextStyleSemiBold(fontSize: AppDimens.textLarge),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Get.theme.colorScheme.primary))),
    );
    final submittedPinTheme = PinTheme(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Get.theme.colorScheme.primary))),
    );
    final errorPinTheme = PinTheme(
      width: 40,
      height: 40,
      padding: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      textStyle: onBackgroundTextStyleRegular(fontSize: AppDimens.textMedium)
          .copyWith(color: Get.theme.colorScheme.error, height: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Get.theme.colorScheme.error))),
    );

    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 1.5,
          decoration: const BoxDecoration(
              /*color: Get.theme.colorScheme.primary.withAlpha(Constants.darkAlfa),
            borderRadius: BorderRadius.circular(0),*/
              ),
        ),
      ],
    );
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          Get.offAllNamed(Routes.LOGIN);
          return false;
        },
        child: GestureDetector(
          onTap: () {
            Get.focusScope?.unfocus();
          },
          child: Scaffold(
            appBar: CustomAppBar.buildAppBar(
              isCustomTitle: true,
              customTitleWidget: CustomAppBar.backButton(onBack: () {
                Get.offAllNamed(Routes.LOGIN);
              }),
            ),
            body: Form(
              key: controller.pinFormKey,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingExtraLarge,
                      vertical: AppDimens.paddingExtraLarge),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        LesgoAppbarLogo(),
                        AppDimens.paddingLarge.ph,
                        Text(
                          LabelKeys.enterYourVerificationCode.tr,
                          textAlign: TextAlign.center,
                          style: onBackgroundTextStyleSemiBold(
                              fontSize: AppDimens.textExtraLarge),
                        ),
                        AppDimens.paddingHuge.ph,
                        AppDimens.padding3XLarge.ph,
                        // PIN TEXT FIELD
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: AppDimens.padding3XLarge),
                          child: Pinput(
                            length: 4,
                            pinAnimationType: PinAnimationType.none,
                            controller: controller.pinPutController,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            focusNode: controller.pinFocusNode,
                            defaultPinTheme: defaultPinTheme,
                            showCursor: false,
                            validator: (v) {
                              if (v!.isEmpty) {
                                return LabelKeys.enterVerificationCode.tr;
                              }
                              if (v.length != 4) {
                                return LabelKeys.validEnterVerificationCode.tr;
                              } else {
                                return null;
                              }
                            },
                            focusedPinTheme: submittedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (a) {
                              controller.verifyOtpAPI();
                            },
                            errorPinTheme: errorPinTheme,
                            keyboardAppearance: Brightness.light,
                            preFilledWidget: preFilledWidget,
                          ),
                        ),
                        AppDimens.paddingXXLarge.ph,
                        MasterButtonsBounceEffect.gradiantButton(
                          btnText: LabelKeys.verify.tr,
                          onPressed: () {
                            controller.pinFocusNode.unfocus();
                            if (controller.pinFormKey.currentState!
                                .validate()) {
                              hideKeyboard();
                              controller.verifyOtpAPI();
                            }
                          },
                        ),
                        AppDimens.paddingSmall.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: AppDimens.paddingHuge,
                              alignment: Alignment.center,
                              child: controller.isResendVisible.value
                                  ? const SizedBox()
                                  : Text(
                                      controller.timeStart.value,
                                      textAlign: TextAlign.center,
                                      style: primaryTextStyleSemiBold(
                                          alpha: Constants.lightAlfa),
                                    ),
                            ),
                            controller.isResendVisible.value
                                ? MasterButtonsBounceEffect.textButton(
                                    btnText: LabelKeys.resendOtp.tr,
                                    onPressed: () {
                                      controller.clear();
                                      controller.startTimer();
                                      controller.sendOtp();
                                    },
                                    textStyles: primaryTextStyleRegular(
                                        fontSize: AppDimens.textMedium))
                                : const SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
