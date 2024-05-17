import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_field_validations.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import 'change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          isCustomTitle: true,
          customTitleWidget: CustomAppBar.backButton(),
        ),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingExtraLarge),
                child: Text(LabelKeys.changePassword.tr,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.darkAlfa),
                    overflow: TextOverflow.ellipsis),
              ),
              AppDimens.paddingExtraLarge.ph,
              Expanded(
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimens.radiusCircle),
                        topRight: Radius.circular(AppDimens.radiusCircle)),
                  ),
                  color: Get.theme.colorScheme.surface,
                  child: SingleChildScrollView(
                    child: Form(
                      autovalidateMode: controller.activationMode.value,
                      key: controller.changePWFormKey,
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingLarge),
                        child: Column(children: [
                          AppDimens.paddingMedium.ph,
                          //Old Password
                          CustomTextField(
                              controller: controller.oldPwController,
                              focusNode: controller.oldPwNode,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(" ")
                              ],
                              obscureText: !controller.isOldPwVisible.value,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                border: const UnderlineInputBorder(),
                                isDense: true,
                                labelText: LabelKeys.oldPassword.tr,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset(IconPath.lock,
                                      fit: BoxFit.scaleDown),
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.isOldPwVisible(
                                          !controller.isOldPwVisible.value);
                                    },
                                    child: SvgPicture.asset(
                                        controller.isOldPwVisible.value
                                            ? IconPath.passwordUnHide
                                            : IconPath.passwordHide,
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
                                    LabelKeys.blankOldPassword.tr);
                              }),
                          // New Password
                          AppDimens.paddingMedium.ph,
                          CustomTextField(
                              controller: controller.newPwController,
                              focusNode: controller.newPwNode,
                              textInputAction: TextInputAction.next,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(" ")
                              ],
                              obscureText: !controller.isNewPwVisible.value,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                border: const UnderlineInputBorder(),
                                labelText: LabelKeys.newPassword.tr,
                                prefixIcon: SvgPicture.asset(IconPath.lock,
                                    fit: BoxFit.scaleDown),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      controller.isNewPwVisible(
                                          !controller.isNewPwVisible.value);
                                    },
                                    child: SvgPicture.asset(
                                        controller.isNewPwVisible.value
                                            ? IconPath.passwordUnHide
                                            : IconPath.passwordHide,
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
                              }),
                          AppDimens.paddingMedium.ph,
                          // Confirm new password
                          CustomTextField(
                              controller: controller.cPwController,
                              focusNode: controller.cPwNode,
                              textInputAction: TextInputAction.done,
                              obscureText: !controller.iscPwVisible.value,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                border: const UnderlineInputBorder(),
                                labelText: LabelKeys.confirmNewPassword.tr,
                                prefixIcon: SvgPicture.asset(IconPath.lock,
                                    fit: BoxFit.scaleDown),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    controller.iscPwVisible(
                                        !controller.iscPwVisible.value);
                                  },
                                  child: SvgPicture.asset(
                                    controller.iscPwVisible.value
                                        ? IconPath.passwordUnHide
                                        : IconPath.passwordHide,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              onFieldSubmitted: (v) {},
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.deny(" ")
                              ],
                              onChanged: (v) {
                                TextFieldValidation.validateConformPassword(
                                    v, controller.cPwController.text);
                              },
                              validator: (value) {
                                /*if (value.toString().trim().isEmpty) {
                                  return LabelKeys.cBlankConfirmPassword.tr;
                                } else if (value!.length < 8) {
                                  return LabelKeys.cInvalidPassword.tr;
                                } else if (controller.newPwController.text !=
                                    value) {
                                  return LabelKeys.passwordNotMatch.tr;
                                }
                                return null;*/
                                return TextFieldValidation
                                    .validateConformPassword(
                                        value!, controller.cPwController.text);
                              }),
                          AppDimens.padding3XLarge.ph,
                          MasterButtonsBounceEffect.gradiantButton(
                            btnText: LabelKeys.submit.tr,
                            onPressed: () {
                              if (controller.changePWFormKey.currentState!
                                  .validate()) {
                                hideKeyboard();
                                controller.changePassword(context);
                              } else {
                                controller.activationMode(
                                    AutovalidateMode.onUserInteraction);
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
