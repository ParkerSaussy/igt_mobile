import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/placeholder_container_with_icon.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';

class ActivityHotelView extends StatelessWidget {
  ActivityHotelView(
      {Key? key,
      required this.onDateTapped,
      required this.pickedDate,
      required this.onNightPlusTapped,
      required this.onNightMinusTapped,
      required this.numberOfNights,
      required this.onCapacityPlusTapped,
      required this.onCapacityMinusTapped,
      required this.capacityPerRoom,
      required this.hotelCheckInTapped,
      required this.hotelCheckOutTapped,
      this.hotelCheckInTime,
      this.hotelCheckOutTime,
      required this.hotelNameController,
      required this.avgNightlyController,
      required this.totalCostController,
      required this.addressController,
      required this.roomNoController,
      required this.descriptionController,
      required this.urlController,
      required this.descCount,
      required this.onChanged,
      required this.onSubmitPressed,
      required this.hotelFormKey,
      required this.hotelActivationMode})
      : super(key: key);

  final Function onDateTapped;
  final String pickedDate;
  final Function onNightPlusTapped;
  final Function onNightMinusTapped;
  final int numberOfNights;
  final Function onCapacityPlusTapped;
  final Function onCapacityMinusTapped;
  final int capacityPerRoom;
  final Function hotelCheckInTapped;
  final Function hotelCheckOutTapped;
  final String? hotelCheckInTime;
  final String? hotelCheckOutTime;
  final TextEditingController hotelNameController;
  final TextEditingController avgNightlyController;
  final TextEditingController totalCostController;
  final TextEditingController addressController;
  final TextEditingController roomNoController;
  final TextEditingController descriptionController;
  final TextEditingController urlController;
  RxString descCount;
  final Function onChanged;
  final Function onSubmitPressed;
  final GlobalKey<FormState> hotelFormKey;
  final AutovalidateMode hotelActivationMode;

