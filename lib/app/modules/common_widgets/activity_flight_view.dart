import 'package:flutter/material.dart';
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

class ActivityFlightView extends StatelessWidget {
  ActivityFlightView({
    Key? key,
    required this.onArrivalDateTap,
    required this.arrivalDate,
    required this.onArrivalTimeTap,
    this.arrivalTime,
    required this.onDepartureDateTap,
    required this.departureDate,
    required this.onDepartureTimeTap,
    this.departureTime,
    required this.flightTextController,
    required this.flightNumberArrivalTextController,
    required this.flightNumberDepartureTextController,
    required this.tripDetailTextController,
    required this.descFlightCount,
    required this.onChangedFlight,
    required this.onSubmitPressed,
    required this.flightFormKey,
    required this.flightActivationMode,
  }) : super(key: key);

  final Function onArrivalDateTap;
  final String arrivalDate;
  final Function onArrivalTimeTap;
  final String? arrivalTime;
  final Function onDepartureDateTap;
  final String departureDate;
  final Function onDepartureTimeTap;
  final String? departureTime;
  final TextEditingController flightTextController;
  final TextEditingController flightNumberArrivalTextController;
  final TextEditingController flightNumberDepartureTextController;
  final TextEditingController tripDetailTextController;
  RxString descFlightCount;
  final Function onChangedFlight;
  final Function onSubmitPressed;
  final GlobalKey<FormState> flightFormKey;
  final AutovalidateMode flightActivationMode;

  @override
  Widget build(BuildContext context) {
    return ScrollViewRoundedCorner(
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppDimens.paddingExtraLarge,
            right: AppDimens.paddingExtraLarge,
            top: AppDimens.paddingExtraLarge),
        child: Form(
          autovalidateMode: flightActivationMode,
          key: flightFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flight Name text and text field
              Text(
                LabelKeys.airline.tr,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              CustomTextField(
                  controller: flightTextController,
                  inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                    border: const UnderlineInputBorder(),
                    isDense: true,
                    prefixRightPadding: 0,
                    /*labelText: "Enter Flight Name",
                      labelStyle: onBackgroundTextStyleRegular(
                          alpha: Constants.lightAlfa),*/
                  ),
                  validator: (v) {
                    return CustomTextField.validatorFunction(
                        v!,
                        ValidationTypes.other,
                        LabelKeys.cBlankActivityFlightName.tr);
                  }),
              AppDimens.paddingMedium.ph,
              // Arrival section
              Text(
                LabelKeys.arrival.tr,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              AppDimens.paddingMedium.ph,
              // Flight number
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: flightNumberArrivalTextController,
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        prefixRightPadding: 0,
                        hintText: LabelKeys.fightNo.tr,
                        hintStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    validator: (v) {
                      return CustomTextField.validatorFunction(
                          v!,
                          ValidationTypes.other,
                          LabelKeys.cBlankActivityFlightArrivalNumber.tr);
                    }),
                titleName: LabelKeys.flightNumber.tr,
                iconPath: IconPath.flightNoIcon,
              ),
              AppDimens.paddingMedium.ph,
              //Arrival date
              InkWell(
                onTap: () {
                  onArrivalDateTap();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    arrivalDate,
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.arrivalDate.tr,
                  iconPath: IconPath.icCalendar,
                ),
              ),
              AppDimens.paddingMedium.ph,
              // Ariival time
              InkWell(
                onTap: () {
                  onArrivalTimeTap();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    arrivalTime ?? "HH:MM",
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.activityArrivalTime.tr,
                  iconPath: IconPath.iconTime,
                ),
              ),
              AppDimens.paddingMedium.ph,
              // Departure Section
              Text(
                LabelKeys.departure.tr,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              AppDimens.paddingMedium.ph,
              // Flight Number
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: flightNumberDepartureTextController,
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        prefixRightPadding: 0,
                        hintText: LabelKeys.departureNo.tr,
                        hintStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    validator: (v) {
                      return CustomTextField.validatorFunction(
                          v!,
                          ValidationTypes.other,
                          LabelKeys.cBlankActivityFlightDepartureNumber.tr);
                    }),
                titleName: LabelKeys.flightNumber.tr,
                iconPath: IconPath.flightNoIcon,
              ),
              AppDimens.paddingMedium.ph,
              // Departure Date
              InkWell(
                onTap: () {
                  onDepartureDateTap();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    departureDate,
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.departureDate.tr,
                  iconPath: IconPath.icCalendar,
                ),
              ),
              AppDimens.paddingMedium.ph,
              // Departure Time
              InkWell(
                onTap: () {
                  onDepartureTimeTap();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    departureTime ?? "HH:MM",
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.departureTime.tr,
                  iconPath: IconPath.iconTime,
                ),
              ),
              AppDimens.paddingMedium.ph,
              // Guests on This Flight
              /*Container(
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
                    top: AppDimens.paddingMedium,
                    bottom: AppDimens.paddingMedium),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: SvgPicture.asset(
                              IconPath.usersDoubleGreen,
                              height: AppDimens.normalIconSize,
                              width: AppDimens.normalIconSize,
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
                                  "Guests on This Flight",
                                  style: onBackGroundTextStyleMedium(
                                      fontSize: AppDimens.textLarge),
                                ),
                                Text(
                                  "Not Selected",
                                  style: onBackgroundTextStyleRegular(
                                      fontSize: AppDimens.textMedium,
                                      alpha: Constants.transparentAlpha),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(IconPath.forwardArrow)
                  ],
                ),
              ),
              AppDimens.paddingMedium.ph,*/

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
                      controller: tripDetailTextController,
                      inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: LabelKeys.addTripDetails.tr,
                          isDense: true,
                          prefixRightPadding: 0,
                          alignLabelWithHint: true,
                          hintStyle: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textLarge,
                              alpha: Constants.transparentAlpha)),
                      onChanged: (v) {
                        descFlightCount.value =
                            (250 - (v.toString().length)).toString();
                      },
                    )
                  ],
                ),
              ),
              AppDimens.paddingSmall.ph,
              Obx(
                () => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${descFlightCount.value} ${Constants.characterCountLabel}",
                    style: onBackgroundTextStyleRegular(
                        alpha: Constants.transparentAlpha),
                  ),
                ),
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
