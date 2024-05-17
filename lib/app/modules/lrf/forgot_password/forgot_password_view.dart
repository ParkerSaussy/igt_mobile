import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_field_validations.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../routes/app_pages.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CustomAppBar.buildAppBar(
          leadingWidth: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          isCustomTitle: true,
          customTitleWidget: CustomAppBar.backButton(onBack: () {
            Get.offAllNamed(Routes.LOGIN);
          }),
        ),
        body: SafeArea(
          child: Form(
            key: controller.forgotPasswordFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDimens.paddingExtraLarge.ph,
                  Text(LabelKeys.forgotPasswordTitle.tr,
                      style: onBackgroundTextStyleSemiBold(
                          fontSize: AppDimens.textExtraLarge)),
                  AppDimens.paddingMedium.ph,
                  Text(
                    LabelKeys.enterEmailOrMobileToResetPassword.tr,
                    style: onBackgroundTextStyleRegular(),
                  ),
                  AppDimens.paddingLarge.ph,
                  CustomTextField(
                      controller: controller.emailController,
                      keyBoardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.none,
                      maxLength: controller.isPhone.value ? 16 : 50,
                      inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: const UnderlineInputBorder(),
                        labelText: LabelKeys.emailOrMobileNo.tr,
                        prefixIconConstraints:
                            const BoxConstraints(maxHeight: 60),
                        prefixIcon: controller.isPhone.value
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: AppDimens.paddingLarge,
                                    right: AppDimens.paddingLarge,
                                    bottom: AppDimens.paddingLarge),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    /*const SizedBox(
                                      width: AppDimens.paddingSmall,
                                    ),*/
                                    SvgPicture.asset(IconPath.phone),
                                    const SizedBox(
                                      width: AppDimens.paddingSmall,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        openCountryPicker(context,
                                            onSuccess: (s) {
                                          controller.countryCode.value = s;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: AppDimens.paddingMedium,
                                            right: AppDimens.paddingMedium,
                                            top: AppDimens.paddingSmall,
                                            bottom: AppDimens.paddingSmall),
                                        child: Text(
                                          controller.countryCode.value,
                                          style: onBackgroundTextStyleRegular(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppDimens.paddingSmall,
                                    ),
                                    Container(
                                      width: 1,
                                      height: AppDimens.ratingBarIconSize,
                                      color: Get.theme.colorScheme.onBackground
                                          .withAlpha(Constants.lightAlfa),
                                    )
                                  ],
                                ),
                              )
                            : SvgPicture.asset(IconPath.email,
                                fit: BoxFit.scaleDown),
                      ),
                      onFieldSubmitted: (v) {},
                      onEditingComplete: () {},
                      onChanged: (v) {
                        if (v == '' ||
                            !controller.emailController.text.isNumericOnly) {
                          controller.isPhone(false);
                          TextFieldValidation.validateEmail(v);
                          controller.isEmailValidate(
                              controller.emailController.text.isEmail);
                        } else {
                          controller.isPhone(true);
                          controller.isEmailValidate(
                              controller.emailController.text.isPhoneNumber);
                        }
                      },
                      validator: (v) {
                        return controller.isPhone.value
                            ? CustomTextField.validatorFunction(v!,
                                ValidationTypes.phone, LabelKeys.cBlankPhone.tr)
                            : CustomTextField.validatorFunction(
                                v!,
                                ValidationTypes.email,
                                LabelKeys.cBlankEmail.tr);
                      }),
                  AppDimens.paddingXXLarge.ph,
                  MasterButtonsBounceEffect.gradiantButton(
                      disabled: !controller.isEmailValidate.value,
                      onPressed: () {
                        if (controller.forgotPasswordFormKey.currentState!
                            .validate()) {
                          hideKeyboard();
                          controller.forgotPassword(context);
                        }
                      },
                      btnText: LabelKeys.submit.tr),
                  AppDimens.paddingXXLarge.ph,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LabelKeys.backTo.tr,
                            style: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textMedium),
                          ),
                          const TextSpan(text: " "),
                          TextSpan(
                            text: LabelKeys.login.tr,
                            style: primaryTextStyleRegular(
                                fontSize: AppDimens.textMedium),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppDimens.paddingExtraLarge.ph,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
