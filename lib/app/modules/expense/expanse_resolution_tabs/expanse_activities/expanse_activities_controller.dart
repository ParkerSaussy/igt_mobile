import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../master/general_utils/app_dimens.dart';
import '../../../../../master/general_utils/constants.dart';
import '../../../../../master/general_utils/images_path.dart';
import '../../../../../master/general_utils/text_styles.dart';
import '../../../../../master/generic_class/common_network_image.dart';
import '../../../../../master/networking/request_manager.dart';
import '../../../../models/added_guest_model.dart';
import '../../../../models/expense_activities.dart';
import '../../../../models/share_list.dart';
import '../../../../models/trip_details_model.dart';
import '../../../common_widgets/bottomsheet_with_close.dart';

class ExpanseActivitiesController extends GetxController {
  //TODO: Implement ExpanseActivitiesController

  final TextEditingController unequalController = TextEditingController();
  TripDetailsModel? tripDetailsModel;
  List<ExpenseActivities> expenseActivitiesList = [];
  RxBool isHost = false.obs;
  RxBool isActivitiesFound = false.obs;
  RxBool isDataLoading = true.obs;
  RxString restorationId = "".obs;
  List<TextEditingController> textEditingController = [];
  RxList<AddedGuestmodel> tripGuestList = <AddedGuestmodel>[].obs;
  RxList<AddedGuestmodel> selectedGuestList = <AddedGuestmodel>[].obs;
  RxDouble amount = 0.0.obs;
  RxList<ShareList> shareList = <ShareList>[].obs;
  Rx<AutovalidateMode> activationMode = AutovalidateMode.disabled.obs;
  GlobalKey<FormState> expenseFormKey =
      GlobalKey<FormState>(debugLabel: "expense");
  String paidBy = "0";

