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

class ActivityEventView extends StatelessWidget {
  ActivityEventView(
      {Key? key,
      required this.onSelectDateTapped,
      required this.eventDate,
      //required this.onEventHoursPlusTapped,
      //required this.onEventHoursMinusTapped,
      required this.numberOfEventHours,
      required this.timeInTapped,
      required this.timeOutTapped,
      this.timeIn,
      this.timeOut,
      required this.eventNameController,
      required this.totalCostPerSonController,
      required this.eventLocationAddressController,
      required this.eventDescriptionController,
      required this.eventUrlController,
      required this.descriptionCounter,
      required this.locationCount,
      required this.onChangedDescription,
      required this.onChangedLocation,
      required this.onSubmitPressed,
      required this.eventFormKey,
      required this.timeSpent,
      required this.eventActivationMode})
      : super(key: key);

  final Function onSelectDateTapped;
  final String eventDate;
  //final Function onEventHoursPlusTapped;
  //final Function onEventHoursMinusTapped;
  final int numberOfEventHours;
  final Function timeInTapped;
  final Function timeOutTapped;
  final String? timeIn;
  final String? timeOut;
  final String? timeSpent;
  final TextEditingController eventNameController;
  final TextEditingController totalCostPerSonController;
  final TextEditingController eventLocationAddressController;
  final TextEditingController eventDescriptionController;
  final TextEditingController eventUrlController;
  RxString descriptionCounter;
  RxString locationCount;
  final Function onChangedLocation;
  final Function onChangedDescription;
  final Function onSubmitPressed;
  final GlobalKey<FormState> eventFormKey;
  final AutovalidateMode eventActivationMode;

  @override
  Widget build(BuildContext context) {
    return ScrollViewRoundedCorner(
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppDimens.paddingExtraLarge,
            right: AppDimens.paddingExtraLarge,
            top: AppDimens.paddingExtraLarge),
        child: Form(
          autovalidateMode: eventActivationMode,
          key: eventFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Event Name and Text field
              Text(
                LabelKeys.eventName.tr,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              CustomTextField(
                  controller: eventNameController,
                  inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                    border: const UnderlineInputBorder(),
                    isDense: true,
                    prefixRightPadding: 0,
                  ),
                  validator: (v) {
                    return CustomTextField.validatorFunction(
                        v!, ValidationTypes.other, LabelKeys.emptyEventName.tr);
                  }),
              AppDimens.paddingExtraLarge.ph,
              // Select Date
              InkWell(
                onTap: () {
                  onSelectDateTapped();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    eventDate,
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.selectDate.tr,
                  iconPath: IconPath.icCalendar,
                ),
              ),
              AppDimens.paddingMedium.ph,
              //Timing
              PlaceholderContainerWithIcon(
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDimens.paddingMedium.ph,
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            timeInTapped();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LabelKeys.timeIn.tr,
                                style: onBackGroundTextStyleMedium(),
                              ),
                              Text(
                                timeIn ?? "HH:MM",
                                style: onBackgroundTextStyleRegular(
                                    alpha: Constants.veryLightAlfa),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: SvgPicture.asset(IconPath.arrowLong)),
                        GestureDetector(
                          onTap: () {
                            timeOutTapped();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LabelKeys.timeOut.tr,
                                style: onBackGroundTextStyleMedium(),
                              ),
                              Text(
                                timeOut ?? "HH:MM",
                                style: onBackgroundTextStyleRegular(
                                    alpha: Constants.veryLightAlfa),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    AppDimens.paddingMedium.ph,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "${LabelKeys.hoursToBeSpent.tr} $timeSpent",
                        style: onBackGroundTextStyleMedium(
                            fontSize: AppDimens.textSmall,
                          alpha: Constants.veryLightAlfa
                        ),
                      ),
                    )
                  ],
                ),
                titleName: LabelKeys.timing.tr,
                iconPath: IconPath.iconTime,
              ),
              AppDimens.paddingMedium.ph,
              //Hours to be spent
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
                    top: AppDimens.paddingXLarge,
                    bottom: AppDimens.paddingXLarge),
                child: Row(
                  children: [
                    SvgPicture.asset(IconPath.iconTime),
                    AppDimens.paddingLarge.pw,
                    Expanded(
                      child: Text(
                        LabelKeys.hoursToBeSpent.tr,
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
                              onEventHoursMinusTapped();
                            }),
                        AppDimens.paddingSmall.pw,
                        SizedBox(
                          width: AppDimens.twoDigitTextWidth,
                          child: Text(
                            numberOfEventHours.toString(),
                            style: onBackGroundTextStyleMedium(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AppDimens.paddingSmall.pw,
                        MasterButtonsBounceEffect.iconButton(
                            svgUrl: IconPath.addButtonGreyBg,
                            iconSize: AppDimens.normalIconSize,
                            onPressed: () {
                              onEventHoursPlusTapped();
                            }),
                      ],
                    )
                  ],
                ),
              ),
              AppDimens.paddingMedium.ph,*/
              // Event location or address
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
                      LabelKeys.eventLocationAddress.tr,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textLarge),
                    ),
                    CustomTextField(
                        maxLines: 5,
                        maxLength: 250,
                        controller: eventLocationAddressController,
                        onChanged: (v) {
                          locationCount.value =
                              (250 - (v.toString().length)).toString();
                        },
                        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Enter",
                            prefixRightPadding: 0,
                            isDense: true,
                            counterText: "",
                            counterStyle: onBackgroundTextStyleRegular(
                                alpha: Constants.transparentAlpha),
                            alignLabelWithHint: true,
                            hintStyle: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textLarge,
                                alpha: Constants.transparentAlpha)),
                        validator: (v) {
                          return CustomTextField.validatorFunction(
                              v!,
                              ValidationTypes.other,
                              LabelKeys.cBlankActivityEventLocation.tr);
                        })
                  ],
                ),
              ),
              AppDimens.paddingSmall.ph,
              //Word Counter
              Obx(
                () => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${locationCount.value} ${Constants.characterCountLabel}",
                    style: onBackgroundTextStyleRegular(
                        alpha: Constants.transparentAlpha),
                  ),
                ),
              ),
              AppDimens.paddingMedium.ph,
              // Cost per person
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: totalCostPerSonController,
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
                          LabelKeys.cBlankActivityEventCost.tr);
                    }),
                titleName: LabelKeys.costPerson.tr,
                iconPath: IconPath.avgCostIcon,
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
                      controller: eventDescriptionController,
                      onChanged: (v) {
                        descriptionCounter.value =
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
              // Word Counter
              Obx(
                () => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${descriptionCounter.value} ${Constants.characterCountLabel}",
                    style: onBackgroundTextStyleRegular(
                        alpha: Constants.transparentAlpha),
                  ),
                ),
              ),
              AppDimens.paddingExtraLarge.ph,
              //URL
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                  controller: eventUrlController,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return null;
                    } else {
                      return CustomTextField.validatorFunction(
                          v,
                          ValidationTypes.url,
                          LabelKeys.cBlankActivityEventUrl.tr);
                    }
                  },
                  inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
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
              // Submit Button
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
