import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:pinput/pinput.dart';

import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottomsheet_with_close.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import 'myprofile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          actionWidget: [
            GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.EDITPROFILE);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      top: AppDimens.paddingMedium,
                      bottom: AppDimens.paddingMedium,
                      right: AppDimens.paddingMedium),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingMedium,
                      vertical: AppDimens.paddingSmall),
                  //height: AppDimens.padding3XLarge,
                  decoration: BoxDecoration(
                      color: Get.theme.colorScheme.tertiaryContainer,
                      /*border: Border.all(
                          color: Get.theme.colorScheme.background,
                          width: AppDimens.paddingNano),*/
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(AppDimens.radiusCircle),
                          right: Radius.circular(AppDimens.radiusCircle))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(IconPath.edit),
                      const SizedBox(
                        width: AppDimens.paddingSmall,
                      ),
                      Text(LabelKeys.edit.tr,
                          style: onBackGroundTextStyleMedium(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.lightAlfa)),
                    ],
                  ),
                )),
          ],
          isCustomTitle: true,
          customTitleWidget:
              /*controller.fromScreen.value == Constants.fromDashboard
                  ? GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimens.paddingMedium),
                            color: Get.theme.colorScheme.primary),
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        margin: const EdgeInsets.all(AppDimens.paddingMedium),
                        child: SvgPicture.asset(IconPath.homeIcon),
                      ),
                    )
                  : */
              CustomAppBar.backButton(),
        ),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingLarge),
                child: Text(LabelKeys.myProfile.tr,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textExtraLarge),
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: controller.myProfileId.isNotEmpty
                    ? Stack(
                        children: [
                          Positioned.fill(
                            top: AppDimens.avatarHeight,
                            child: ContainerTopRoundedCorner(
                              child: ScrollViewRoundedCorner(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppDimens.paddingLarge,
                                      right: AppDimens.paddingLarge,
                                      top: AppDimens.paddingLarge),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppDimens.radiusCircle.ph,
                                      gc.loginData.value.planEndDate != null &&
                                              gc.loginData.value.duration !=
                                                  null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(AppDimens
                                                          .radiusCornerLarge),
                                                  border: Border.all(
                                                      color: Get.theme
                                                          .colorScheme.primary,
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  color: const Color(0xffBCE4D0)
                                                      .withOpacity(0.15)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        bottom: AppDimens
                                                            .paddingExtraLarge),
                                                    child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                left: AppDimens
                                                                    .paddingLarge,
                                                                right: AppDimens
                                                                    .paddingLarge,
                                                                top: AppDimens
                                                                    .paddingLarge),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Date.shared().isDate1BeforeDate2(
                                                                            gc.loginData.value
                                                                                .planEndDate!,
                                                                            DateTime
                                                                                .now())
                                                                        ? Text(
                                                                            "your plan is Expired",
                                                                            style: onBackgroundTextStyleSemiBold(
                                                                                fontSize: AppDimens
                                                                                    .textSmall))
                                                                        : Text(
                                                                            "${"Your Subscription Plan will expire on"} \n${Date.shared().getDateFromUtc(gc.loginData.value.planEndDate!)}",
                                                                            style:
                                                                                onBackgroundTextStyleSemiBold(fontSize: AppDimens.textSmall)),
                                                                    gc.loginData.value.duration !=
                                                                            null
                                                                        ? Text(
                                                                            "Active Plan - ${gc.loginData.value.duration!} Month-s",
                                                                            style:
                                                                                onBackgroundTextStyleRegular(fontSize: AppDimens.textSmall))
                                                                        : const SizedBox(),
                                                                    gc.loginData.value.discountedPrice !=
                                                                            null
                                                                        ? RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              children: [
                                                                                TextSpan(text: "\$${gc.loginData.value.discountedPrice}", style: onBackgroundTextStyleSemiBold(fontSize: AppDimens.text2XLarge)),
                                                                                TextSpan(
                                                                                  text: " \$${gc.loginData.value.price}",
                                                                                  style: onBackgroundTextStyleRegular(fontSize: AppDimens.textSmall).copyWith(decoration: TextDecoration.lineThrough),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                                CachedNetworkImage(
                                                                  imageUrl: gc
                                                                      .loginData
                                                                      .value
                                                                      .image
                                                                      .toString(),
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    height: 60,
                                                                    width: 60,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              AppDimens.radiusCornerLarge)),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      const SizedBox(),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const SizedBox(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      AppDimens.paddingMedium.ph,
                                      myProfile(
                                          LabelKeys.firstName.tr,
                                          gc.loginData.value.firstName == null
                                              ? ""
                                              : gc.loginData.value.firstName
                                                  .toString(),
                                          IconPath.user,
                                          false,
                                          context),
                                      AppDimens.paddingMedium.ph,
                                      myProfile(
                                          LabelKeys.lastName.tr,
                                          gc.loginData.value.lastName == null
                                              ? ""
                                              : gc.loginData.value.lastName
                                                  .toString(),
                                          IconPath.user,
                                          false,
                                          context),
                                      AppDimens.paddingMedium.ph,
                                      myProfile(
                                          LabelKeys.emailID.tr,
                                          gc.loginData.value.email == null
                                              ? ""
                                              : gc.loginData.value.email
                                                  .toString(),
                                          IconPath.email,
                                          false,
                                          context),
                                      AppDimens.paddingMedium.ph,
                                      myProfile(
                                          LabelKeys.paypalUsername.tr,
                                          gc.loginData.value.paypalUsername ==
                                                  null
                                              ? ""
                                              : gc.loginData.value
                                                  .paypalUsername
                                                  .toString(),
                                          IconPath.iconPaypalGrey,
                                          false,
                                          context),
                                      AppDimens.paddingMedium.ph,
                                      myProfile(
                                          LabelKeys.venmoUsername.tr,
                                          gc.loginData.value.venmoUsername ==
                                                  null
                                              ? ""
                                              : gc.loginData.value.venmoUsername
                                                  .toString(),
                                          IconPath.iconVenmoGrey,
                                          false,
                                          context),
                                      AppDimens.paddingMedium.ph,
                                      myProfile(
                                          LabelKeys.mobileNumber.tr,
                                          gc.loginData.value.countryCode == null
                                              ? ""
                                              : "${gc.loginData.value.countryCode} ${gc.loginData.value.mobileNumber!}",
                                          IconPath.phone,
                                          gc.loginData.value.mobileNumber ==
                                                      null ||
                                                  gc.loginData.value
                                                          .mobileNumber! ==
                                                      ""
                                              ? false
                                              : true,
                                          context),
                                      AppDimens.paddingMedium.ph,
                                      gc.loginData.value.mobileNumber != null
                                          ? Text(
                                              gc.loginData.value
                                                          .isMobileVerify ==
                                                      1
                                                  ? ''
                                                  : LabelKeys.notePending.tr,
                                              style:
                                                  onBackgroundTextStyleRegular(
                                                      fontSize:
                                                          AppDimens.textMedium,
                                                      alpha: Constants
                                                          .veryLightAlfa),
                                            )
                                          : const SizedBox(),
                                      gc.loginData.value.isMobileVerify == 1
                                          ? 0.ph
                                          : AppDimens.paddingMedium.ph,
                                      gc.loginData.value.signinType ==
                                              SignInType.social
                                          ? const SizedBox()
                                          : Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                      Routes.CHANGEPASSWORD);
                                                },
                                                child: Text(
                                                  LabelKeys.changePassword.tr,
                                                  style:
                                                      secondaryTextStyleMedium(
                                                          fontSize: AppDimens
                                                              .textLarge),
                                                ),
                                              ),
                                            ),
                                      gc.loginData.value.isMobileVerify == 1
                                          ? AppDimens.padding3XLarge.ph
                                          : AppDimens.paddingMedium.ph,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.paddingExtraLarge),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(
                                        AppDimens.paddingSmall),
                                    width: AppDimens.subscriptionCardHeight,
                                    height: AppDimens.subscriptionCardHeight,
                                    decoration: BoxDecoration(
                                        color: Get
                                            .theme.colorScheme.onBackground
                                            .withAlpha(Constants.mediumAlfa),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.paddingXXLarge)),
                                        border: Border.all(
                                            width: AppDimens.paddingTiny,
                                            color: Colors.white)),
                                    child: gc.loginData.value.profileImage ==
                                            null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                AppDimens.paddingXXLarge),
                                            child: SvgPicture.asset(
                                              IconPath.userProfile,
                                              fit: BoxFit.none,
                                            ),
                                          )
                                        : gc.loginData.value.profileImage!
                                                .isNotEmpty
                                            ? CommonNetworkImage(
                                                imageUrl: gc.loginData.value
                                                    .profileImage
                                                    .toString(),
                                                width: AppDimens
                                                    .subscriptionCardHeight,
                                                height: AppDimens
                                                    .subscriptionCardHeight,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimens
                                                            .paddingXXLarge),
                                                child: SvgPicture.asset(
                                                  IconPath.userProfile,
                                                  fit: BoxFit.none,
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myProfile(String text1, String text2, String img, bool isVerify,
      BuildContext context) {
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
    return Container(
      height: AppDimens.circleNavBarHeight,
      decoration: BoxDecoration(
          border: Border.all(
            width: AppDimens.paddingNano,
            color: Get.theme.colorScheme.background
                .withAlpha(Constants.veryLightAlfa),
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppDimens.paddingSmall,
                      top: AppDimens.paddingSmall),
                  child: SvgPicture.asset(img),
                ),
                AppDimens.paddingMedium.pw,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text1,
                      style: onBackgroundTextStyleRegular(
                          fontSize: AppDimens.textMedium,
                          alpha: Constants.veryLightAlfa),
                    ),
                    Text(text2,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textLarge,
                            alpha: Constants.darkAlfa),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
            isVerify
                ? gc.loginData.value.isMobileVerify == 1
                    ? Container(
                        margin: const EdgeInsets.only(
                            right: AppDimens.paddingMedium),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingMedium,
                            vertical: AppDimens.paddingSmall),
                        //height: AppDimens.padding3XLarge,
                        decoration: BoxDecoration(
                            color: Get.theme.colorScheme.primary
                                .withAlpha(Constants.limit),
                            /*border: Border.all(
                          color: Get.theme.colorScheme.background,
                          width: AppDimens.paddingNano),*/
                            borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(AppDimens.radiusCircle),
                                right:
                                    Radius.circular(AppDimens.radiusCircle))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: AppDimens.paddingSmall,
                            ),
                            Text(LabelKeys.verified.tr,
                                style: primaryTextStyleMedium(
                                    fontSize: AppDimens.textMedium,
                                    alpha: Constants.lightAlfa)),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          controller.reciever =
                              gc.loginData.value.countryCode.toString() +
                                  gc.loginData.value.mobileNumber.toString();
                          controller.sendOtp();
                          Get.bottomSheet(
                            isScrollControlled: true,
                            Obx(
                              () => BottomSheetWithClose(
                                widget: Form(
                                  key: controller.pinFormKey,
                                  child: Column(
                                    children: [
                                      AppDimens.paddingMedium.ph,
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal:
                                                AppDimens.padding3XLarge),
                                        child: Pinput(
                                          length: 4,
                                          pinAnimationType:
                                              PinAnimationType.none,
                                          controller:
                                              controller.pinPutController,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: const TextInputType
                                              .numberWithOptions(signed: true),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          focusNode: controller.pinFocusNode,
                                          defaultPinTheme: defaultPinTheme,
                                          showCursor: false,
                                          validator: (v) {
                                            if (v!.isEmpty) {
                                              return LabelKeys
                                                  .enterVerificationCode.tr;
                                            }
                                            if (v.length != 4) {
                                              return LabelKeys
                                                  .validEnterVerificationCode
                                                  .tr;
                                            } else {}
                                            return null;
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
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  AppDimens.paddingLarge),
                                          child: MasterButtonsBounceEffect
                                              .gradiantButton(
                                            btnText: LabelKeys.verify.tr,
                                            onPressed: () {
                                              controller.pinFocusNode.unfocus();
                                              if (controller
                                                  .pinFormKey.currentState!
                                                  .validate()) {
                                                hideKeyboard();
                                                controller.verifyOtpAPI();
                                              }
                                            },
                                          )),
                                      AppDimens.paddingSmall.ph,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppDimens.paddingLarge),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: AppDimens.paddingHuge,
                                              alignment: Alignment.center,
                                              child: controller
                                                      .isResendVisible.value
                                                  ? const SizedBox()
                                                  : Text(
                                                      controller
                                                          .timeStart.value,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          primaryTextStyleSemiBold(
                                                              alpha: Constants
                                                                  .lightAlfa),
                                                    ),
                                            ),
                                            controller.isResendVisible.value
                                                ? MasterButtonsBounceEffect
                                                    .textButton(
                                                        btnText: LabelKeys
                                                            .resendOtp.tr,
                                                        onPressed: () {
                                                          controller
                                                              .pinPutController
                                                              .clear();
                                                          controller
                                                              .startTimer();
                                                          controller.sendOtp();
                                                        },
                                                        textStyles:
                                                            primaryTextStyleRegular(
                                                                fontSize: AppDimens
                                                                    .textMedium))
                                                : const SizedBox()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: AppDimens.paddingMedium),
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingMedium,
                              vertical: AppDimens.paddingSmall),
                          //height: AppDimens.padding3XLarge,
                          decoration: BoxDecoration(
                              color: Get.theme.colorScheme.secondary
                                  .withAlpha(Constants.limit),
                              /*border: Border.all(
                          color: Get.theme.colorScheme.background,
                          width: AppDimens.paddingNano),*/
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(AppDimens.radiusCircle),
                                  right:
                                      Radius.circular(AppDimens.radiusCircle))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: AppDimens.paddingSmall,
                              ),
                              Text(LabelKeys.verify.tr,
                                  style: secondaryTextStyleMedium(
                                      fontSize: AppDimens.textMedium,
                                      alpha: Constants.lightAlfa)),
                            ],
                          ),
                        ),
                      )
                : Container()
          ],
        ),
      ),
    );
  }
}