  // Smart refresher
  RefreshController itineraryController =
      RefreshController(initialRefresh: false);
  //Refresh Data
  void onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    expenseActivitiesList.clear();
    restorationId.value = getRandomString();
    isDataLoading.value = true;
    getExpenseActivities();
  }

  void onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void onIndexChange(TripDetailsModel tripDetailsModel) async {
    // getTripDatePollList(tripDetailsModel.id.toString());
    this.tripDetailsModel = tripDetailsModel;
    printMessage("Role tripDetailsModel.role");
    if (tripDetailsModel.role == Role.host) {
      isHost.value = true;
    } else {
      isHost.value = false;
    }
    expenseActivitiesList.clear();
    restorationId.value = getRandomString();
    isDataLoading.value = true;
    getExpenseActivities();
  }

  void getExpenseActivities() {
    RequestManager.postRequest(
      uri: EndPoints.getActivities,
      hasBearer: true,
      isLoader: true,
      body: {RequestParams.trip_id: tripDetailsModel?.id.toString()},
      isSuccessMessage: false,
      onSuccess: (responseBody, message, status) {
        expenseActivitiesList =
            expenseActivitiesFromJson(jsonEncode(responseBody));
        if (expenseActivitiesList.isNotEmpty) {
          isActivitiesFound.value = true;
        } else {
          isActivitiesFound.value = false;
        }
        isDataLoading.value = false;
        restorationId.value = getRandomString();
      },
      onFailure: (error) {
        isDataLoading.value = false;
        printMessage(error);
      },
    );
  }

  void callGuestListApi() {
    RequestManager.postRequest(
        uri: EndPoints.getTripGuestList,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: false,
        body: {RequestParams.tripId: tripDetailsModel?.id},
        onSuccess: (responseBody, message, status) {
          tripGuestList.clear();
          selectedGuestList.clear();
          tripGuestList.value = List<AddedGuestmodel>.from(
              responseBody.map((x) => AddedGuestmodel.fromJson(x)));
          if (tripGuestList.isNotEmpty) {
            for (var trip in tripGuestList) {
              trip.isSelected = true;
              textEditingController.add(TextEditingController());
            }
            /*for (int i = 0; i < tripGuestList.length; i++) {
              textEditingController.add(TextEditingController());
            }*/
            for (int i = 0; i < tripGuestList.length; i++) {
              if (tripGuestList[i].uId == gc.loginData.value.id) {
                paidBy = tripGuestList[i].id.toString();
              }
            }
            selectedGuestList.addAll(tripGuestList);
            Get.bottomSheet(
              isScrollControlled: true,
              BottomSheetWithClose(
                widget: equally(),
              ),
            );
          } else {
            RequestManager.getSnackToast(
                message: LabelKeys.noGuestAvailable.tr);
            Get.back();
          }

          update();
        },
        onFailure: (error) {
          tripGuestList.clear();
          printMessage("error: $error");
        });
  }

  Widget equally() {
    return Expanded(
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDimens.paddingMedium.ph,
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: tripGuestList.value.length,
                  restorationId: restorationId.value,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return itemEqually(index, () {
                      if (tripGuestList[index].isSelected) {
                        tripGuestList[index].isSelected = false;
                      } else {
                        tripGuestList[index].isSelected = true;
                      }
                      restorationId.value = getRandomString();
                      selectedGuestList.clear();
                      for (var tripguestlist in tripGuestList) {
                        if (tripguestlist.isSelected) {
                          selectedGuestList.add(tripguestlist);
                        }
                      }
                      restorationId.value = getRandomString();
                      setState(() {});
                    });
                  },
                ),
              ),
              AppDimens.paddingMedium.ph,
              MasterButtonsBounceEffect.gradiantButton(
                  btnText: LabelKeys.askDeposit.tr,
                  onPressed: () {
                    addDeposit();
                  }),
            ],
          );
        },
      ),
    );
  }

  Widget itemEqually(int index, Function onTap) {
    return Obx(
      () => InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimens.paddingSmall),
          height: AppDimens.circleNavBarHeight,
          decoration: BoxDecoration(
              border: Border.all(
                width: AppDimens.paddingNano,
                color: Get.theme.colorScheme.background
                    .withAlpha(Constants.veryLightAlfa),
              ),
              /*color: controller.unselected.value
                  ? Colors.transparent
                  : Get.theme.colorScheme.primary
                      .withAlpha(Constants.inputFieldCount),*/
              color: tripGuestList[index].isSelected
                  ? Get.theme.colorScheme.primary
                      .withAlpha(Constants.inputFieldCount)
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.paddingMedium))),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppDimens.paddingTiny),
                          child: CommonNetworkImage(
                            imageUrl: tripGuestList[index].profilePicture,
                            height: AppDimens.largeIconSize,
                            width: AppDimens.largeIconSize,
                            radius: AppDimens.paddingMedium,
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: tripGuestList[index].isSelected
                                ? SvgPicture.asset(IconPath.selExpenseIcon)
                                : Container()),
                      ],
                    ),
                    AppDimens.paddingMedium.pw,
                    Text(
                      '${tripGuestList[index].firstName!} ${tripGuestList[index].lastName!}',
                      style: onBackGroundTextStyleMedium(),
                    ),
                  ],
                ),
                Text(
                  tripGuestList[index].isSelected
                      ? amount.value.toString()
                      : '0.00',
                  style: onBackgroundTextStyleSemiBold(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addDeposit() {
    shareList.clear();
    if (selectedGuestList.isEmpty) {
      Get.snackbar(LabelKeys.alert.tr, LabelKeys.selectGuestAddExpense.tr,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Get.theme.colorScheme.onError,
          backgroundColor: Get.theme.colorScheme.error);
    } else {
      for (var trip in selectedGuestList) {
        shareList.add(ShareList(
            debtor: trip.id,
            amount: gc.loginData.value.id == trip.uId
                ? "0"
                : amount.value.toString()));
      }
      addExpense();
    }
  }

  void addExpense() {
    RequestManager.postRequest(
        uri: EndPoints.addExpense,
        hasBearer: true,
        isLoader: true,
        isSuccessMessage: true,
        body: {
          RequestParams.tripID: tripDetailsModel?.id.toString(),
          RequestParams.paidBy: paidBy,
          RequestParams.amount: amount.value.toString(),
          RequestParams.description: "Deposit",
          RequestParams.expenseName: 'Deposit',
          RequestParams.expenseOn:
              DateFormat('yyyy-MM-dd').format(DateTime.now()),
          RequestParams.type: 'Deposit',
          RequestParams.shareList: shareList
        },
        onSuccess: (responseBody, message, status) {
          unequalController.clear();
          selectedGuestList.clear();
          activationMode = AutovalidateMode.disabled.obs;
          expenseFormKey.currentState!.reset();
          getExpenseActivities();
          Get.back();
        },
        onFailure: (error) {
          printMessage("error: $error");
          Get.back();
        });
  }
}
