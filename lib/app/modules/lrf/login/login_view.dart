import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/lesgo_appbar_logo.dart';
import 'package:lesgo/app/modules/common_widgets/remove_over_scroll_effect.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_field_validations.dart';

import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../routes/app_pages.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: CustomAppBar.buildAppBar(),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //LESGO LOGO
                //AppDimens.paddingMedium.ph,
                Padding(
                  padding:
                      const EdgeInsets.only(top: AppDimens.paddingExtraLarge),
                  child: LesgoAppbarLogo(),
                ),
                // AppDimens.paddingHuge.ph,
                Expanded(
                  child: RemoveOverScrollEffect(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingExtraLarge,
                            vertical: AppDimens.paddingSmall),
                        child: Form(
                          autovalidateMode: controller.activationMode.value,
                          key: controller.loginFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LabelKeys.login.tr,
                                  style: onBackgroundTextStyleSemiBold(
                                      fontSize: AppDimens.textExtraLarge)),
                              AppDimens.paddingMedium.ph,
                              Text(
                                LabelKeys.receiveOtpToYourPhone.tr,
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textMedium),
                              ),
                              AppDimens.paddingXXLarge.ph,
                              // EMAIL Or Phone TEXT FIELD
                              CustomTextField(
                                  controller: controller.emailController,
                                  focusNode: controller.emailNode,
                                  keyBoardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.none,
                                  maxLength: controller.isPhone.value ? 16 : 50,
                                  //autoFocus: true,
                                  inputDecoration:
                                      CustomTextField.prefixSuffixOnlyIcon(
                                    border: const UnderlineInputBorder(),
                                    isDense: true,
                                    labelText: LabelKeys.emailOrPhone.tr,
                                    prefixIconConstraints:
                                        const BoxConstraints(maxHeight: 60),
                                    prefixIcon: controller.isPhone.value
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: AppDimens.paddingSmall,
                                                right: AppDimens.paddingSmall,
                                                bottom: AppDimens.paddingSmall),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                /*const SizedBox(
                                              width: AppDimens.paddingSmall,
                                            ),*/
                                                SvgPicture.asset(
                                                    IconPath.phone),
                                                const SizedBox(
                                                  width: AppDimens.paddingSmall,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    SystemChannels.textInput
                                                        .invokeMethod(
                                                            'TextInput.hide');
                                                    openCountryPicker(context,
                                                        onSuccess: (s) {
                                                      controller.countryCode
                                                          .value = s;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: AppDimens
                                                                .paddingMedium,
                                                            right: AppDimens
                                                                .paddingMedium,
                                                            top: AppDimens
                                                                .paddingSmall,
                                                            bottom: AppDimens
                                                                .paddingTiny),
                                                    child: Text(
                                                      controller
                                                          .countryCode.value,
                                                      style:
                                                          onBackgroundTextStyleRegular(),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.paddingSmall,
                                                ),
                                                Container(
                                                  width: 1,
                                                  height: AppDimens
                                                      .phoneVerticalDivHeight,
                                                  color: Get.theme.colorScheme
                                                      .onBackground
                                                      .withAlpha(
                                                          Constants.lightAlfa),
                                                )
                                              ],
                                            ),
                                          )
                                        : SvgPicture.asset(IconPath.email,
                                            fit: BoxFit.scaleDown),
                                  ),
                                  onFieldSubmitted: (v) {
                                    controller.passwordNode.requestFocus();
                                  },
                                  onEditingComplete: () {
                                    controller.passwordNode.requestFocus();
                                  },
                                  onChanged: (v) {
                                    if (v == '' ||
                                        !controller.emailController.text
                                            .isNumericOnly) {
                                      controller.isPhone(false);
                                    } else {
                                      controller.isPhone(true);
                                      TextFieldValidation.validatePhoneNumber(
                                          v);
                                    }
                                  },
                                  validator: (v) {
                                    return controller.isPhone.value
                                        ? CustomTextField.validatorFunction(
                                            v!,
                                            ValidationTypes.phone,
                                            LabelKeys.cBlankPhoneNumber.tr)
                                        : CustomTextField.validatorFunction(
                                            v!,
                                            ValidationTypes.email,
                                            LabelKeys.cBlankEmail.tr);
                                  }),
                              AppDimens.paddingLarge.ph,
                              // PASSWORD TEXT FIELD
                              CustomTextField(
                                controller: controller.passwordController,
                                focusNode: controller.passwordNode,
                                textInputAction: TextInputAction.done,
                                maxLength: 20,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.deny(" ")
                                ],
                                inputDecoration:
                                    CustomTextField.prefixSuffixOnlyIcon(
                                  border: const UnderlineInputBorder(),
                                  isDense: true,
                                  suffixIconConstraints: const BoxConstraints(
                                      maxHeight: AppDimens.paddingExtraLarge),
                                  //contentPadding: EdgeInsets.symmetric(vertical: -5),
                                  labelText: LabelKeys.password.tr,
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.zero,
                                    child: SvgPicture.asset(IconPath.lock,
                                        fit: BoxFit.scaleDown),
                                  ),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        controller.isPasswordVisible(!controller
                                            .isPasswordVisible.value);
                                      },
                                      child: SvgPicture.asset(
                                          controller.isPasswordVisible.value
                                              ? IconPath.passwordUnHide
                                              : IconPath.passwordHide,
                                          height: AppDimens.normalIconSize,
                                          width: AppDimens.normalIconSize,
                                          fit: BoxFit.scaleDown)),
                                ),
                                onFieldSubmitted: (v) {},
                                onChanged: (v) {
                                  TextFieldValidation.validatePassword(v);
                                },
                                validator: (v) {
                                  return CustomTextField.validatorFunction(
                                      v!,
                                      ValidationTypes.password,
                                      LabelKeys.cBlankPasswordAddress.tr);
                                },
                              ),
                              AppDimens.paddingLarge.ph,
                              // FORGOT PASSWORD ROW

                              Align(
                                alignment: Alignment.centerRight,
                                child: Bounce(
                                  duration: const Duration(
                                      milliseconds: Constants.bounceDuration),
                                  onPressed: () {
                                    Get.toNamed(Routes.FORGOT_PASSWORD);
                                  },
                                  child: Text(
                                    LabelKeys.forgotPassword.tr,
                                    style: primaryTextStyleRegular(),
                                  ),
                                ),
                              ),
                              // LOGIN BUTTON
                              AppDimens.paddingExtraLarge.ph,
                              MasterButtonsBounceEffect.gradiantButton(
                                btnText: LabelKeys.login.tr,
                                onPressed: () {
                                  printMessage(controller
                                      .loginFormKey.currentState!
                                      .validate());
                                  if (controller.loginFormKey.currentState!
                                      .validate()) {
                                    hideKeyboard();
                                    //Get.toNamed(Routes.DASHBOARD);
                                    controller.signInType =
                                        controller.isPhone.value
                                            ? SignInType.mobile
                                            : SignInType.email;
                                    controller.doLogin();
                                  } else {
                                    controller.activationMode.value =
                                        AutovalidateMode.onUserInteraction;
                                  }
                                },
                              ),
                              AppDimens.paddingXXLarge.ph,
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Get.theme.colorScheme.onPrimary
                                          .withAlpha(Constants.lightAlfa),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppDimens.paddingExtraLarge),
                                      child: Text(LabelKeys.orSignInWith.tr,
                                          style: onBackgroundTextStyleRegular(
                                              fontSize: AppDimens.textMedium))),
                                  Expanded(
                                    child: Divider(
                                      color: Get.theme.colorScheme.onPrimary
                                          .withAlpha(Constants.lightAlfa),
                                    ),
                                  ),
                                ],
                              ),
                              AppDimens.paddingExtraLarge.ph,
                              // GOOGLE SIGN IN BUTTON
                              MasterButtonsBounceEffect.iconColorButton(
                                  borderRadius: AppDimens.radiusButton,
                                  elevation: 2,
                                  onPressed: () {
                                    controller.doGoogleLogin();
                                  },
                                  iconPath: IconPath.googleSignUpIcon,
                                  btnText: LabelKeys.google.tr,
                                  textStyles: onBackGroundTextStyleMedium(),
                                  buttonColor: Get.theme.colorScheme.onPrimary),
                              Platform.isIOS
                                  ? AppDimens.paddingLarge.ph
                                  : Container(),
                              // APPLE SIGN IN BUTTON
                              Platform.isIOS
                                  ? MasterButtonsBounceEffect.iconColorButton(
                                      borderRadius: AppDimens.radiusButton,
                                      elevation: 2,
                                      onPressed: () {
                                        controller.doAppleLogin();
                                      },
                                      iconPath: IconPath.appleSignUpIcon,
                                      btnText: LabelKeys.apple.tr,
                                      textStyles: onBackGroundTextStyleMedium(),
                                      buttonColor:
                                          Get.theme.colorScheme.onPrimary)
                                  : Container(),
                              // DON'T HAVE AN ACCOUNT TEXT
                              AppDimens.paddingExtraLarge.ph,
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: LabelKeys.doNotHaveAccount.tr,
                                        style: onBackgroundTextStyleRegular(
                                            fontSize: AppDimens.textMedium),
                                      ),
                                      const TextSpan(text: " "),
                                      TextSpan(
                                        text: LabelKeys.signUp.tr,
                                        style: primaryTextStyleRegular(
                                            fontSize: AppDimens.textMedium),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap =
                                              () => Get.offNamed(Routes.SIGNUP),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
