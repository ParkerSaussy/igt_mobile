import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/lrf/signup/signup_controller.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/text_field_validations.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/lesgo_appbar_logo.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Scaffold(
          appBar: CustomAppBar.buildAppBar(
            isCustomTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            customTitleWidget: CustomAppBar.backButton(
              onBack: () => {Get.offAllNamed(Routes.LOGIN)},
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingExtraLarge),
            child: Column(
              children: [
                LesgoAppbarLogo(
                  padding: const EdgeInsets.only(
                      bottom: AppDimens.paddingExtraLarge),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      autovalidateMode: controller.activationMode.value,
                      key: controller.signupFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //LESGO LOGO
                          Text(
                            LabelKeys.createAccount.tr,
                            style: onBackgroundTextStyleSemiBold(
                                fontSize: AppDimens.textExtraLarge),
                          ),
                          AppDimens.paddingLarge.ph,
                          // FIRST NAME TEXT FIELD
                          CustomTextField(
                              controller: controller.firstNameController,
                              focusNode: controller.firstNameNode,
                              keyBoardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                labelText: LabelKeys.firstName.tr,
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                prefixIcon: SvgPicture.asset(IconPath.user,
                                    fit: BoxFit.scaleDown),
                              ),
                              onFieldSubmitted: (v) {
                                controller.lastNameNode.requestFocus();
                              },
                              onChanged: (v) {
                                TextFieldValidation.validateFirstName(v);
                              },
                              validator: (v) {
                                return CustomTextField.validatorFunction(
                                    v!,
                                    ValidationTypes.other,
                                    LabelKeys.cBlankFName.tr);
                              }),
                          AppDimens.paddingMedium.ph,
                          // LAST NAME TEXT FIELD
                          CustomTextField(
                              controller: controller.lastNameController,
                              focusNode: controller.lastNameNode,
                              keyBoardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                labelText: LabelKeys.lastName.tr,
                                prefixIcon: SvgPicture.asset(IconPath.user,
                                    fit: BoxFit.scaleDown),
                              ),
                              onFieldSubmitted: (v) {
                                controller.emailNode.requestFocus();
                              },
                              onChanged: (v) {
                                TextFieldValidation.validateFirstName(v);
                              },
                              validator: (v) {
                                return CustomTextField.validatorFunction(
                                    v!,
                                    ValidationTypes.other,
                                    LabelKeys.cBlankLName.tr);
                              }),
                          AppDimens.paddingMedium.ph,
                          Text(LabelKeys.addBothEmailAndPhoneForAdvance.tr,
                              style: onBackgroundTextStyleRegular(
                                  fontSize: AppDimens.textMedium)),
                          // EMAIL TEXT FIELD
                          AppDimens.paddingMedium.ph,
                          CustomTextField(
                              controller: controller.emailController,
                              focusNode: controller.emailNode,
                              keyBoardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.none,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                labelText: LabelKeys.emailAddress.tr,
                                prefixIcon: SvgPicture.asset(IconPath.email,
                                    fit: BoxFit.scaleDown),
                              ),
                              onFieldSubmitted: (v) {
                                controller.phoneNode.requestFocus();
                              },
                              onEditingComplete: () {
                                //controller.passwordNode.requestFocus();
                              },
                              onChanged: (v) {
                                TextFieldValidation.validateEmail(v);
                              },
                              validator: (v) {
                                return CustomTextField.validatorFunction(
                                    v!,
                                    ValidationTypes.email,
                                    LabelKeys.cBlankEmail.tr);
                              }),
                          AppDimens.paddingSmall.ph,
                          // PHONE NUMBER TEXT FIELD
                          CustomTextField(
                              controller: controller.phoneController,
                              focusNode: controller.phoneNode,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyBoardType: TextInputType.phone,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                contentPadding: const EdgeInsets.fromLTRB(
                                    0,
                                    12,
                                    AppDimens.paddingExtraLarge,
                                    AppDimens.paddingMedium),
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                prefixIconConstraints:
                                    const BoxConstraints(maxHeight: 60),
                                labelText: LabelKeys.phoneNumber.tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppDimens.paddingSmall,
                                      right: AppDimens.paddingSmall,
                                      bottom: AppDimens.paddingSmall),
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
                                              bottom: AppDimens.paddingTiny),
                                          child: Text(
                                            controller.countryCode.value,
                                            style:
                                                onBackgroundTextStyleRegular(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppDimens.paddingSmall,
                                      ),
                                      Container(
                                        width: AppDimens.paddingNano,
                                        height:
                                            AppDimens.phoneVerticalDivHeight,
                                        color: Get
                                            .theme.colorScheme.onBackground
                                            .withAlpha(Constants.lightAlfa),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onFieldSubmitted: (v) {
                                controller.passwordNode.requestFocus();
                              },
                              onChanged: (v) {
                                if (v.isNotEmpty) {
                                  TextFieldValidation.validatePhoneNumber(v);
                                }
                              },
                              validator: (v) {
                                if (v!.isNotEmpty) {
                                  return CustomTextField.validatorFunction(
                                      v,
                                      ValidationTypes.phone,
                                      LabelKeys.cBlankPhoneNumber.tr);
                                }
                                return null;
                              }),
                          AppDimens.paddingMedium.ph,
                          // PASSWORD TEXT FIELD
                          CustomTextField(
                              controller: controller.passwordController,
                              focusNode: controller.passwordNode,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(" ")
                              ],
                              obscureText: !controller.isPasswordVisible.value,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                labelText: LabelKeys.password.tr,
                                prefixIcon: SvgPicture.asset(IconPath.lock,
                                    fit: BoxFit.scaleDown),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.isPasswordVisible(
                                          !controller.isPasswordVisible.value);
                                    },
                                    child: SvgPicture.asset(
                                        controller.isPasswordVisible.value
                                            ? IconPath.passwordUnHide
                                            : IconPath.passwordHide,
                                        fit: BoxFit.scaleDown)),
                              ),
                              onFieldSubmitted: (v) {
                                controller.conformPasswordNode.requestFocus();
                              },
                              onChanged: (v) {
                                TextFieldValidation.validatePassword(v);
                              },
                              validator: (v) {
                                return CustomTextField.validatorFunction(
                                    v!,
                                    ValidationTypes.password,
                                    LabelKeys.blankPassword.tr);
                              }),
                          AppDimens.paddingMedium.ph,
                          // CONFORM PASSWORD TEXT FIELD
                          CustomTextField(
                              controller: controller.conformPasswordController,
                              focusNode: controller.conformPasswordNode,
                              textInputAction: TextInputAction.done,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(" ")
                              ],
                              obscureText:
                                  !controller.isConformPasswordVisible.value,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                labelText: LabelKeys.conformPassword.tr,
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                prefixIcon: SvgPicture.asset(IconPath.lock,
                                    fit: BoxFit.scaleDown),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.isConformPasswordVisible(
                                          !controller
                                              .isConformPasswordVisible.value);
                                    },
                                    child: SvgPicture.asset(
                                        controller
                                                .isConformPasswordVisible.value
                                            ? IconPath.passwordUnHide
                                            : IconPath.passwordHide,
                                        fit: BoxFit.scaleDown)),
                              ),
                              onFieldSubmitted: (v) {},
                              onChanged: (v) {},
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LabelKeys.cBlankConfirmPassword.tr;
                                } else if (value.length < 8) {
                                  return LabelKeys.cInvalidPassword.tr;
                                } else if (controller.passwordController.text !=
                                    value) {
                                  return LabelKeys.passwordNotMatch.tr;
                                }
                                return null;
                              }),
                          // CHECK OR UNCHECK FOR ACCEPT TERMS AND CONDITION
                          AppDimens.paddingMedium.ph,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    controller
                                        .isCheck(!controller.isCheck.value);
                                  },
                                  child: SvgPicture.asset(
                                      controller.isCheck.value
                                          ? IconPath.check
                                          : IconPath.unCheck)),
                              AppDimens.paddingMedium.pw,
                              // TERM AND CONDITION TEXT WITH CHECK BOX
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: LabelKeys
                                        .youHaveConformingThatTermAndConditionString
                                        .tr,
                                    style: onBackgroundTextStyleRegular(
                                        fontSize: AppDimens.textSmall,
                                        alpha: Constants.mediumAlfa),
                                    children: <TextSpan>[
                                      const TextSpan(text: " "),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.focusScope!.unfocus();
                                            Get.toNamed(Routes.ABOUTUS,
                                                arguments: [
                                                  LabelKeys
                                                      .termsAndCondition.tr,
                                                  Constants.fromSignUp
                                                ])?.then((value) {
                                              if (value["requestType"] ==
                                                  LabelKeys
                                                      .termsAndCondition.tr) {
                                                if (!controller.isCheck.value) {
                                                  controller.isTerms.value =
                                                      value["status"];
                                                  if (controller
                                                          .isPrivacy.value &&
                                                      controller
                                                          .isTerms.value) {
                                                    controller.isCheck.value =
                                                        true;
                                                  } else {
                                                    controller.isCheck.value =
                                                        false;
                                                  }
                                                }
                                              }
                                            });
                                          },
                                        text: LabelKeys.termsAndCondition.tr,
                                        style: primaryTextStyleRegular(
                                                fontSize: AppDimens.textMedium,
                                                alpha: Constants.mediumAlfa)
                                            .copyWith(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: " "),
                                      TextSpan(
                                        text: LabelKeys.and.tr,
                                        style: onBackgroundTextStyleRegular(
                                            fontSize: AppDimens.textSmall,
                                            alpha: Constants.mediumAlfa),
                                      ),
                                      const TextSpan(text: " "),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.focusScope!.unfocus();
                                            Get.toNamed(Routes.ABOUTUS,
                                                arguments: [
                                                  LabelKeys.privacyPolicy.tr,
                                                  Constants.fromSignUp
                                                ])?.then((value) {
                                              if (!controller.isCheck.value) {
                                                if (value["requestType"] ==
                                                    LabelKeys
                                                        .privacyPolicy.tr) {
                                                  controller.isPrivacy.value =
                                                      value["status"];
                                                  if (controller
                                                          .isPrivacy.value &&
                                                      controller
                                                          .isTerms.value) {
                                                    controller.isCheck.value =
                                                        true;
                                                  } else {
                                                    controller.isCheck.value =
                                                        false;
                                                  }
                                                }
                                              }
                                            });
                                          },
                                        text: LabelKeys.privacyPolicy.tr,
                                        style: primaryTextStyleRegular(
                                                fontSize: AppDimens.textMedium,
                                                alpha: Constants.mediumAlfa)
                                            .copyWith(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          AppDimens.paddingExtraLarge.ph,
                          // SIGNUP BUTTON
                          MasterButtonsBounceEffect.gradiantButton(
                            btnText: LabelKeys.signUp.tr,
                            onPressed: () {
                              if (controller.signupFormKey.currentState!
                                  .validate()) {
                                hideKeyboard();
                                if (controller.isCheck.value) {
                                  controller.signup();
                                } else {
                                  /*RequestManager.getSnackToast(
                                    title: LabelKeys.alert,
                                    message: "Please accept terms and condition.",
                                    backgroundColor: Get.theme.colorScheme.error,
                                    colorText: Get.theme.colorScheme.onError);*/
                                  Get.snackbar("", "",
                                      titleText: Text(
                                        LabelKeys.alert.tr,
                                        style: onPrimaryTextStyleSemiBold(),
                                      ),
                                      messageText: Text(
                                        LabelKeys.termsAndConditionAccept.tr,
                                        style: onPrimaryTextStyleMedium(),
                                      ),
                                      backgroundColor:
                                          Get.theme.colorScheme.error,
                                      colorText: Get.theme.colorScheme.onError);
                                }
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
                                      .withAlpha(Constants.mediumAlfa),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimens.paddingExtraLarge),
                                child: Text(LabelKeys.orSignUpWith.tr),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Get.theme.colorScheme.onPrimary
                                      .withAlpha(Constants.mediumAlfa),
                                ),
                              ),
                            ],
                          ),
                          AppDimens.paddingExtraLarge.ph,
                          // GOOGLE SIGN IN BUTTON
                          MasterButtonsBounceEffect.iconColorButton(
                              borderRadius: AppDimens.radiusButton,
                              height: AppDimens.buttonHeightLarge,
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
                                  height: AppDimens.buttonHeightLarge,
                                  elevation: 2,
                                  onPressed: () {
                                    controller.doAppleLogin();
                                  },
                                  iconPath: IconPath.appleSignUpIcon,
                                  btnText: LabelKeys.apple.tr,
                                  textStyles: onBackGroundTextStyleMedium(),
                                  buttonColor: Get.theme.colorScheme.onPrimary)
                              : Container(),
                          // ALREADY HAVE AN ACCOUNT TEXT
                          AppDimens.paddingLarge.ph,
                          Center(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: LabelKeys.alreadyHaveAnAccount.tr,
                                  style: onBackgroundTextStyleRegular(
                                      fontSize: AppDimens.textMedium),
                                ),
                                const TextSpan(text: " "),
                                TextSpan(
                                  text: LabelKeys.login.tr,
                                  style: primaryTextStyleMedium(
                                      fontSize: AppDimens.textMedium),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.offNamed(Routes.LOGIN),
                                ),
                              ]),
                            ),
                          ),
                          AppDimens.paddingLarge.ph,
                        ],
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
