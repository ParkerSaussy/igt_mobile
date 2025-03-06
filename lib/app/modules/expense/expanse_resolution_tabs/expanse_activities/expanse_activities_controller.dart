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
  /// Refreshes the expense activities data.
  ///
  /// This method clears the current list of expense activities,
  /// generates a new restoration ID, sets the loading state to true,
  /// and fetches the latest expense activities. A delay of 1 second
  /// is added to simulate network latency before performing these actions.

  void onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    expenseActivitiesList.clear();
    restorationId.value = getRandomString();
    isDataLoading.value = true;
    getExpenseActivities();
  }

  /// Simulates network latency by waiting 1 second before performing an action.
  ///
  /// This is used to load the expense activities when the user pulls up the
  /// smart refresher.
  void onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Called when the user changes the index of the bottom tab bar.
  /// It loads the expense activities for the selected trip.
  ///
  /// [tripDetailsModel] is the selected trip.
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

  /// Gets expense activities from API.
  ///
  /// This method is used to get expense activities from API.
  /// It takes trip id as parameter and returns expense activities.
  /// If request is successfull, it assigns response to [expenseActivitiesList] and
  /// sets [isActivitiesFound] to true.
  /// If request is failed, it shows easy loading and sets [isActivitiesFound] to false.
  ///
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

  /// Gets list of guests in a trip from API.
  ///
  /// This method is used to get list of guests in a trip from API.
  /// It takes trip id as parameter and returns list of guests.
  /// If request is successfull, it assigns response to [tripGuestList] and
  /// sets [isListAvailable] to true.
  /// If request is failed, it shows easy loading and sets [isListAvailable] to false.
  /// After the list is fetched, a text editing controller is added to the
  /// textEditingController list for each guest in the trip.
  /// The value of the text editing controller is added to the textFieldValues list.
  /// Finally, the selectedGuestList observable list is populated with the
  /// tripGuestList.
  ///
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

  /// A widget which displays a list of guests in a trip.
  ///
  /// The list is shown in a [ListView] which is inside a [StatefulBuilder].
  /// This is done so that the list can be rebuilt when the state of the
  /// [tripGuestList] changes.
  ///
  /// Each item in the list is displayed as a [MasterListTile] widget.
  /// When an item is tapped, the [isSelected] property of the guest is
  /// toggled and the [restorationId] is set to a new random string.
  ///
  /// The [selectedGuestList] is cleared and then populated with the guests
  /// who are selected.
  ///
  /// The widget also includes a "Ask Deposit" button which is shown at the
  /// bottom of the list. When this button is pressed, the [addDeposit] method
  /// is called.
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

  /// This method returns a [Widget] which is a single item in the [ListView]
  /// in the [equally] method.
  ///
  /// The widget is an [InkWell] which is a container with a single child.
  /// The child is a [Container] which is the content of the widget.
  ///
  /// The [Container] has a height of [AppDimens.circleNavBarHeight] and a
  /// margin of [AppDimens.paddingSmall] on the bottom.
  ///
  /// The decoration of the [Container] is a [BoxDecoration] with a border of
  /// [AppDimens.paddingNano] and a color of [Get.theme.colorScheme.background]
  /// with an alpha of [Constants.veryLightAlfa].
  ///
  /// The background color of the [Container] is [Get.theme.colorScheme.primary]
  /// with an alpha of [Constants.inputFieldCount] if the guest is selected.
  ///
  /// The child of the [Container] is a [Padding] with a child of a [Row].
  /// The [Row] has a main axis alignment of [MainAxisAlignment.spaceBetween]
  /// and a cross axis alignment of [CrossAxisAlignment.center].
  ///
  /// The first child of the [Row] is a [Row] with two children.
  /// The first child of the inner [Row] is a [Stack] with two children.
  /// The first child of the [Stack] is a [Padding] with a child of a
  /// [CommonNetworkImage] which is the profile picture of the guest.
  /// The second child of the [Stack] is a [Positioned] with a child of a
  /// [SvgPicture] which is the selected icon if the guest is selected.
  ///
  /// The second child of the inner [Row] is a [Text] with the name of the
  /// guest.
  ///
  /// The second child of the outer [Row] is a [Text] with the amount of the
  /// guest if the guest is selected.
  ///
  /// When the [InkWell] is tapped, the [onTap] method is called.
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

  /// Adds a deposit to the trip.
  ///
  /// This function is called when the user clicks on the "Add Deposit" button.
  /// It clears the share list and checks if the selected guest list is empty.
  /// If the selected guest list is empty, it shows a snackbar with the message
  /// "Please select guests" and does not add the deposit.
  /// If the selected guest list is not empty, it adds the deposit for each
  /// selected guest and calls the [addExpense] function to add the expense.
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

  /// API call to add an expense to the trip.
  ///
  /// This API is called when the user clicks on the "Add Deposit" button.
  /// The response of this API is not stored anywhere.
  /// If the response is successful, the snackbar is shown with the success message.
  /// If the response is not successful, the error message is printed.
  /// The [getExpenseActivities] function is called to get the list of expense activities
  /// and the screen is popped.
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
