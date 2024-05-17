import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';

import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_field_validations.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/common_network_image.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../master/networking/request_manager.dart';
import '../../common_widgets/bottomsheet_with_close.dart';
import '../../common_widgets/upload_image_bottomsheet.dart';
import 'editprofile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
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
          () => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingExtraLarge),
                    child: Text(LabelKeys.editProfile.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textExtraLarge,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                  ),
                  AppDimens.paddingHuge.ph,
                  Expanded(
                    child: ContainerTopRoundedCorner(
                      child: ScrollViewRoundedCorner(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingLarge),
                          child: Form(
                            autovalidateMode: controller.activationMode.value,
                            key: controller.editProfileFormKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppDimens.radiusCircle.ph,
                                  Center(
                                    child: Text(LabelKeys.uploadProfilePic.tr,
                                        style: onBackGroundTextStyleMedium(
                                            fontSize: AppDimens.textLarge,
                                            alpha: Constants.lightAlfa),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  AppDimens.paddingExtraLarge.ph,
                                  CustomTextField(
                                      controller: controller.fNameController,
                                      focusNode: controller.fNameNode,
                                      textInputAction: TextInputAction.next,
                                      inputDecoration:
                                          CustomTextField.prefixSuffixOnlyIcon(
                                        border: const UnderlineInputBorder(),
                                        labelText: LabelKeys.firstName.tr,
                                      ),
                                      onFieldSubmitted: (v) {
                                        controller.lNameNode.requestFocus();
                                      },
                                      onChanged: (v) {
                                        TextFieldValidation.validateFirstName(
                                            v);
                                      },
                                      validator: (v) {
                                        return CustomTextField
                                            .validatorFunction(
                                                v!,
                                                ValidationTypes.other,
                                                LabelKeys.blankFirstName.tr);
                                      }),
                                  AppDimens.paddingMedium.ph,
                                  CustomTextField(
                                      controller: controller.lNameController,
                                      focusNode: controller.lNameNode,
                                      textInputAction: TextInputAction.next,
                                      inputDecoration:
                                          CustomTextField.prefixSuffixOnlyIcon(
                                        border: const UnderlineInputBorder(),
                                        labelText: LabelKeys.lastName.tr,
                                      ),
                                      onFieldSubmitted: (v) {
                                        controller.uNameNode.requestFocus();
                                      },
                                      onChanged: (v) {
                                        TextFieldValidation.validateLastName(v);
                                      },
                                      validator: (v) {
                                        return CustomTextField
                                            .validatorFunction(
                                                v!,
                                                ValidationTypes.other,
                                                LabelKeys.blankLastName.tr);
                                      }),
                                  AppDimens.paddingMedium.ph,
                                  CustomTextField(
                                    controller:
                                        controller.paypalUsernameController,
                                    focusNode: controller.paypalNode,
                                    textInputAction: TextInputAction.next,
                                    inputDecoration:
                                        CustomTextField.prefixSuffixOnlyIcon(
                                      border: const UnderlineInputBorder(),
                                      labelText: 'Paypal Username',
                                    ),
                                    onFieldSubmitted: (v) {
                                      controller.paypalNode.requestFocus();
                                    },
                                    onChanged: (v) {},
                                  ),
                                  AppDimens.paddingMedium.ph,
                                  CustomTextField(
                                    controller:
                                        controller.venmoUsernameController,
                                    focusNode: controller.venmoNode,
                                    textInputAction: TextInputAction.next,
                                    inputDecoration:
                                        CustomTextField.prefixSuffixOnlyIcon(
                                      border: const UnderlineInputBorder(),
                                      labelText: 'Venmo Username',
                                    ),
                                    onFieldSubmitted: (v) {
                                      controller.venmoNode.requestFocus();
                                    },
                                    onChanged: (v) {},
                                  ),
                                  AppDimens.paddingMedium.ph,
                                  CustomTextField(
                                      controller: controller.emailController,
                                      focusNode: controller.emailNode,
                                      textInputAction: TextInputAction.next,
                                      enabled: false,
                                      style: labelStyle(),
                                      inputDecoration:
                                          CustomTextField.prefixSuffixOnlyIcon(
                                              //labelText: LabelKeys.emailID.tr,
                                              border: CustomTextField
                                                  .underlineDisabledBorder),
                                      onFieldSubmitted: (v) {},
                                      onChanged: (v) {
                                        TextFieldValidation.validateFirstName(
                                            v);
                                      },
                                      validator: (v) {
                                        return CustomTextField
                                            .validatorFunction(
                                                v!,
                                                ValidationTypes.email,
                                                "Please enter email");
                                      }),
                                  AppDimens.paddingMedium.ph,
                                  Form(
                                    autovalidateMode:
                                        controller.activationModeMobile.value,
                                    key: controller.mobileFormKey,
                                    child: CustomTextField(
                                      controller: controller.mobileController,
                                      focusNode: controller.mobileNode,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (value) {
                                        if (gc.loginData.value.mobileNumber !=
                                            value) {
                                          gc.loginData.value.isMobileVerify = 0;
                                        } else {
                                          gc.loginData.value.isMobileVerify = 1;
                                        }
                                        controller.mobileFieldRestorationId
                                            .value = getRandomString();
                                      },
                                      //enabled: false,
                                      validator: (v) {
                                        return CustomTextField
                                            .validatorFunction(
                                                v!,
                                                ValidationTypes.phone,
                                                LabelKeys.cBlankPhoneNumber.tr);
                                      },
                                      maxLength: 14,
                                      style: labelStyle(),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyBoardType: TextInputType.phone,
                                      inputDecoration:
                                          CustomTextField.prefixSuffixOnlyIcon(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      0,
                                                      12,
                                                      AppDimens
                                                          .paddingExtraLarge,
                                                      AppDimens.paddingMedium),
                                              border:
                                                  const UnderlineInputBorder(),
                                              isDense: true,
                                              suffixIconConstraints:
                                                  const BoxConstraints(
                                                      minHeight: 45),
                                              prefixIconConstraints:
                                                  const BoxConstraints(
                                                      maxWidth: 70),
                                              //labelText: LabelKeys.mobileNumber.tr,
                                              prefixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        //horizontal: AppDimens.paddingMedium,
                                                        vertical: AppDimens
                                                            .paddingSmall,
                                                      ),
                                                      child: Text(
                                                        controller
                                                            .countryCode.value,
                                                        style: onBackgroundTextStyleRegular(
                                                            alpha: Constants
                                                                .veryLightAlfa),
                                                      ),
                                                    ),
                                                  ),
                                                  AppDimens.paddingLarge.pw,
                                                  Container(
                                                    width: 1,
                                                    height: AppDimens
                                                        .ratingBarIconSize,
                                                    color: Get.theme.colorScheme
                                                        .onBackground
                                                        .withAlpha(Constants
                                                            .veryLightAlfa),
                                                  ),
                                                  AppDimens.paddingSmall.pw,
                                                ],
                                              ),
                                              suffixIcon: Obx(() => controller
                                                          .mobileFieldRestorationId
                                                          .value
                                                          .isNotEmpty &&
                                                      gc.loginData.value
                                                              .isMobileVerify ==
                                                          1
                                                  ? Container(
                                                      margin: const EdgeInsets
                                                          .only(
                                                          right: AppDimens
                                                              .paddingMedium),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: AppDimens
                                                              .paddingSmall,
                                                          vertical: AppDimens
                                                              .paddingSmall),
                                                      //height: AppDimens.padding3XLarge,
                                                      decoration: BoxDecoration(
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .primary
                                                              .withAlpha(Constants
                                                                  .limit),
                                                          borderRadius: const BorderRadius
                                                              .horizontal(
                                                              left: Radius.circular(
                                                                  AppDimens
                                                                      .radiusCircle),
                                                              right: Radius.circular(
                                                                  AppDimens
                                                                      .radiusCircle))),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const SizedBox(
                                                            width: AppDimens
                                                                .paddingSmall,
                                                          ),
                                                          Text(
                                                              LabelKeys
                                                                  .verified.tr,
                                                              style: primaryTextStyleMedium(
                                                                  fontSize:
                                                                      AppDimens
                                                                          .textMedium,
                                                                  alpha: Constants
                                                                      .lightAlfa)),
                                                        ],
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        if (controller
                                                            .mobileFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          hideKeyboard();
                                                          controller.sendOtp();
                                                        } else {
                                                          controller
                                                                  .activationModeMobile
                                                                  .value =
                                                              AutovalidateMode
                                                                  .onUserInteraction;
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            right: AppDimens
                                                                .paddingMedium),
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: AppDimens
                                                                .paddingMedium,
                                                            vertical: AppDimens
                                                                .paddingSmall),
                                                        //height: AppDimens.padding3XLarge,
                                                        decoration: BoxDecoration(
                                                            color: Get
                                                                .theme
                                                                .colorScheme
                                                                .secondary
                                                                .withAlpha(
                                                                    Constants
                                                                        .limit),
                                                            borderRadius: const BorderRadius
                                                                .horizontal(
                                                                left: Radius.circular(
                                                                    AppDimens
                                                                        .radiusCircle),
                                                                right: Radius.circular(
                                                                    AppDimens
                                                                        .radiusCircle))),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(
                                                              width: AppDimens
                                                                  .paddingSmall,
                                                            ),
                                                            Text(
                                                                LabelKeys
                                                                    .verify.tr,
                                                                style: secondaryTextStyleMedium(
                                                                    fontSize:
                                                                        AppDimens
                                                                            .textMedium,
                                                                    alpha: Constants
                                                                        .lightAlfa)),
                                                          ],
                                                        ),
                                                      ),
                                                    ))),
                                      onFieldSubmitted: (v) {},
                                    ),
                                  ),
                                  AppDimens.paddingMedium.ph,
                                  Text(
                                    gc.loginData.value.isMobileVerify == 1
                                        ? ''
                                        : 'Note: Pending',
                                    style: onBackgroundTextStyleRegular(
                                        fontSize: AppDimens.textMedium,
                                        alpha: Constants.veryLightAlfa),
                                  ),
                                  AppDimens.radiusCornerLarge.ph,
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: AppDimens.paddingExtraLarge,
                left: AppDimens.paddingExtraLarge,
                right: AppDimens.paddingExtraLarge,
                top: AppDimens.drawerIconSize,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        hideKeyboard();
                        Get.bottomSheet(
                          isScrollControlled: true,
                          BottomSheetWithClose(
                            widget: UploadImageBottomSheet(
                              onGalleryTap: () async {
                                printMessage("In Gallery");
                                Navigator.pop(context);
                                FGBGEvents.ignoreWhile(() async {
                                  controller.getImage(
                                      ImageSource.gallery, context);
                                });
                              },
                              onCameraTap: () async {
                                Navigator.pop(context);
                                  printMessage("On Camera tap");
                                  controller.getImage(
                                      ImageSource.camera, context);
                              },
                            ),
                            titleWidget: Text(
                              LabelKeys.selectPhotos.tr,
                              style: onBackgroundTextStyleSemiBold(
                                  fontSize: AppDimens.textLarge),
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.all(AppDimens.paddingSmall),
                              width: AppDimens.subscriptionCardHeight,
                              height: AppDimens.subscriptionCardHeight,
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.onBackground
                                    .withAlpha(Constants.mediumAlfa),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppDimens.paddingXXLarge)),
                              ),
                              child: controller.tempProfileImage.value.isEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.paddingXXLarge),
                                      child: SvgPicture.asset(
                                        IconPath.userProfile,
                                        fit: BoxFit.none,
                                      ),
                                    )
                                  : CommonNetworkImage(
                                      imageUrl:
                                          controller.tempProfileImage.value,
                                      width: AppDimens.subscriptionCardHeight,
                                      height: AppDimens.subscriptionCardHeight,
                                    ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.all(AppDimens.paddingTiny),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.surface,
                                border: Border.all(
                                    color: Get.theme.colorScheme.outline),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppDimens.paddingMedium)),
                              ),
                              child: SvgPicture.asset(
                                IconPath.edit,
                                fit: BoxFit.none,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    isKeyboardOpen
                        ? Container()
                        : MasterButtonsBounceEffect.gradiantButton(
                            btnText: LabelKeys.saveChange.tr,
                            onPressed: () {
                              printMessage(controller
                                  .editProfileFormKey.currentState!
                                  .validate());
                              if (controller.editProfileFormKey.currentState!
                                  .validate()) {
                                hideKeyboard();
                                controller.editProfile();
                              } else {
                                controller.activationMode.value =
                                    AutovalidateMode.onUserInteraction;
                              }
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle labelStyle() {
    return onBackGroundTextStyleMedium(alpha: Constants.veryLightAlfa);
  }
}
