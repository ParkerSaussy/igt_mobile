import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:table_calendar/table_calendar.dart';

import 'container_top_rounded_corner.dart';

class SelectDateBottomSheet extends StatelessWidget {
  SelectDateBottomSheet({
    Key? key,
    required this.onDaySelected,
    required this.onRangeSelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.calendarFormat,
    required this.rangeSelectionMode,
    required this.focusedDay,
    required this.selectedDay,
    required this.rangeStart,
    required this.rangeEnd,
    required this.onAddClick,
    required this.onCancelClick,
    required this.onArriveTimeClick,
    required this.onLeaveAfterClick,
    this.arriveTime,
    this.leaveTime,
    required this.commentTextEditingController,
    this.onCloseClick,
  }) : super(key: key);

  //DateTime focusedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by long pressing a date
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  final Function onDaySelected;
  final Function onRangeSelected;
  final Function onFormatChanged;
  final Function onPageChanged;
  final Function onAddClick;
  final Function? onCloseClick;
  final Function onCancelClick;
  final Function onArriveTimeClick;
  final Function onLeaveAfterClick;
  final TextEditingController commentTextEditingController;
  String? arriveTime;
  String? leaveTime;

  @override
  Widget build(BuildContext context) {
    return ContainerTopRoundedCorner(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 2.5,
                  width: 35,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: AppDimens.paddingMedium,
                    left: AppDimens.paddingMedium,
                    right: AppDimens.paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LabelKeys.selectDate.tr,
                      style: onBackGroundTextStyleMedium(),
                    ),
                    GestureDetector(
                        onTap: () {
                          onCloseClick != null ? onCloseClick!() : Get.back();
                        },
                        child: SvgPicture.asset(IconPath.closeRoundedIcon))
                  ],
                ),
              ),
              const SizedBox(
                height: AppDimens.paddingLarge,
              ),
              Container(
                padding: const EdgeInsets.only(top: AppDimens.paddingMedium),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.paddingMedium))),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime(DateTime.now().year + 5),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  rangeStartDay: rangeStart,
                  rangeEndDay: rangeEnd,
                  calendarFormat: calendarFormat,
                  rangeSelectionMode: rangeSelectionMode,
                  headerVisible: true,
                  //shouldFillViewport: true,
                  //pageAnimationEnabled: false,
                  sixWeekMonthsEnforced: true,
                  availableCalendarFormats: {
                    CalendarFormat.month: LabelKeys.month.tr,
                  },
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle:
                          const TextStyle().copyWith(color: Colors.grey[400]),
                      weekdayStyle:
                          const TextStyle().copyWith(color: Colors.grey[400]),
                      decoration:
                          const BoxDecoration(shape: BoxShape.rectangle)),
                  calendarStyle: CalendarStyle(
                      outsideDaysVisible: true,
                      isTodayHighlighted: true,
                      todayTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      rangeHighlightColor: Get.theme.colorScheme.primary
                          .withAlpha(Constants.transparentAlpha),
                      rangeStartDecoration: BoxDecoration(
                          color: Get.theme.colorScheme.primary
                              .withAlpha(Constants.darkAlfa),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          shape: BoxShape.rectangle),
                      todayDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      defaultDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      disabledDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      holidayDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      markerDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      outsideDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      rowDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      selectedDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      weekendDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      withinRangeDecoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                      rangeStartTextStyle:
                          const TextStyle(fontSize: 14, color: Colors.black),
                      rangeEndDecoration: BoxDecoration(
                          color: Get.theme.colorScheme.primary
                              .withAlpha(Constants.darkAlfa),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))
                          // borderRadius: BorderRadius.circular(12),
                          ),
                      rangeEndTextStyle:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                  onDaySelected: (selectedDay, focusedDay) {
                    onDaySelected(selectedDay, focusedDay);
                  },
                  onRangeSelected: (start, end, focusedDay) {
                    onRangeSelected(start, end, focusedDay);
                  },
                  onFormatChanged: (format) {
                    onFormatChanged(format);
                  },
                  onPageChanged: (focusedDay) {
                    // onPageChanged(focusedDay);
                  },
                ),
              ),
              const SizedBox(
                height: AppDimens.paddingLarge,
              ),
              Container(
                height: 100,
                width: Get.width,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.paddingMedium))),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.paddingMedium),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(IconPath.iconTime),
                      const SizedBox(
                        width: AppDimens.paddingMedium,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              LabelKeys.selectEventStartEndTime.tr,
                              style: onBackGroundTextStyleMedium(),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    onArriveTimeClick();
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        LabelKeys.arriveBy.tr,
                                        style: onBackGroundTextStyleMedium(),
                                      ),
                                      Text(
                                        arriveTime ?? "HH:MM",
                                        style: onBackgroundTextStyleRegular(
                                            alpha: Constants.veryLightAlfa),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child:
                                        SvgPicture.asset(IconPath.arrowLong)),
                                GestureDetector(
                                  onTap: () {
                                    onLeaveAfterClick();
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        LabelKeys.leaveAfter.tr,
                                        style: onBackGroundTextStyleMedium(),
                                      ),
                                      Text(
                                        leaveTime ?? "HH:MM",
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
              ),
              const SizedBox(
                height: AppDimens.paddingLarge,
              ),
              Container(
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
                child: CustomTextField(
                  controller: commentTextEditingController,
                  keyBoardType: TextInputType.multiline,
                  maxLength: 250,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return null;
                  },
                  maxLines: 5,
                  inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                      contentPadding:
                          const EdgeInsets.all(AppDimens.paddingSmall),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      alignLabelWithHint: true,
                      labelText: LabelKeys.comments.tr,
                      isDense: true,
                      hintText: LabelKeys.optional.tr,
                      counterText: ""),
                ),
              ),
              AppDimens.paddingXLarge.ph,
              Row(
                children: [
                  Flexible(
                    child: MasterButtonsBounceEffect.gradiantButton(
                        btnText: LabelKeys.add.tr,
                        onPressed: () {
                          onAddClick();
                        }),
                  ),
                  AppDimens.paddingMedium.pw,
                  Flexible(
                    child: MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.cancel.tr,
                      textStyles: onPrimaryTextStyleMedium(),
                      gradiantColors: [
                        Get.theme.disabledColor,
                        Get.theme.disabledColor,
                      ],
                      onPressed: () {
                        onCancelClick();
                      },
                    ),
                  ),
                ],
              ),
              AppDimens.paddingLarge.ph,
            ],
          ),
        ),
      ),
    );
  }
}