  @override
  Widget build(BuildContext context) {
    return ScrollViewRoundedCorner(
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppDimens.paddingExtraLarge,
            right: AppDimens.paddingExtraLarge,
            top: AppDimens.paddingExtraLarge),
        child: Form(
          autovalidateMode: hotelActivationMode,
          key: hotelFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel name text and text field
              Text(
                LabelKeys.hotelName.tr,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              CustomTextField(
                  controller: hotelNameController,
                  inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                    border: const UnderlineInputBorder(),
                    isDense: true,
                    prefixRightPadding: 0,
                    /*labelText: "Enter Hotel Name",
                      labelStyle: onBackgroundTextStyleRegular(
                          alpha: Constants.lightAlfa),*/
                  ),
                  validator: (v) {
                    return CustomTextField.validatorFunction(
                        v!,
                        ValidationTypes.other,
                        LabelKeys.cBlankActivityHotelName.tr);
                  }),
              AppDimens.paddingExtraLarge.ph,
              //Select Date
              InkWell(
                onTap: () {
                  onDateTapped();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    pickedDate,
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.selectDate.tr,
                  iconPath: IconPath.icCalendar,
                ),
              ),
              AppDimens.paddingMedium.ph,
              //Number of Nights
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.radiusCorner)),
                  border: Border.all(
                      width: 1,
                      color: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.limit)),
                ),
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingMedium,
                    right: AppDimens.paddingMedium,
                    top: AppDimens.paddingXLarge,
                    bottom: AppDimens.paddingXLarge),
                child: Row(
                  children: [
                    SvgPicture.asset(IconPath.nightsIcon),
                    AppDimens.paddingLarge.pw,
                    Expanded(
                      child: Text(
                        LabelKeys.numberOfNights.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textLarge),
                      ),
                    ),
                    Row(
                      children: [
                        MasterButtonsBounceEffect.iconButton(
                            svgUrl: IconPath.decrementIcon,
                            iconSize: AppDimens.normalIconSize,
                            onPressed: () {
                              onNightMinusTapped();
                            }),
                        AppDimens.paddingSmall.pw,
                        SizedBox(
                          width: AppDimens.twoDigitTextWidth,
                          child: Text(
                            numberOfNights.toString(),
                            style: onBackGroundTextStyleMedium(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AppDimens.paddingSmall.pw,
                        MasterButtonsBounceEffect.iconButton(
                            svgUrl: IconPath.addButtonGreyBg,
                            iconSize: AppDimens.normalIconSize,
                            onPressed: () {
                              onNightPlusTapped();
                            }),
                      ],
                    )
                  ],
                ),
              ),
              AppDimens.paddingMedium.ph,
              //Average nightly cost
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: avgNightlyController,
                    keyBoardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,2})')),
                    ],
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        prefixRightPadding: 0,
                        hintText: "100",
                        prefixText: "\$",
                        hintStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    validator: (v) {
                      return CustomTextField.validatorFunction(
                          v!,
                          ValidationTypes.other,
                          LabelKeys.cBlankActivityHotelNightCost.tr);
                    }),
                titleName: LabelKeys.averageNightlyCost.tr,
                iconPath: IconPath.avgCostIcon,
              ),
              AppDimens.paddingMedium.ph,
              //Total Cost
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: totalCostController,
                    keyBoardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,2})')),
                    ],
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        prefixRightPadding: 0,
                        hintText: LabelKeys.diningCoast.tr,
                        prefixText: "\$",
                        hintStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    validator: (v) {
                      return CustomTextField.validatorFunction(
                          v!,
                          ValidationTypes.other,
                          LabelKeys.cBlankActivityHotelTotalCost.tr);
                    }),
                titleName: LabelKeys.totalCost.tr,
                iconPath: IconPath.totalCost,
              ),
              AppDimens.paddingMedium.ph,
              //Capacity per room
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.radiusCorner)),
                  border: Border.all(
                      width: 1,
                      color: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.limit)),
                ),
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingMedium,
                    right: AppDimens.paddingMedium,
                    top: AppDimens.paddingXLarge,
                    bottom: AppDimens.paddingXLarge),
                child: Row(
                  children: [
                    SvgPicture.asset(IconPath.bedIcon),
                    AppDimens.paddingLarge.pw,
                    Expanded(
                      child: Text(
                        LabelKeys.capacityPerRoom.tr,
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textLarge),
                      ),
                    ),
                    Row(
                      children: [
                        MasterButtonsBounceEffect.iconButton(
                            svgUrl: IconPath.decrementIcon,
                            iconSize: AppDimens.normalIconSize,
                            onPressed: () {
                              onCapacityMinusTapped();
                            }),
                        AppDimens.paddingSmall.pw,
                        SizedBox(
                          width: AppDimens.twoDigitTextWidth,
                          child: Text(
                            capacityPerRoom.toString(),
                            style: onBackGroundTextStyleMedium(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AppDimens.paddingSmall.pw,
                        MasterButtonsBounceEffect.iconButton(
                            svgUrl: IconPath.addButtonGreyBg,
                            iconSize: AppDimens.normalIconSize,
                            onPressed: () {
                              onCapacityPlusTapped();
                            }),
                      ],
                    )
                  ],
                ),
              ),
              AppDimens.paddingMedium.ph,
              // Add Address
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.radiusCorner)),
                  border: Border.all(
                      width: 1,
                      color: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.limit)),
                ),
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge,
                    top: AppDimens.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LabelKeys.addAddress.tr,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textLarge),
                    ),
                    CustomTextField(
                        maxLines: 5,
                        controller: addressController,
                        maxLength: 250,
                        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: LabelKeys.enterAddress.tr,
                            prefixRightPadding: 0,
                            isDense: true,
                            alignLabelWithHint: true,
                            hintStyle: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textLarge,
                                alpha: Constants.transparentAlpha)),
                        validator: (v) {
                          return CustomTextField.validatorFunction(
                              v!,
                              ValidationTypes.other,
                              LabelKeys.cBlankAddress.tr);
                        })
                  ],
                ),
              ),
              AppDimens.paddingExtraLarge.ph,
              //Room Number
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: roomNoController,
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        prefixRightPadding: 0,
                        hintText: LabelKeys.hotelRoomsNo.tr,
                        hintStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    validator: (v) {
                      /*return CustomTextField.validatorFunction(
                          v!,
                          ValidationTypes.other,
                          LabelKeys.cBlankActivityHotelRoomNumber.tr);*/
                    }),
                titleName: LabelKeys.roomNumber.tr,
                iconPath: IconPath.roomNoIcon,
              ),
              AppDimens.paddingExtraLarge.ph,
              //Hotel Timing
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.radiusCorner)),
                    border: Border.all(
                        width: 1,
                        color: Get.theme.colorScheme.onBackground
                            .withAlpha(Constants.limit))),
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingMedium,
                    right: AppDimens.paddingMedium,
                    top: AppDimens.paddingMedium,
                    bottom: AppDimens.paddingMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: SvgPicture.asset(
                        IconPath.roomNoIcon,
                        colorFilter: ColorFilter.mode(
                            Get.theme.colorScheme.primary, BlendMode.srcIn),
                      ),
                    ),
                    AppDimens.paddingLarge.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LabelKeys.hotelTiming.tr,
                            style: onBackGroundTextStyleMedium(
                                fontSize: AppDimens.textLarge),
                          ),
                          AppDimens.paddingMedium.ph,
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  hotelCheckInTapped();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LabelKeys.checkIn.tr,
                                      style: onBackGroundTextStyleMedium(),
                                    ),
                                    Text(
                                      hotelCheckInTime ?? "HH:MM",
                                      style: onBackgroundTextStyleRegular(
                                          alpha: Constants.veryLightAlfa),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: SvgPicture.asset(IconPath.arrowLong)),
                              GestureDetector(
                                onTap: () {
                                  hotelCheckOutTapped();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LabelKeys.checkOut.tr,
                                      style: onBackGroundTextStyleMedium(),
                                    ),
                                    Text(
                                      hotelCheckOutTime ?? "HH:MM",
                                      style: onBackgroundTextStyleRegular(
                                          alpha: Constants.veryLightAlfa),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              AppDimens.paddingMedium.ph,
              // Add Description
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimens.radiusCorner)),
                  border: Border.all(
                      width: 1,
                      color: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.limit)),
                ),
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge,
                    top: AppDimens.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LabelKeys.addDescription.tr,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textLarge),
                    ),
                    CustomTextField(
                      maxLines: 5,
                      maxLength: 250,
                      controller: descriptionController,
                      onChanged: (v) {
                        descCount.value =
                            (250 - (v.toString().length)).toString();
                      },
                      inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: LabelKeys.addTripDetails.tr,
                          isDense: true,
                          prefixRightPadding: 0,
                          counterText: "",
                          counterStyle: onBackgroundTextStyleRegular(
                              alpha: Constants.transparentAlpha),
                          alignLabelWithHint: true,
                          hintStyle: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textLarge,
                              alpha: Constants.transparentAlpha)),
                    )
                  ],
                ),
              ),
              AppDimens.paddingSmall.ph,
              //Word counter
              Obx(() => Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${descCount.value} ${Constants.characterCountLabel}",
                      style: onBackgroundTextStyleRegular(
                          alpha: Constants.transparentAlpha),
                    ),
                  )),
              AppDimens.paddingExtraLarge.ph,
              //URL text field
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                  controller: urlController,
                  maxLength: 150,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return null;
                    } else {
                      return CustomTextField.validatorFunction(
                          v,
                          ValidationTypes.url,
                          LabelKeys.cBlankActivityHotelUrl.tr);
                    }
                  },
                  inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      prefixRightPadding: 0,
                      hintText: LabelKeys.enterHere.tr,
                      hintStyle: onBackgroundTextStyleRegular(
                          alpha: Constants.transparentAlpha)),
                ),
                titleName: LabelKeys.eventUrl.tr,
                iconPath: IconPath.urlIcon,
              ),

              AppDimens.paddingExtraLarge.ph,
              MasterButtonsBounceEffect.gradiantButton(
                  onPressed: onSubmitPressed,
                  btnText: LabelKeys.submit.tr,
                  textStyles:
                      onPrimaryTextStyleMedium(fontSize: AppDimens.textLarge)),
              AppDimens.paddingExtraLarge.ph,
            ],
          ),
        ),
      ),
    );
  }
}
