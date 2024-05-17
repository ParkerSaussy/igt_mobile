import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/app/modules/common_widgets/placeholder_container_with_icon.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../master/general_utils/date.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import '../../common_widgets/select_date_bottomsheet.dart';
import 'create_trip_controller.dart';

class CreateTripView extends GetView<CreateTripController> {
  const CreateTripView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildAppBar(
        leadingWidth: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        isCustomTitle: true,
        actionWidget: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.paddingMedium),
            child: MasterButtonsBounceEffect.textButton(
                btnText: LabelKeys.reset.tr,
                onPressed: () {
                  controller.reset();
                },
                textStyles: onBackgroundTextStyleRegular(
                    fontSize: AppDimens.textLarge)),
          )
        ],
        customTitleWidget: CustomAppBar.backButton(),
      ),
      body: GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: SafeArea(
          bottom: false,
          child: Obx(
            () => controller.isReset.value
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      createTripLabel(),
                      AppDimens.paddingMedium.ph,
                      Expanded(
                        child: ContainerTopRoundedCorner(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Obx(
                                  () => ScrollViewRoundedCorner(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: AppDimens.paddingLarge,
                                          top: AppDimens.paddingExtraLarge,
                                          right: AppDimens.paddingLarge),
                                      child: Form(
                                        key: controller.formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //Trip Name Text Field
                                            tripNameEditField(),
                                            AppDimens.paddingLarge.ph,
                                            //Add Description Text field
                                            tripDescription(),
                                            AppDimens.paddingSmall.ph,
                                            //Description count
                                            descriptionCount(),
                                            AppDimens.paddingLarge.ph,
                                            // Add City View
                                            addCityView(),
                                            // Select City view
                                            selectedCityView(),
                                            // Selected City List
                                            selectedCityListView(),
                                            AppDimens.paddingLarge.ph,
                                            // Trip date selection View
                                            dateSelectionView(),
                                            // Trip selected date list
                                            selectedDateList(),
                                            AppDimens.paddingLarge.ph,
                                            // Itinerary Detail text field
                                            itineraryDetailTextField(),
                                            AppDimens.paddingLarge.ph,
                                            //Response dead line
                                            responseDeadLine(),
                                            controller.isSelectedReminder.value
                                                ? AppDimens.paddingLarge.ph
                                                : 0.ph,
                                            //Select Reminder Stepper
                                            selectReminderStepper(),
                                            AppDimens.paddingLarge.ph,
                                            //Select Display Image
                                            selectDisplayImageView(),
                                            AppDimens.paddingXXLarge.ph,
                                            //Add Guest Button
                                            MasterButtonsBounceEffect
                                                .gradiantButton(
                                              btnText: LabelKeys.addGuests.tr,
                                              onPressed: () {
                                                controller.validateTripData();
                                              },
                                            ),
                                            AppDimens.paddingXXLarge.ph,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget addCityView() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        Get.bottomSheet(
            enableDrag: false,
            isScrollControlled: true,
            ignoreSafeArea: false,
            selectCityView());
      },
      child: PlaceholderContainerWithIcon(
        widget: Text(
          LabelKeys.addCity.tr,
          style: onBackgroundTextStyleRegular(alpha: Constants.veryLightAlfa),
        ),
        titleName: LabelKeys.addCityVenue.tr,
        iconPath: IconPath.mapIcon,
      ),
    );
  }

  Widget selectedCityView() {
    return Obx(() => controller.isSelectedCategory.value
        ? Wrap(
            children: [
              Container(
                margin: const EdgeInsets.only(top: AppDimens.paddingSmall),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimens.paddingMedium),
                    border: Border.all(color: Get.theme.dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.dividerColor,
                        blurRadius: 1.0,
                      ),
                    ]),
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.only(top: AppDimens.paddingSmall),
                    restorationId: controller.refreshList.value,
                    itemCount: controller.lstEmptyCity.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.isSelectedCategory.value = false;
                          controller.lstEmptyCity.value =
                              controller.lstEmptyCity.toSet().toList();
                          controller.refreshList.value = getRandomString();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            controller.lstEmptyCity[index].cityName ?? "",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          )
        : const SizedBox());
  }

  Widget selectCityView() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              color: Get.theme.colorScheme.onPrimary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: AppDimens.paddingMedium),
                        child: CustomAppBar.backButton(onBack: () {
                          controller.searchCityController.clear();
                          controller.lstCitySearch.value = controller.lstCity;
                          controller.refreshList.value = getRandomString();
                          Get.back();
                        }),
                      ),
                      MasterButtonsBounceEffect.textButton(
                        onPressed: () {
                          controller.searchCityController.clear();
                          controller.lstCitySearch.value = controller.lstCity;
                          controller.refreshList.value = getRandomString();
                          if (controller.lstEmptyCity.isNotEmpty) {
                            Get.focusScope?.unfocus();
                            Get.back();
                          } else {
                            Get.back();
                          }
                        },
                        btnText: LabelKeys.save.tr,
                        textStyles: primaryTextStyleSemiBold(),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingMedium,
                        right: AppDimens.paddingMedium,
                        top: AppDimens.paddingMedium),
                    child: CustomTextField(
                      textInputAction: TextInputAction.search,
                      controller: controller.searchCityController,
                      onChanged: (value) {
                        if (controller.searchCityController.text != '') {
                          controller.startTimer();
                        } else {
                          controller.timer!.cancel();
                          controller.searchText =
                              controller.searchCityController.text;
                          controller.lstCitySearch.clear();
                          controller.getCities();
                        }
                        controller.refreshList.value = getRandomString();
                        setState(() {});
                      },
                      inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                          hintText: LabelKeys.searchCities.tr,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Obx(() => controller.lstCitySearch.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.only(
                                top: AppDimens.paddingSmall),
                            restorationId: controller.refreshList.value,
                            itemCount: controller.lstCitySearch.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (controller
                                      .lstCitySearch[index].isSelected!) {
                                    controller.lstCitySearch[index].isSelected =
                                        false;
                                    controller.lstEmptyCity.removeWhere(
                                        (element) =>
                                            element.id ==
                                            controller.lstCitySearch[index].id);
                                  } else {
                                    controller.lstCitySearch[index].isSelected =
                                        true;
                                    controller.lstEmptyCity
                                        .add(controller.lstCitySearch[index]);
                                  }
                                  controller.refreshList.value =
                                      getRandomString();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          concatCityName(
                                              controller.lstCitySearch[index]
                                                      .cityName ??
                                                  "",
                                              controller.lstCitySearch[index]
                                                      .stateAbbr ??
                                                  "",
                                              controller.lstCitySearch[index]
                                                      .countryName ??
                                                  "",
                                              controller.lstCitySearch[index]
                                                      .timeZone ??
                                                  ""),
                                          style: onBackGroundTextStyleMedium(
                                              fontSize: AppDimens.textSmall),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: AppDimens.normalIconSize,
                                      width: AppDimens.normalIconSize,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: controller
                                              .lstCitySearch[index].isSelected!
                                          ? SvgPicture.asset(
                                              IconPath.radioCheckGreen)
                                          : SvgPicture.asset(
                                              IconPath.radioUncheckWhite),
                                    )
                                  ],
                                ),
                              );
                            })
                        : const NoRecordFound()),
                  ),
                  AppDimens.paddingExtraLarge.ph,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget selectedCityListView() {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        restorationId: controller.refreshList.value,
        itemCount: controller.lstEmptyCity.length,
        itemBuilder: (context, index) {
          return Wrap(
            runSpacing: 10.0,
            spacing: 10.0,
            children: [
              Container(
                margin: const EdgeInsets.only(top: AppDimens.paddingMedium),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimens.paddingMedium),
                    border: Border.all(color: Get.theme.dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.dividerColor,
                        blurRadius: 1.0,
                      ),
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        child: Text(
                          controller.lstEmptyCity[index].cityName!.isNotEmpty
                              ? concatCityName(
                                  controller.lstEmptyCity[index].cityName ?? "",
                                  controller.lstEmptyCity[index].stateAbbr ??
                                      "",
                                  controller.lstEmptyCity[index].countryName ??
                                      "",
                                  controller.lstEmptyCity[index].timeZone ?? "")
                              : "",
                          style: onBackgroundTextStyleRegular(
                              alpha: Constants.veryLightAlfa),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: AppDimens.paddingMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        for (var city in controller.lstCitySearch) {
                          if (city.id == controller.lstEmptyCity[index].id) {
                            city.isSelected = false;
                          }
                        }
                        controller.lstEmptyCity.removeWhere((item) =>
                            item.id == controller.lstEmptyCity[index].id);

                        controller.refreshList.value = getRandomString();
                        FocusScope.of(context).unfocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        child: SvgPicture.asset(IconPath.closeRoundedIcon),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget selectReminderStepper() {
    return Obx(() => controller.isSelectedReminder.value
        ? PlaceholderContainerWithIcon(
            iconPath: IconPath.reminderIcon,
            //titleName: LabelKeys.sendReminderEvery.tr,
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LabelKeys.sendReminderEvery.tr,
                  /*"${controller.noOfReminderDays.value > 0 ? "\n" : ""}"
                  "${controller.noOfReminderDays.value > 0 ? controller.noOfReminderDays.value.toString() : ""} "
                  "${controller.noOfReminderDays.value > 0 ? controller.noOfReminderDays.value > 1 ? "Days" : "Day" : ""}",*/
                  style: onBackGroundTextStyleMedium(
                      fontSize: AppDimens.textLarge),
                ),
                controller.noOfReminderDays.value > 0
                    ? Text(
                        "${controller.noOfReminderDays.value.toString()} ${controller.noOfReminderDays.value > 1 ? "Days" : "Day"}",
                        style: onBackgroundTextStyleRegular(
                            alpha: Constants.veryLightAlfa),
                      )
                    : const SizedBox()
              ],
            ),
            endWidget: Row(
              children: [
                MasterButtonsBounceEffect.iconButton(
                    svgUrl: IconPath.decrementIcon,
                    iconSize: AppDimens.normalIconSize,
                    onPressed: () {
                      //onEventHoursMinusTapped();
                      controller.reminderDateStepper(false);
                    }),
                AppDimens.paddingSmall.pw,
                SizedBox(
                  width: AppDimens.twoDigitTextWidth,
                  child: Text(
                    controller.noOfReminderDays.value.toString(),
                    style: onBackGroundTextStyleMedium(),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppDimens.paddingSmall.pw,
                MasterButtonsBounceEffect.iconButton(
                    svgUrl: IconPath.addButtonGreyBg,
                    iconSize: AppDimens.normalIconSize,
                    onPressed: () {
                      controller.reminderDateStepper(true);
                    }),
              ],
            ),
          )
        : const SizedBox());
  }

  Widget createTripLabel() {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimens.paddingExtraLarge, top: AppDimens.paddingSmall),
      child: Text(
        LabelKeys.createEvent.tr,
        style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
      ),
    );
  }

  Widget calendarBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Obx(
          () => SelectDateBottomSheet(
            onDaySelected: (selectedDay, focusedDay) {
              printMessage("onDaySelected");
              if (!isSameDay(controller.selectedDay, selectedDay)) {
                controller.selectedDay = selectedDay;
                controller.focusedDay = focusedDay;
                controller.rangeStart = null; // Important to clean those
                controller.rangeEnd = null;
                controller.rangeSelectionMode = RangeSelectionMode.toggledOff;
              }
              setState(() {});
            },
            onRangeSelected: (start, end, focusedDay) {
              //controller.selectedDay = null;
              controller.focusedDay = focusedDay;
              controller.rangeStart = start;
              controller.rangeEnd = end;
              controller.rangeSelectionMode = RangeSelectionMode.toggledOn;
              setState(() {});
            },
            onFormatChanged: (format) {
              printMessage("formate");
              if (controller.calendarFormat != format) {
                controller.calendarFormat = format;
              }
              setState(() {});
            },
            onPageChanged: (focusedDay) {
              printMessage("onPagechange");
              controller.focusedDay = focusedDay;
              setState(() {});
            },
            calendarFormat: controller.calendarFormat,
            rangeSelectionMode: controller.rangeSelectionMode,
            focusedDay: controller.focusedDay,
            selectedDay: controller.selectedDay,
            rangeStart: controller.rangeStart,
            rangeEnd: controller.rangeEnd,
            onAddClick: () {
              if (controller.rangeStart == null) {
                Get.snackbar("", LabelKeys.cBlankTripStartDate.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);
              } else {
                /*else*/ controller.rangeEnd ??= controller.rangeStart;
                /*else*/ if (controller.arriveTime.value == "HH:MM") {
                  controller.arriveTime.value = "00:00:00";
                  /* Get.snackbar("", LabelKeys.cBlankTripArrivalTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/
                }
                /*else*/ if (controller.leaveTime.value == "HH:MM") {
                  controller.leaveTime.value = "00:00:00";
                  /*Get.snackbar("", LabelKeys.cBlankTripLeaveTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/
                }
                controller.onDateAdded();
              }
              /* */ /*else*/ /* if (controller.rangeEnd == null) {
                controller.rangeEnd = controller.rangeStart;
                */ /*Get.snackbar("", LabelKeys.cBlankTripEndDate.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/ /*
              }
              */ /*else*/ /* if (controller.arriveTime.value == "HH:MM") {
                controller.arriveTime.value == "00:00";
                */ /* Get.snackbar("", LabelKeys.cBlankTripArrivalTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/ /*
              }
              */ /*else*/ /* if (controller.leaveTime.value == "HH:MM") {
                controller.leaveTime.value == "00:00";
                */ /*Get.snackbar("", LabelKeys.cBlankTripLeaveTime.tr,
                    backgroundColor: Get.theme.colorScheme.error,
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Get.theme.colorScheme.onError);*/ /*
              }*/ /*else {
                controller.onDateAdded();
              }*/
              //Get.back();
            },
            onCancelClick: () {
              printMessage("click");
              controller.onDateCancel();
            },
            onCloseClick: () {
              controller.onDateCancel();
            },
            onArriveTimeClick: () async {
              TimeOfDay timeOfDay;
              if (controller.arriveTime.value != "HH:MM") {
                DateTime parsedDateTime =
                    DateFormat("HH:mm").parse(controller.arriveTime.value);
                timeOfDay = TimeOfDay.fromDateTime(parsedDateTime);
              } else {
                timeOfDay = TimeOfDay.now();
              }
              final TimeOfDay? pickedTime = await timePicker(timeOfDay);
              final now = DateTime.now();
              DateTime parsedTime = DateTime(now.year, now.month, now.day,
                  pickedTime!.hour, pickedTime.minute);
              String formattedTime = DateFormat("HH:mm:ss").format(parsedTime);
              controller.arriveTime.value = formattedTime;
            },
            onLeaveAfterClick: () async {
              TimeOfDay timeOfDay;
              if (controller.leaveTime.value != "HH:MM") {
                DateTime parsedDateTime =
                    DateFormat("HH:mm").parse(controller.leaveTime.value);
                timeOfDay = TimeOfDay.fromDateTime(parsedDateTime);
              } else {
                timeOfDay = TimeOfDay.now();
              }
              final TimeOfDay? pickedTime = await timePicker(timeOfDay);
              final now = DateTime.now();
              DateTime parsedTime = DateTime(now.year, now.month, now.day,
                  pickedTime!.hour, pickedTime.minute);
              String formattedTime = DateFormat("HH:mm:ss").format(parsedTime);
              controller.leaveTime.value = formattedTime;
            },
            arriveTime: controller.arriveTime.value,
            leaveTime: controller.leaveTime.value,
            commentTextEditingController:
                controller.commentTextEditingController,
          ),
        );
      },
    );
  }

  Widget tripNameEditField() {
    return CustomTextField(
      controller: controller.tripNameController,
      textInputAction: TextInputAction.next,
      keyBoardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return CustomTextField.validatorFunction(
            value!, ValidationTypes.other, LabelKeys.cBlankEventTripName.tr);
      },
      inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
          contentPadding: const EdgeInsets.only(
              left: AppDimens.paddingSmall, top: AppDimens.paddingSmall),
          border: const UnderlineInputBorder(),
          labelText: LabelKeys.eventTripName.tr,
          isDense: false,
          hintText: LabelKeys.addTripDetails.tr,
          labelStyle: onBackGroundTextStyleMedium()),
    );
  }

  Widget tripDescription() {
    return PlaceholderContainerWithIcon(
      widget: CustomTextField(
        // textInputAction: TextInputAction.next,
        keyBoardType: TextInputType.multiline,
        maxLength: 250,
        controller: controller.tripDetailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return CustomTextField.validatorFunction(value!,
              ValidationTypes.other, LabelKeys.cBlankAddExpenseDescription.tr);
        },
        maxLines: 5,
        onChanged: (v) {
          controller.descCount.value = (250 - (v.toString().length)).toString();
        },
        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
            contentPadding: const EdgeInsets.only(
                left: AppDimens.paddingSmall,
                top: AppDimens.paddingSmall,
                bottom: AppDimens.paddingMedium),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            alignLabelWithHint: true,
            /*labelStyle:
                                                        onBackGroundTextStyleMedium(),*/
            //labelText: "Add Description",
            prefixRightPadding: 0,
            isDense: true,
            hintText: LabelKeys.addTripDetails.tr,
            counterText: ""),
      ),
      titleName: LabelKeys.addDescription.tr,
      // iconPath: IconPath.mapIcon,
    );
  }

  Widget descriptionCount() {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        "${controller.descCount} ${Constants.characterCountLabel}",
        style: onBackgroundTextStyleRegular(alpha: Constants.veryLightAlfa),
      ),
    );
  }

  Widget dateSelectionView() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          isScrollControlled: true,
          calendarBottomSheet(),
        );
        //Get.focusScope?.unfocus();
      },
      child: PlaceholderContainerWithIcon(
        widget: Text(
          LabelKeys.addDate.tr,
          style: onBackgroundTextStyleRegular(alpha: Constants.veryLightAlfa),
        ),
        titleName: LabelKeys.selectDates.tr,
        iconPath: IconPath.icCalendar,
      ),
    );
  }

  Widget selectedDateList() {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        restorationId: controller.refreshListDate.value,
        itemCount: controller.lstEmptyDate.length,
        itemBuilder: (context, index) {
          return Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.paddingSmall),
                margin: const EdgeInsets.only(top: AppDimens.paddingMedium),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppDimens.paddingMedium),
                    border: Border.all(color: Get.theme.dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Get.theme.dividerColor,
                        blurRadius: 1.0,
                      ),
                    ]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        controller.lstEmptyDate[index].displayName.isNotEmpty
                            ? controller.lstEmptyDate[index].displayName
                            : "",
                        style: onBackgroundTextStyleRegular(
                            alpha: Constants.veryLightAlfa),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppDimens.paddingMedium.pw,
                    GestureDetector(
                      onTap: () {
                        controller.lstEmptyDate.removeWhere((item) =>
                            item.displayName ==
                            controller.lstEmptyDate[index].displayName);
                        controller.refreshListDate.value = getRandomString();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        child: SvgPicture.asset(IconPath.closeRoundedIcon),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget itineraryDetailTextField() {
    return PlaceholderContainerWithIcon(
      widget: CustomTextField(
        controller: controller.tripItineraryController,
        keyBoardType: TextInputType.multiline,
        maxLength: 250,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return null;
        },
        maxLines: 5,
        inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
            prefixRightPadding: 0,
            contentPadding: const EdgeInsets.only(
                left: AppDimens.paddingSmall, top: AppDimens.paddingSmall),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            alignLabelWithHint: true,
            isDense: true,
            hintText: LabelKeys.optional.tr,
            counterText: ""),
      ),
      titleName: LabelKeys.itineraryDetails.tr,
    );
  }

  Widget responseDeadLine() {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await datePicker(firstDate: DateTime.now());
          pickedDate = pickedDate
              ?.add(const Duration(hours: 23, minutes: 59, seconds: 59));
          printMessage("Deadline ${pickedDate!.timeZoneName}");
          if (pickedDate != null) {
            final String strPickedDate =
                DateFormat("yyyy/MM/dd HH:mm:ss").format(pickedDate);
            controller.isSelectedReminder.value = true;
            controller.maxReminderDays.value =
                Date.shared().datesDifferenceInDay(DateTime.now(), pickedDate);
            if (controller.noOfReminderDays.value >
                controller.maxReminderDays.value) {
              controller.noOfReminderDays.value = 0;
            }
            controller.responseSelectedDeadline.value = strPickedDate;
            controller.responseSelectedDeadlineUTC =
                DateFormat("yyyy/MM/dd HH:mm:ss").format(pickedDate.toUtc());
            printMessage(
                "Deadline ${strPickedDate} ${controller.responseSelectedDeadlineUTC}");
          }
          Get.focusScope?.unfocus();
        },
        child: PlaceholderContainerWithIcon(
          widget: Text(
            /*controller.responseSelectedDeadline.value == LabelKeys.selectDate.tr
                ? controller.responseSelectedDeadline.value
                : controller.formatDateToMMDDYYYY(
                    controller.responseSelectedDeadline.value),*/
            controller.responseSelectedDeadline.value == LabelKeys.selectDate.tr
                ? controller.responseSelectedDeadline.value
                : '${controller.formatDateToMMDDYYYY(controller.responseSelectedDeadline.value)}, ${Date.shared().getDayName(controller.formatDateToMMDDYYYY(controller.responseSelectedDeadline.value), 'MM/dd/yyyy')}',
            style: onBackgroundTextStyleRegular(alpha: Constants.veryLightAlfa),
          ),
          titleName: LabelKeys.responseDeadline.tr,
          iconPath: IconPath.icCalendar,
          endWidget: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset(IconPath.downArrow),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectDisplayImageView() {
    return Focus(
      focusNode: controller.selectDisplayImageNode,
      child: GestureDetector(
        onTap: () async {
          final result =
              await Get.toNamed(Routes.SELECT_TRIP_IMAGE, arguments: [
            controller.uploadedImageName.value.isNotEmpty
                ? controller.uploadedImageName.value
                : "",
            0
          ]);
          if (result != null) {
            controller.uploadedImageName.value = result;
          }
          Get.focusScope?.unfocus();
        },
        child: PlaceholderContainerWithIcon(
          widget: Text(
            controller.uploadedImageName.value.isNotEmpty
                ? getFileNameFromURL(controller.uploadedImageName.value)
                : "",
            style: onBackgroundTextStyleRegular(alpha: Constants.veryLightAlfa),
          ),
          titleName: LabelKeys.selectDisplayImage.tr,
          iconPath: IconPath.displayImageIcon,
          endWidget: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SvgPicture.asset(IconPath.forwardArrow),
            ),
          ),
        ),
      ),
    );
  }
}
