import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/text_field_validations.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../common_widgets/bottomsheet_with_close.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import '../../common_widgets/scrollview_rounded_corner.dart';
import 'contactus_controller.dart';

class ContactusView extends GetView<ContactusController> {
  const ContactusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
          appBar: CustomAppBar.buildAppBar(
            leadingWidth: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            isCustomTitle: true,
            customTitleWidget: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: AppDimens.paddingMedium,
                    bottom: AppDimens.paddingMedium,
                    right: AppDimens.paddingMedium),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(IconPath.backArrow),
                    const SizedBox(
                      width: AppDimens.paddingMedium,
                    ),
                    Text(
                      LabelKeys.back.tr,
                      style: onBackgroundTextStyleRegular(),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: Obx(
            () => SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingExtraLarge),
                    child: Text(LabelKeys.contactUs.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textExtraLarge,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                  ),
                  AppDimens.paddingSmall.ph,
                  Expanded(
                    child: ContainerTopRoundedCorner(
                      child: ScrollViewRoundedCorner(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingLarge),
                          child: Form(
                            autovalidateMode: controller.activationMode.value,
                            key: controller.contactusFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppDimens.paddingExtraLarge.ph,
                                Container(
                                  padding: const EdgeInsets.all(
                                      AppDimens.paddingLarge),
                                  decoration: BoxDecoration(
                                      color: Get.theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(
                                          AppDimens.paddingExtraLarge),
                                      border: Border.all(
                                          color: Get.theme.colorScheme.outline
                                              .withAlpha(
                                                  Constants.lightAlfa)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Get.theme.dividerColor,
                                          // blurRadius: AppDimens.paddingTiny,
                                        ),
                                      ]),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            IconPath.iconGallery,
                                            width: 26,
                                            height: 26,
                                            colorFilter: ColorFilter.mode(
                                                Get.theme.colorScheme.primary,
                                                BlendMode.srcIn),
                                          ),
                                          AppDimens.paddingMedium.pw,
                                          Text(
                                            LabelKeys.address.tr,
                                            style:
                                                onBackGroundTextStyleMedium(
                                                    fontSize:
                                                        AppDimens.textLarge,
                                                    alpha:
                                                        Constants.darkAlfa),
                                          ),
                                        ],
                                      ),
                                      AppDimens.paddingLarge.ph,
                                      Text(
                                        'Street: 3416 Sardis Station, City: Minneapolis State: Minnesota, Country: United States\nZip code: 55414\nPhone number: 612-378-6747\nMail Address: Lesgohelp@demo.com',
                                        style: onBackgroundTextStyleRegular(),
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                                AppDimens.paddingExtraLarge.ph,
                                Text(
                                  LabelKeys.getInTouchWithTeam.tr,
                                  style: onBackGroundTextStyleMedium(
                                      fontSize: AppDimens.textLarge,
                                      alpha: Constants.darkAlfa),
                                ),
                                AppDimens.paddingLarge.ph,
                                CustomTextField(
                                    controller: controller.fNameController,
                                    focusNode: controller.fNameNode,
                                    textInputAction: TextInputAction.next,
                                    inputDecoration:
                                        CustomTextField.prefixSuffixOnlyIcon(
                                      border: const UnderlineInputBorder(),
                                      labelText: LabelKeys.fullName.tr,
                                    ),
                                    onFieldSubmitted: (v) {
                                      controller.emailNode.requestFocus();
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
                                              LabelKeys.emptyFullName.tr);
                                    }),
                                AppDimens.paddingLarge.ph,
                                CustomTextField(
                                    controller: controller.emailController,
                                    focusNode: controller.emailNode,
                                    keyBoardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    inputDecoration:
                                        CustomTextField.prefixSuffixOnlyIcon(
                                      border: const UnderlineInputBorder(),
                                      labelText: LabelKeys.emailAddress.tr,
                                    ),
                                    onFieldSubmitted: (v) {
                                      controller.messageNode.requestFocus();
                                    },
                                    onChanged: (v) {
                                      TextFieldValidation.validateEmail(v);
                                    },
                                    validator: (v) {
                                      return CustomTextField
                                          .validatorFunction(
                                              v!,
                                              ValidationTypes.email,
                                              LabelKeys.cBlankEmail.tr);
                                    }),
                                AppDimens.paddingLarge.ph,
                                CustomTextField(
                                    controller: controller.messageController,
                                    focusNode: controller.messageNode,
                                    keyBoardType: TextInputType.multiline,
                                    maxLength: 250,
                                    //textInputAction: TextInputAction.next,
                                    maxLines: 3,
                                    inputDecoration:
                                        CustomTextField.prefixSuffixOnlyIcon(
                                      border: const UnderlineInputBorder(),
                                      labelText: LabelKeys.message.tr,
                                    ),
                                    onFieldSubmitted: (v) {
                                      controller.messageNode.requestFocus();
                                    },
                                    onChanged: (v) {},
                                    validator: (v) {
                                      return CustomTextField
                                          .validatorFunction(
                                              v!,
                                              ValidationTypes.other,
                                              LabelKeys.blankMessage.tr);
                                    }),
                                AppDimens.paddingHuge.ph,
                                /*isKeyboardOpen
                                  ? Container()
                                  :*/
                                MasterButtonsBounceEffect.gradiantButton(
                                  btnText: LabelKeys.submit.tr,
                                  onPressed: () {
                                    printMessage(controller
                                        .contactusFormKey.currentState!
                                        .validate());
                                    if (controller
                                        .contactusFormKey.currentState!
                                        .validate()) {
                                      hideKeyboard();
                                      controller.submit();
                                    } else {
                                      controller.activationMode.value =
                                          AutovalidateMode.onUserInteraction;
                                    }
                                  },
                                ),
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
          )),
    );
  }
}
