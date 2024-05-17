import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/custom_dropdown.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import 'add_guest_import_controller.dart';

class AddGuestImportView extends GetView<AddGuestImportController> {
  const AddGuestImportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          isCustomTitle: true,
          customTitleWidget:
              CustomAppBar.backButton(backText: LabelKeys.invitees.tr),
        ),
        body: GestureDetector(
          onTap: () {
            Get.focusScope?.unfocus();
          },
          child: SafeArea(
            bottom: false,
            child: ContainerTopRoundedCorner(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge,
                    top: AppDimens.paddingExtraLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LabelKeys.addNewGuest.tr,
                              style: onBackGroundTextStyleMedium(
                                  fontSize: AppDimens.textLarge),
                            ),
                            const SizedBox(
                              height: AppDimens.paddingExtraLarge,
                            ),
                            InkWell(
                              onTap: () {
                                Get.focusScope?.unfocus();
                                Get.toNamed(Routes.SEARCH_CONTACT_SCREEN,
                                    arguments: [
                                      controller.tripId,
                                      controller.isHostOrCoHost.value,
                                      controller.isTripFinalized.value
                                    ]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      width: 1,
                                      color: Get.theme.colorScheme.onBackground
                                          .withAlpha(Constants.limit)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppDimens.radiusCorner)),
                                ),
                                padding: const EdgeInsets.only(
                                    left: AppDimens.paddingMedium,
                                    right: AppDimens.paddingMedium,
                                    top: AppDimens.paddingMedium,
                                    bottom: AppDimens.paddingMedium),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            LabelKeys.searchContact.tr,
                                            style:
                                                onBackGroundTextStyleMedium(),
                                          ),
                                          const SizedBox(
                                            height: AppDimens.paddingTiny,
                                          ),
                                          Text(
                                            LabelKeys.loadGuestYourContacts.tr,
                                            style: onBackgroundTextStyleRegular(
                                                alpha: Constants.lightAlfa),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 26,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: AppDimens.paddingMedium,
                            ),
                            InkWell(
                              onTap: () {
                                Get.focusScope?.unfocus();
                                Get.toNamed(Routes.EVENT_TRIP_LIST_SCREEN,
                                    arguments: [
                                      controller.tripId,
                                      controller.isHostOrCoHost.value,
                                      controller.isTripFinalized.value
                                    ]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: Get.theme.colorScheme.onBackground
                                          .withAlpha(Constants.limit)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(AppDimens.radiusCorner)),
                                ),
                                padding: const EdgeInsets.only(
                                    left: AppDimens.paddingMedium,
                                    right: AppDimens.paddingMedium,
                                    top: AppDimens.paddingMedium,
                                    bottom: AppDimens.paddingMedium),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            LabelKeys
                                                .importContactFromOtherTrips.tr,
                                            style:
                                                onBackGroundTextStyleMedium(),
                                          ),
                                          const SizedBox(
                                            height: AppDimens.paddingTiny,
                                          ),
                                          Text(
                                            LabelKeys
                                                .loadGuestYourOtherTrips.tr,
                                            style: onBackgroundTextStyleRegular(
                                                alpha: Constants.lightAlfa),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 26,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: AppDimens.paddingExtraLarge,
                            ),
                            Text(
                              LabelKeys.manually.tr,
                              style: onBackGroundTextStyleMedium(
                                  fontSize: AppDimens.textLarge),
                            ),
                            const SizedBox(
                              height: AppDimens.paddingExtraLarge,
                            ),
                            Obx(
                              () => Form(
                                autovalidateMode:
                                    controller.activationMode.value,
                                key: controller.signupFormKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        CustomTextField(
                                            controller:
                                                controller.firstNameController,
                                            focusNode:
                                                controller.firstNameFocusNode,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              controller.lastNameFocusNode
                                                  .requestFocus();
                                            },
                                            inputDecoration: CustomTextField
                                                .prefixSuffixOnlyIcon(
                                              border:
                                                  const UnderlineInputBorder(),
                                              isDense: true,
                                              labelText: LabelKeys.firstName.tr,
                                              labelStyle:
                                                  onBackgroundTextStyleRegular(
                                                      alpha:
                                                          Constants.lightAlfa),
                                              prefixIcon: SvgPicture.asset(
                                                  IconPath.user),
                                            ),
                                            validator: (v) {
                                              return CustomTextField
                                                  .validatorFunction(
                                                      v!,
                                                      ValidationTypes.other,
                                                      LabelKeys.cBlankFName.tr);
                                            }),
                                        const SizedBox(
                                          height: AppDimens.paddingExtraLarge,
                                        ),
                                        CustomTextField(
                                            controller:
                                                controller.lastNameController,
                                            focusNode:
                                                controller.lastNameFocusNode,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              controller.emailFocusNode
                                                  .requestFocus();
                                            },
                                            inputDecoration: CustomTextField
                                                .prefixSuffixOnlyIcon(
                                              border:
                                                  const UnderlineInputBorder(),
                                              isDense: true,
                                              //hintText: "Last Name",
                                              labelText: LabelKeys.lastName.tr,
                                              labelStyle:
                                                  onBackgroundTextStyleRegular(
                                                      alpha:
                                                          Constants.lightAlfa),
                                              prefixIcon: SvgPicture.asset(
                                                  IconPath.user),
                                            ),
                                            validator: (v) {
                                              return CustomTextField
                                                  .validatorFunction(
                                                      v!,
                                                      ValidationTypes.other,
                                                      LabelKeys.cBlankLName.tr);
                                            }),
                                        const SizedBox(
                                          height: AppDimens.paddingExtraLarge,
                                        ),
                                        CustomTextField(
                                            controller:
                                                controller.emailController,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode:
                                                controller.emailFocusNode,
                                            onFieldSubmitted: (v) {
                                              controller.phoneFocusNode
                                                  .requestFocus();
                                            },
                                            keyBoardType:
                                                TextInputType.emailAddress,
                                            inputDecoration: CustomTextField
                                                .prefixSuffixOnlyIcon(
                                              border:
                                                  const UnderlineInputBorder(),
                                              isDense: true,
                                              //hintText: "Email Address",
                                              labelText:
                                                  LabelKeys.emailAddress.tr,
                                              labelStyle:
                                                  onBackgroundTextStyleRegular(
                                                      alpha:
                                                          Constants.lightAlfa),
                                              prefixIcon: SvgPicture.asset(
                                                  IconPath.email),
                                            ),
                                            validator: (v) {
                                              return CustomTextField
                                                  .validatorFunction(
                                                      v!,
                                                      ValidationTypes.email,
                                                      LabelKeys.cBlankEmail.tr);
                                            }),
                                        const SizedBox(
                                          height: AppDimens.paddingExtraLarge,
                                        ),
                                        CustomTextField(
                                            controller:
                                                controller.phoneController,
                                            textInputAction:
                                                TextInputAction.done,
                                            focusNode:
                                                controller.phoneFocusNode,
                                            keyBoardType: TextInputType.phone,
                                            inputDecoration: CustomTextField
                                                .prefixSuffixOnlyIcon(
                                              border:
                                                  const UnderlineInputBorder(),
                                              isDense: true,
                                              //hintText: "Phone number",
                                              labelText:
                                                  LabelKeys.phoneNumber.tr,
                                              labelStyle:
                                                  onBackgroundTextStyleRegular(
                                                      alpha:
                                                          Constants.lightAlfa),
                                              prefixIconConstraints:
                                                  const BoxConstraints(
                                                      maxHeight: 60),
                                              prefixIcon: Row(
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
                                                    width:
                                                        AppDimens.paddingSmall,
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: AppDimens
                                                            .paddingMedium,
                                                        vertical: AppDimens
                                                            .paddingSmall,
                                                      ),
                                                      child: Text(
                                                        controller
                                                            .countryCode.value,
                                                        style:
                                                            onBackgroundTextStyleRegular(),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width:
                                                        AppDimens.paddingSmall,
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: AppDimens
                                                        .ratingBarIconSize,
                                                    color: Get.theme.colorScheme
                                                        .onBackground
                                                        .withAlpha(Constants
                                                            .lightAlfa),
                                                  )
                                                ],
                                              ),
                                            ),
                                            validator: (v) {
                                              if (v!.isEmpty) {
                                                return null;
                                              } else {
                                                return CustomTextField
                                                    .validatorFunction(
                                                        v,
                                                        ValidationTypes.phone,
                                                        LabelKeys
                                                            .cBlankPhoneNumber
                                                            .tr);
                                              }
                                            }),
                                        AppDimens.paddingExtraLarge.ph,
                                        CustomDropDown(
                                          labelText: LabelKeys.selectRole.tr,
                                          hintText: LabelKeys.selectRole.tr,
                                          onTap: () {
                                            Get.focusScope?.unfocus();
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.toString().isEmpty) {
                                              return LabelKeys
                                                  .cBlankSelectGuest.tr;
                                            }
                                            return null;
                                          },
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                top: AppDimens.paddingLarge,
                                                right: AppDimens.paddingLarge,
                                                bottom: AppDimens.paddingLarge),
                                            child:
                                                SvgPicture.asset(IconPath.user),
                                          ),
                                          options: controller.lstGuest,
                                          value: controller.selectedGuest.value,
                                          onChanged: (value) {
                                            controller.selectedGuest.value =
                                                value.toString();
                                          },
                                          icon: SvgPicture.asset(
                                              IconPath.downArrow),
                                          getLabel: (value) => value.toString(),
                                        ),
                                      ],
                                    ),
                                    //Spacer(),
                                    AppDimens.paddingExtraLarge.ph,
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: MasterButtonsBounceEffect
                                          .gradiantButton(
                                        btnText: LabelKeys.add.tr,
                                        onPressed: () {
                                          if (controller
                                              .signupFormKey.currentState!
                                              .validate()) {
                                            Get.focusScope?.unfocus();
                                            controller.addGuestAPI();
                                            //Get.back();
                                          } else {
                                            controller.activationMode.value =
                                                AutovalidateMode
                                                    .onUserInteraction;
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
