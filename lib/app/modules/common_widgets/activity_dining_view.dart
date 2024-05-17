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

class ActivityDiningView extends StatelessWidget {
  const ActivityDiningView({
    Key? key,
    required this.onSelectDateTap,
    required this.selectDate,
    required this.onSelectTimeTap,
    required this.onHoursMinusTapped,
    required this.onHoursPlusTapped,
    required this.numberOfHours,
    required this.diningNameController,
    required this.diningLocationController,
    required this.costPersonController,
    required this.addDescriptionController,
    this.selectTime,
    required this.onSubmitPressed,
    required this.diningFormKey,
    required this.diningActivationMode,
    required this.descriptionCounter,
    required this.onChangedDescription,
  }) : super(key: key);

  final Function onSelectDateTap;
  final String selectDate;
  final Function onSelectTimeTap;
  final Function onHoursMinusTapped;
  final Function onHoursPlusTapped;
  final String? selectTime;
  final int numberOfHours;
  final TextEditingController diningNameController;
  final TextEditingController diningLocationController;
  final TextEditingController costPersonController;
  final TextEditingController addDescriptionController;
  final Function onSubmitPressed;
  final GlobalKey<FormState> diningFormKey;
  final AutovalidateMode diningActivationMode;
  final RxString descriptionCounter;
  final Function onChangedDescription;

  @override
  Widget build(BuildContext context) {
    return ScrollViewRoundedCorner(
      child: Padding(
        padding: const EdgeInsets.only(
            left: AppDimens.paddingExtraLarge,
            right: AppDimens.paddingExtraLarge,
            top: AppDimens.paddingExtraLarge),
        child: Form(
          autovalidateMode: diningActivationMode,
          key: diningFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Dining text and text field
              Text(
                LabelKeys.diningName.tr,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              CustomTextField(
                  controller: diningNameController,
                  inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                    border: const UnderlineInputBorder(),
                    isDense: true,
                    prefixRightPadding: 0,
                    /*labelText: LabelKeys.enterDiningName.tr,
                      labelStyle: onBackgroundTextStyleRegular(
                          alpha: Constants.lightAlfa),*/
                  ),
                  validator: (v) {
                    return CustomTextField.validatorFunction(
                        v!,
                        ValidationTypes.other,
                        LabelKeys.cBlankActivityDiningName.tr);
                  }),
              AppDimens.paddingMedium.ph,
              // Arrival Label
              Text(
                LabelKeys.arrival.tr,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              AppDimens.paddingMedium.ph,

              // Dinning Location
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: diningLocationController,
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        isDense: true,
                        prefixRightPadding: 0,
                        hintText: LabelKeys.diningHotelName.tr,
                        hintStyle: onBackgroundTextStyleRegular(
                            alpha: Constants.transparentAlpha)),
                    validator: (v) {
                      return CustomTextField.validatorFunction(
                          v!,
                          ValidationTypes.other,
                          LabelKeys.cBlankActivityDiningLocation.tr);
                    }),
                titleName: LabelKeys.diningLocation.tr,
                iconPath: IconPath.iconDiningLocation,
              ),
              AppDimens.paddingMedium.ph,
              //Select Date
              InkWell(
                onTap: () {
                  onSelectDateTap();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    selectDate,
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.selectDate.tr,
                  iconPath: IconPath.icCalendar,
                ),
              ),
              AppDimens.paddingMedium.ph,
              //Select Time
              InkWell(
                onTap: () {
                  onSelectTimeTap();
                },
                child: PlaceholderContainerWithIcon(
                  widget: Text(
                    selectTime ?? "HH:MM",
                    style: onBackgroundTextStyleRegular(
                        fontSize: AppDimens.textLarge,
                        alpha: Constants.transparentAlpha),
                  ),
                  titleName: LabelKeys.selectTime.tr,
                  iconPath: IconPath.iconTime,
                ),
              ),
              AppDimens.paddingMedium.ph,
              //Cost Per person
              PlaceholderContainerWithIcon(
                widget: CustomTextField(
                    controller: costPersonController,
                    keyBoardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,2})')),
                    ],
                    inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
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
                          LabelKeys.cBlankActivityDiningCost.tr);
                    }),
                titleName: LabelKeys.costPerson.tr,
                iconPath: IconPath.avgCostIcon,
              ),
              AppDimens.paddingMedium.ph,
              // Hours to be spent
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
                              onHoursMinusTapped();
                            }),
                        AppDimens.paddingSmall.pw,
                        SizedBox(
                          width: AppDimens.twoDigitTextWidth,
                          child: Text(
                            numberOfHours.toString(),
                            style: onBackGroundTextStyleMedium(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AppDimens.paddingSmall.pw,
                        MasterButtonsBounceEffect.iconButton(
                            svgUrl: IconPath.addButtonGreyBg,
                            iconSize: AppDimens.normalIconSize,
                            onPressed: () {
                              onHoursPlusTapped();
                            }),
                      ],
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
                      controller: addDescriptionController,
                      onChanged: (v) {
                        descriptionCounter.value =
                            (250 - (v.toString().length)).toString();
                      },
                      inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: LabelKeys.addTripDetails.tr,
                          isDense: true,
                          prefixRightPadding: 0,
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
