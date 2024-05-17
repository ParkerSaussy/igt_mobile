import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/lrf/reset_password/reset_password_controller.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';

import '../../../../master/general_utils/text_field_validations.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../routes/app_pages.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);
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
            customTitleWidget: CustomAppBar.backButton(onBack: () {
              Get.offAllNamed(Routes.FORGOT_PASSWORD);
            }),
          ),
          body: SafeArea(
            bottom: false,
            child: Form(
              key: controller.resetPassFormKey,
              autovalidateMode: controller.activationMode.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingExtraLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDimens.paddingExtraLarge.ph,
                    Text(LabelKeys.resetPassword.tr,
                        style: onBackgroundTextStyleSemiBold(
                            fontSize: AppDimens.textExtraLarge)),
                    AppDimens.paddingExtraLarge.ph,
                    Text(LabelKeys.enterNewPassword.tr,
                        style: onBackgroundTextStyleRegular()),
                    AppDimens.paddingExtraLarge.ph,
                    // NEW PASSWORD TEXT FIELD
                    CustomTextField(
                        controller: controller.passwordController,
                        focusNode: controller.passwordNode,
                        textInputAction: TextInputAction.next,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.deny(" ")
                        ],
                        obscureText: !controller.isPasswordVisible.value,
                        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                          labelText: LabelKeys.newPassword.tr,
                          border: const UnderlineInputBorder(),
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
                    // CONFORM NEW PASSWORD TEXT FIELD
                    AppDimens.paddingMedium.ph,
                    CustomTextField(
                        controller: controller.conformPasswordController,
                        focusNode: controller.conformPasswordNode,
                        textInputAction: TextInputAction.done,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.deny(" ")
                        ],
                        obscureText: !controller.isConformPasswordVisible.value,
                        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                          labelText: LabelKeys.confirmNewPassword.tr,
                          border: const UnderlineInputBorder(),
                          prefixIcon: SvgPicture.asset(IconPath.lock,
                              fit: BoxFit.scaleDown),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                controller.isConformPasswordVisible(
                                    !controller.isConformPasswordVisible.value);
                              },
                              child: SvgPicture.asset(
                                  controller.isConformPasswordVisible.value
                                      ? IconPath.passwordUnHide
                                      : IconPath.passwordHide,
                                  fit: BoxFit.scaleDown)),
                        ),
                        onFieldSubmitted: (v) {},
                        onChanged: (v) {
                          /*TextFieldValidation.validateConformPassword(
                                v, controller.passwordController.text);*/
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    AppDimens.paddingExtraLarge.ph,
                    // GO TO EMAIL BUTTON
                    MasterButtonsBounceEffect.gradiantButton(
                        onPressed: () {
                          if (controller.resetPassFormKey.currentState!
                              .validate()) {
                            controller.resetPassword(context);
                          } else {
                            controller.activationMode(
                                AutovalidateMode.onUserInteraction);
                          }
                        },
                        btnText: LabelKeys.submit.tr),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
