import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/app/modules/common_widgets/activity_flight_view.dart';
import 'package:lesgo/app/modules/common_widgets/activity_hotel_view.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/generic_class/rectangle_shape.dart';

import '../../common_widgets/activity_dining_view.dart';
import '../../common_widgets/activity_event_view.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import 'add_activities_screen_controller.dart';

class AddActivitiesScreenView extends GetView<AddActivitiesScreenController> {
  const AddActivitiesScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
            isCustomTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            customTitleWidget: CustomAppBar.backButton(onBack: () {
              // ASK WHY THIS IS USED??
              Get.back(result: controller.selectedActivityList);
            }),
            actionWidget: [
              Padding(
                padding: const EdgeInsets.only(right: AppDimens.paddingMedium),
                child: MasterButtonsBounceEffect.textButton(
                  onPressed: () {
                    controller.reset();
                  },
                  btnText: LabelKeys.reset.tr,
                  textStyles: onBackgroundTextStyleSemiBold(),
                ),
              )
            ]),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LabelKeys.activities.tr,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textExtraLarge),
                    ),
                    Text(
                      LabelKeys.selectActivityFillDetails.tr,
                      style: onBackGroundTextStyleMedium(),
                    ),
                    AppDimens.paddingSmall.ph,
                    Obx(() => Row(
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedActivity.value = 0;
                                },
                                child: RectangleShapeWithIcon(
                                  centerWidget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.cafeIcon,
                                        colorFilter: ColorFilter.mode(
                                            controller.selectedActivity.value ==
                                                    0
                                                ? Get
                                                    .theme.colorScheme.onPrimary
                                                : Get.theme.colorScheme.primary,
                                            BlendMode.srcIn),
                                      ),
                                      Text(
                                        LabelKeys.hotel.tr,
                                        style: controller
                                                    .selectedActivity.value ==
                                                0
                                            ? onPrimaryTextStyleMedium(
                                                fontSize: AppDimens.textSmall)
                                            : onBackGroundTextStyleMedium(
                                                fontSize: AppDimens.textSmall,
                                                alpha: Constants.veryLightAlfa),
                                      )
                                    ],
                                  ),
                                  shapeColor:
                                      controller.selectedActivity.value == 0
                                          ? Get.theme.colorScheme.primary
                                          : Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            AppDimens.paddingSmall.pw,
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedActivity.value = 1;
                                },
                                child: RectangleShapeWithIcon(
                                  centerWidget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.planeIcon,
                                        colorFilter: ColorFilter.mode(
                                            controller.selectedActivity.value ==
                                                    1
                                                ? Get
                                                    .theme.colorScheme.onPrimary
                                                : Get.theme.colorScheme.primary,
                                            BlendMode.srcIn),
                                      ),
                                      Text(
                                        LabelKeys.flight.tr,
                                        style: controller
                                                    .selectedActivity.value ==
                                                1
                                            ? onPrimaryTextStyleMedium(
                                                fontSize: AppDimens.textSmall)
                                            : onBackGroundTextStyleMedium(
                                                fontSize: AppDimens.textSmall,
                                                alpha: Constants.veryLightAlfa),
                                      )
                                    ],
                                  ),
                                  shapeColor:
                                      controller.selectedActivity.value == 1
                                          ? Get.theme.colorScheme.primary
                                          : Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            AppDimens.paddingSmall.pw,
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedActivity.value = 2;
                                },
                                child: RectangleShapeWithIcon(
                                  centerWidget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.dineIcon,
                                        colorFilter: ColorFilter.mode(
                                            controller.selectedActivity.value ==
                                                    2
                                                ? Get
                                                    .theme.colorScheme.onPrimary
                                                : Get.theme.colorScheme.primary,
                                            BlendMode.srcIn),
                                      ),
                                      Text(
                                        LabelKeys.dining.tr,
                                        style: controller
                                                    .selectedActivity.value ==
                                                2
                                            ? onPrimaryTextStyleMedium(
                                                fontSize: AppDimens.textSmall)
                                            : onBackGroundTextStyleMedium(
                                                fontSize: AppDimens.textSmall,
                                                alpha: Constants.veryLightAlfa),
                                      )
                                    ],
                                  ),
                                  shapeColor:
                                      controller.selectedActivity.value == 2
                                          ? Get.theme.colorScheme.primary
                                          : Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            AppDimens.paddingSmall.pw,
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  controller.selectedActivity.value = 3;
                                },
                                child: RectangleShapeWithIcon(
                                  centerWidget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.eventIcon,
                                        colorFilter: ColorFilter.mode(
                                            controller.selectedActivity.value ==
                                                    3
                                                ? Get
                                                    .theme.colorScheme.onPrimary
                                                : Get.theme.colorScheme.primary,
                                            BlendMode.srcIn),
                                      ),
                                      Text(
                                        LabelKeys.activityEvent.tr,
                                        style: controller
                                                    .selectedActivity.value ==
                                                3
                                            ? onPrimaryTextStyleMedium(
                                                fontSize: AppDimens.textSmall)
                                            : onBackGroundTextStyleMedium(
                                                fontSize: AppDimens.textSmall,
                                                alpha: Constants.veryLightAlfa),
                                      )
                                    ],
                                  ),
                                  shapeColor:
                                      controller.selectedActivity.value == 3
                                          ? Get.theme.colorScheme.primary
                                          : Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              AppDimens.padding3XLarge.ph,
              Expanded(
                child: ContainerTopRoundedCorner(
                  child: Obx(() => controller.selectedActivity.value == 0
                      ? ActivityHotelView(
                          hotelFormKey: controller.hotelFormKey,
                          pickedDate: controller.pickedDate.value,
                          numberOfNights: controller.numberOfNights.value,
                          capacityPerRoom: controller.capacityPerRoom.value,
                          onDateTapped: () async {
                            Get.focusScope?.unfocus();
                            final DateTime? pickedDate =
                                await datePicker(firstDate: DateTime.now());
                            if (pickedDate != null) {
                              final String strPickedDate =
                                  DateFormat("MMM dd, yyyy").format(pickedDate);
                              controller.pickedDate.value = strPickedDate;
                            }
                          },
                          onNightMinusTapped: () {
                            Get.focusScope?.unfocus();
                            if (controller.numberOfNights.value != 0) {
                              controller.numberOfNights--;
                            }
                          },
                          onNightPlusTapped: () {
                            Get.focusScope?.unfocus();
                            controller.numberOfNights++;
                          },
                          onCapacityPlusTapped: () {
                            Get.focusScope?.unfocus();
                            controller.capacityPerRoom++;
                          },
                          onCapacityMinusTapped: () {
                            Get.focusScope?.unfocus();
                            if (controller.capacityPerRoom.value != 0) {
                              controller.capacityPerRoom--;
                            }
                          },
                          hotelCheckInTapped: () async {
                            Get.focusScope?.unfocus();
                            TimeOfDay timeOfDay;
                            /*if (controller.hotelCheckInTime.value != "HH:MM") {
                              timeOfDay = TimeOfDay.fromDateTime(
                                  DateFormat("HH:mm a").parse(
                                      controller.hotelCheckInTime.value));
                            } else {
                              timeOfDay = TimeOfDay.now();
                            }*/
                            final TimeOfDay? pickedTime =
                                await timePicker(controller.hotelCheckInTimeTD);
                            if (pickedTime != null) {
                              var now = DateTime.now();
                              var dateTime = DateTime(now.year, now.month,
                                  now.day, pickedTime.hour, pickedTime.minute);
                              var timeOfDay =
                                  DateFormat('hh:mm a').format(dateTime);
                              controller.hotelCheckInTime.value = timeOfDay;
                              controller.hotelCheckInTimeTD = pickedTime;
                              printMessage(controller.hotelCheckInTime.value);
                            }
                          },
                          hotelCheckOutTapped: () async {
                            Get.focusScope?.unfocus();
                            // TimeOfDay timeOfDay;
                            /*if (controller.hotelCheckOutTime.value != "HH:MM") {
                              timeOfDay = TimeOfDay.fromDateTime(
                                  DateFormat("HH:mm a").parse(
                                      controller.hotelCheckOutTime.value));
                            } else {
                              timeOfDay = TimeOfDay.now();
                            }*/
                            final TimeOfDay? pickedTime = await timePicker(
                                controller.hotelCheckOutTimeTD);
                            if (pickedTime != null) {
                              var now = DateTime.now();
                              var dateTime = DateTime(now.year, now.month,
                                  now.day, pickedTime.hour, pickedTime.minute);
                              var timeOfDay =
                                  DateFormat('hh:mm a').format(dateTime);
                              controller.hotelCheckOutTime.value = timeOfDay;
                              controller.hotelCheckOutTimeTD = pickedTime;
                            }
                          },
                          hotelCheckInTime: controller.hotelCheckInTime.value,
                          hotelCheckOutTime: controller.hotelCheckOutTime.value,
                          hotelNameController: controller.hotelNameController,
                          avgNightlyController: controller.avgNightlyController,
                          totalCostController: controller.totalCostController,
                          addressController: controller.addressController,
                          roomNoController: controller.roomNoController,
                          descriptionController:
                              controller.descriptionController,
                          urlController: controller.urlController,
                          descCount: controller.counter,
                          onChanged: (v) {
                            controller.counter.value =
                                (250 - (v.toString().length)).toString();
                          },
                          hotelActivationMode:
                              controller.hotelActivationMode.value,
                          onSubmitPressed: () {
                            hideKeyboard();
                            controller.onDataSubmitted();
                          },
                        )
                      : controller.selectedActivity.value == 1
                          ? ActivityFlightView(
                              flightActivationMode:
                                  controller.flightActivationMode.value,
                              flightFormKey: controller.flightFormKey,
                              onSubmitPressed: () {
                                hideKeyboard();
                                controller.onDataSubmitted();
                              },
                              onArrivalDateTap: () async {
                                Get.focusScope?.unfocus();
                                final DateTime? pickedDate =
                                    await datePicker(firstDate: DateTime.now());
                                if (pickedDate != null) {
                                  final String strPickedDate =
                                      DateFormat("MMM dd, yyyy")
                                          .format(pickedDate);
                                  controller.onArrivalDate.value =
                                      strPickedDate;
                                }
                              },
                              arrivalDate: controller.onArrivalDate.value,
                              onArrivalTimeTap: () async {
                                Get.focusScope?.unfocus();
                                TimeOfDay timeOfDay;
                                if (controller.onArrivalTime.value != "HH:MM") {
                                  timeOfDay = TimeOfDay.fromDateTime(
                                      DateFormat("HH:mm").parse(
                                          controller.onArrivalTime.value));
                                } else {
                                  timeOfDay = TimeOfDay.now();
                                }
                                final TimeOfDay? pickedTime =
                                    await timePicker(timeOfDay);
                                if (pickedTime != null) {
                                  var now = DateTime.now();
                                  var dateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      pickedTime.hour,
                                      pickedTime.minute);
                                  var timeOfDay =
                                      DateFormat('hh:mm a').format(dateTime);
                                  controller.onArrivalTime.value = timeOfDay;
                                }
                              },
                              arrivalTime: controller.onArrivalTime.value,
                              onDepartureDateTap: () async {
                                Get.focusScope?.unfocus();
                                final DateTime? pickedDate =
                                    await datePicker(firstDate: DateTime.now());
                                if (pickedDate != null) {
                                  final String strPickedDate =
                                      DateFormat("MMM dd, yyyy")
                                          .format(pickedDate);
                                  controller.departureDate.value =
                                      strPickedDate;
                                }
                              },
                              departureDate: controller.departureDate.value,
                              onDepartureTimeTap: () async {
                                Get.focusScope?.unfocus();
                                TimeOfDay timeOfDay;
                                if (controller.departureTime.value != "HH:MM") {
                                  timeOfDay = TimeOfDay.fromDateTime(
                                      DateFormat("HH:mm").parse(
                                          controller.departureTime.value));
                                } else {
                                  timeOfDay = TimeOfDay.now();
                                }
                                final TimeOfDay? pickedTime =
                                    await timePicker(timeOfDay);
                                if (pickedTime != null) {
                                  var now = DateTime.now();
                                  var dateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      pickedTime.hour,
                                      pickedTime.minute);
                                  var timeOfDay =
                                      DateFormat('hh:mm a').format(dateTime);
                                  controller.departureTime.value = timeOfDay;
                                }
                              },
                              departureTime: controller.departureTime.value,
                              flightTextController:
                                  controller.flightTextController,
                              flightNumberArrivalTextController:
                                  controller.flightNumberArrivalTextController,
                              flightNumberDepartureTextController: controller
                                  .flightNumberDepartureTextController,
                              tripDetailTextController:
                                  controller.tripDetailTextController,
                              descFlightCount: controller.descFlightCount,
                              onChangedFlight: (v) {
                                controller.descFlightCount.value =
                                    (250 - (v.toString().length)).toString();
                              },
                            )
                          : controller.selectedActivity.value == 2
                              ? ActivityDiningView(
                                  diningActivationMode:
                                      controller.diningActivationMode.value,
                                  diningFormKey: controller.diningFormKey,
                                  onSubmitPressed: () {
                                    hideKeyboard();
                                    controller.onDataSubmitted();
                                  },
                                  onSelectDateTap: () async {
                                    Get.focusScope?.unfocus();
                                    final DateTime? pickedDate =
                                        await datePicker(
                                            firstDate: DateTime.now());
                                    if (pickedDate != null) {
                                      final String strPickedDate =
                                          DateFormat("MMM dd, yyyy")
                                              .format(pickedDate);
                                      controller.onSelectDate.value =
                                          strPickedDate;
                                    }
                                  },
                                  selectDate: controller.onSelectDate.value,
                                  onSelectTimeTap: () async {
                                    Get.focusScope?.unfocus();
                                    TimeOfDay timeOfDay;
                                    if (controller.onSelectTime.value !=
                                        "HH:MM") {
                                      timeOfDay = TimeOfDay.fromDateTime(
                                          DateFormat("HH:mm").parse(
                                              controller.onSelectTime.value));
                                    } else {
                                      timeOfDay = TimeOfDay.now();
                                    }
                                    final TimeOfDay? pickedTime =
                                        await timePicker(timeOfDay);
                                    if (pickedTime != null) {
                                      var now = DateTime.now();
                                      var dateTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTime.hour,
                                          pickedTime.minute);
                                      var timeOfDay = DateFormat('hh:mm a')
                                          .format(dateTime);
                                      controller.onSelectTime.value = timeOfDay;
                                    }
                                  },
                                  selectTime: controller.onSelectTime.value,
                                  onHoursMinusTapped: () {
                                    Get.focusScope?.unfocus();
                                    if (controller.numberOfHours.value != 0) {
                                      controller.numberOfHours--;
                                    }
                                  },
                                  onHoursPlusTapped: () {
                                    Get.focusScope?.unfocus();
                                    controller.numberOfHours++;
                                  },
                                  numberOfHours: controller.numberOfHours.value,
                                  diningNameController:
                                      controller.diningNameController,
                                  diningLocationController:
                                      controller.diningLocationController,
                                  costPersonController:
                                      controller.costPersonController,
                                  addDescriptionController:
                                      controller.addDescriptionController,
                                  onChangedDescription: (v) {
                                    controller.descriptionCounterDining.value =
                                        (250 - (v.toString().length))
                                            .toString();
                                  },
                                  descriptionCounter:
                                      controller.descriptionCounterDining,
                                )
                              : controller.selectedActivity.value == 3
                                  ? ActivityEventView(
                                      eventActivationMode:
                                          controller.eventActivationMode.value,
                                      eventFormKey: controller.eventFormKey,
                                      onSubmitPressed: () {
                                        hideKeyboard();
                                        controller.onDataSubmitted();
                                      },
                                      eventDate: controller.onEventDate.value,
                                      numberOfEventHours:
                                          controller.numberOfEventHours.value,
                                      onSelectDateTapped: () async {
                                        Get.focusScope?.unfocus();
                                        final DateTime? pickedDate =
                                            await datePicker(
                                                firstDate: DateTime.now());
                                        if (pickedDate != null) {
                                          final String strPickedDate =
                                              DateFormat("MMM dd, yyyy")
                                                  .format(pickedDate);
                                          controller.onEventDate.value =
                                              strPickedDate;
                                        }
                                      },
                                      /*onEventHoursMinusTapped: () {
                                        Get.focusScope?.unfocus();
                                        if (controller
                                                .numberOfEventHours.value !=
                                            0) {
                                          controller.numberOfEventHours--;
                                        }
                                      },*/
                                      /*onEventHoursPlusTapped: () {
                                        Get.focusScope?.unfocus();
                                        controller.numberOfEventHours++;
                                      },*/
                                      timeInTapped: () async {
                                        Get.focusScope?.unfocus();
                                        TimeOfDay timeOfDay;
                                        if (controller.timeIn.value !=
                                            "HH:MM") {
                                          timeOfDay = TimeOfDay.fromDateTime(
                                              DateFormat("HH:mm").parse(
                                                  controller.timeIn.value));
                                        } else {
                                          timeOfDay = TimeOfDay.now();
                                        }
                                        final TimeOfDay? pickedTime =
                                            await timePicker(timeOfDay);
                                        if (pickedTime != null) {
                                          var now = DateTime.now();
                                          var dateTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              pickedTime.hour,
                                              pickedTime.minute);
                                          var timeOfDay = DateFormat('hh:mm a')
                                              .format(dateTime);
                                          controller.timeIn.value = timeOfDay;
                                          controller.timeDifferentCalculator();
                                        }
                                      },
                                      timeOutTapped: () async {
                                        Get.focusScope?.unfocus();
                                        TimeOfDay timeOfDay;
                                        if (controller.timeOut.value !=
                                            "HH:MM") {
                                          timeOfDay = TimeOfDay.fromDateTime(
                                              DateFormat("HH:mm").parse(
                                                  controller.timeOut.value));
                                        } else {
                                          timeOfDay = TimeOfDay.now();
                                        }
                                        final TimeOfDay? pickedTime =
                                            await timePicker(timeOfDay);
                                        if (pickedTime != null) {
                                          var now = DateTime.now();
                                          var dateTime = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                              pickedTime.hour,
                                              pickedTime.minute);
                                          var timeOfDay = DateFormat('hh:mm a')
                                              .format(dateTime);
                                          controller.timeOut.value = timeOfDay;
                                          controller.timeDifferentCalculator();
                                        }
                                      },
                                      timeIn: controller.timeIn.value,
                                      timeOut: controller.timeOut.value,
                                      eventNameController:
                                          controller.eventNameController,
                                      totalCostPerSonController: controller
                                          .totalCostPerPersonController,
                                      eventLocationAddressController: controller
                                          .eventLocationAddressController,
                                      eventDescriptionController:
                                          controller.eventDescriptionController,
                                      eventUrlController:
                                          controller.eventUrlController,
                                      descriptionCounter:
                                          controller.descriptionCounter,
                                      locationCount: controller.locationCounter,
                                      onChangedLocation: (v) {
                                        controller.locationCounter.value =
                                            (250 - (v.toString().length))
                                                .toString();
                                      },
                                      onChangedDescription: (v) {
                                        controller.descriptionCounter.value =
                                            (250 - (v.toString().length))
                                                .toString();
                                      },
                                      timeSpent: controller.timeSpent.value,
                                    )
                                  : const SizedBox()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
