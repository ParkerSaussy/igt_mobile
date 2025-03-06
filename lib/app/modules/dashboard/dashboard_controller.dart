import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paypal_native/models/approval/approval_data.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/SingleTripPlanModel.dart';
import 'package:lesgo/app/models/single_plan_model.dart';
import 'package:lesgo/app/models/user_data.dart';
import 'package:lesgo/app/modules/common_widgets/bottomsheet_with_close.dart';
import 'package:lesgo/app/modules/common_widgets/subscription_widget.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/paypal_payment.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../master/session/preference.dart';
import '../../models/trip_details_model.dart';

class DashboardController extends GetxController with WidgetsBindingObserver{
  List<Widget> drawerOptions = [];
  RxString restorationId = "".obs;
  RxString restorationPastId = "".obs;
  RxInt listCurrentIndex = 0.obs;
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  RxList<TripDetailsModel> lstTrip = <TripDetailsModel>[].obs;
  RxList<TripDetailsModel> lstPastTrip = <TripDetailsModel>[].obs;
  RxBool isDataLoaded = false.obs;
  RxBool isInternetAvailable = true.obs;
  RxString isDataRestorationId = ''.obs;
  RxList<SinglePlanModel> lstSinglePlan = <SinglePlanModel>[].obs;
  List<SingleTripPlanModel> lstSingleTripPlanModel = [];

  // Smart refresher
  RefreshController rController = RefreshController(initialRefresh: false);
  RefreshController r2Controller = RefreshController(initialRefresh: false);

  List<String> events = [];

  /// Called when the application's lifecycle state changes.
  ///
  /// This method listens for changes in the app's lifecycle state and
  /// adds the current state to the `events` list. It also prints the
  /// current state using the `printMessage` function.
  ///
  /// [state] - The current [AppLifecycleState] of the application.

  void didChangeAppLifecycleState(AppLifecycleState state) {
    events.add(state.toString());
    printMessage("Listener State ${state.toString()}");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
  }

  //Refresh Data
  /// Refreshes the dashboard data.
  ///
  /// This method resets pagination, clears current trip lists, and marks data
  /// as not loaded. It then initiates a profile API call to fetch fresh data.
  /// The refresh process simulates a delay of one second to mimic network latency.

  void onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    start = 1;
    isLast.value = false;
    lstTrip.value = [];
    lstPastTrip.value = [];
    isDataLoaded.value = false;
    isDataRestorationId.value = "";
    callApiGetProfile();
  }

  /// Simulates a loading operation by pausing for 1 second.
  ///
  /// This method is called when the user scrolls down to the end of the
  /// trip list. It's intended to be overridden by subclasses that support
  /// loading more data.
  void onLoading() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  //Temp
  RxBool isListAvailable = false.obs;

  //Pagination
  var start = 1;
  var isLast = false.obs;
  ScrollController scrollController = ScrollController();

  final drawerItems = [
    DrawerItem(
      LabelKeys.myProfile.tr,
      getMenuIcon(IconPath.icUserLine),
    ),
    /*DrawerItem(
      LabelKeys.myAccount.tr,
      getMenuIcon(IconPath.icMyAccount),
    ),*/
    DrawerItem(
      LabelKeys.showTutorial.tr,
      getMenuIcon(IconPath.icShowTutorials),
    ),
    DrawerItem(
      LabelKeys.settings.tr,
      getMenuIcon(IconPath.icSettings),
    ),
    /*DrawerItem(
      LabelKeys.calendar.tr,
      getMenuIcon(IconPath.icCalendar),
    ),*/
    DrawerItem(
      LabelKeys.notifications.tr,
      getMenuIcon(IconPath.icNotification),
    ),
    DrawerItem(
      LabelKeys.termsAndConditionDashBoard.tr,
      getMenuIcon(IconPath.icMyAccount),
    ),
    DrawerItem(
      LabelKeys.privacyPolicy.tr,
      getMenuIcon(IconPath.icPrivacy),
    ),
    DrawerItem(
      LabelKeys.aboutItsGoTime.tr,
      getMenuIcon(IconPath.icLesgoLS),
    ),
    DrawerItem(
      LabelKeys.faqs.tr,
      getMenuIcon(IconPath.icFAQs),
    ),
    DrawerItem(
      LabelKeys.contactUs.tr,
      getMenuIcon(IconPath.icContactUs),
    ),
  ];
  PageController pageController = PageController(
    initialPage: gc.selectedIndex.value,
    keepPage: true,
  );

  //Rx<UserData> userData = UserData().obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gc.loginData.value = Preference.getLoginResponse();
      addDrawerList();
      start = 1;
      isLast.value = false;
      lstTrip.value = [];
      lstPastTrip.value = [];
      callApiGetProfile();
      addPlanDetailsData();
      // getSingleTripPlan();
      // addPlanDetailsData();
    });
  }

  // To add plan details static data
  /// To add plan details static data
  ///
  /// This method is used to add premium features list.
  void addPlanDetailsData() {
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 1,
        title: LabelKeys.groupChat.tr,
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: LabelKeys.inAppChat.tr,
        description: LabelKeys.premiumFeaturesGroupChatMsg.tr,
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 2,
        title: LabelKeys.expenseSharing.tr,
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: LabelKeys.expenseSharingTool.tr,
        description: LabelKeys.expenseSharingToolMsg.tr,
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 3,
        title: LabelKeys.activitiesOrganizer.tr,
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: LabelKeys.activitiesOrganizerSubTitle.tr,
        description: LabelKeys.activitiesOrganizerMsg.tr,
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 4,
        title: LabelKeys.documentSharing.tr,
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: LabelKeys.documentSharingSubTitle.tr,
        description: LabelKeys.documentSharingMsg.tr,
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 5,
        title: LabelKeys.memoriesStorage.tr,
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: LabelKeys.memoriesStorageSubTitle.tr,
        description: LabelKeys.memoriesStorageMsg.tr,
        isSelected: false));
  }

  /// Populate the drawer with the list of items specified in
  /// [drawerItems].
  ///
  /// This method creates a [ListTile] for each item in [drawerItems] and
  /// adds it to [drawerOptions]. The [ListTile] is configured with the
  /// title and icon from the item, as well as a badge indicating the number
  /// of notifications if the item is the "Notifications" item and there is
  /// at least one notification. The selected state of the [ListTile] is also
  /// set based on the value of [gc.selectedIndex].
  ///
  /// When the [ListTile] is tapped, [onSelectItem] is called with the index
  /// of the item.
  void addDrawerList() {
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
        ListTile(
          leading: d.icon,
          horizontalTitleGap: AppDimens.paddingSmall,
          title: Text(
            d.title,
            style: onBackGroundTextStyleMedium(fontSize: AppDimens.textMedium),
          ),
          trailing: i == 3
              ? Obx(() => gc.loginData.value.notificationCount == 0
                  ? const SizedBox()
                  : Container(
                      height: AppDimens.drawerIconSize,
                      width: AppDimens.drawerIconSize,
                      //padding: const EdgeInsets.all(AppDimens.paddingSmall),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF004120),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(AppDimens.radiusCircle),
                        ),
                        color: Get.theme.colorScheme.error,
                      ),
                      child: Center(
                        child: Text(
                          gc.loginData.value.notificationCount == null
                              ? ""
                              : gc.loginData.value.notificationCount.toString(),
                          style: onBackGroundTextStyleMedium()
                              .copyWith(color: Get.theme.colorScheme.onError),
                        ),
                      ),
                    ))
              : const SizedBox(),
          selected: i == gc.selectedIndex.value,
          onTap: () => onSelectItem(i),
        ),
      );
    }
  }

/// Handles the selection of a drawer item.
///
/// This method is called when a user taps on a drawer item. It performs
/// two actions:
/// 1. Closes the current route using `Get.back()`.
/// 2. Changes the tab bar index to the selected item index by calling
///    `changeTabbarIndex(index)`.
///
/// [index] - The index of the selected drawer item.

  void onSelectItem(int index) {
    Get.back();
    changeTabbarIndex(index);
  }


  /// Changes the tab bar index to the given [index].
  ///
  /// This method is called when a user taps on a drawer item. It performs
  /// two actions:
  /// 1. Changes the tab bar index to the selected item index by calling
  ///    `selectedIndex.value = index`.
  /// 2. Changes the screen to the selected item screen by calling
  ///    `Get.toNamed()` with the corresponding route name.
  ///
  /// [index] - The index of the selected drawer item.
  void changeTabbarIndex(int index) {
    gc.selectedIndex.value = index;
    gc.bottomRefresher.value = getRandomString();
    if (index == 0) {
      Get.toNamed(Routes.MYPROFILE, arguments: Constants.fromDashboard);
    }
    /*else if (index == 1) {
      //My Account
      RequestManager.getSnackToast(
        message: "My Account",
        backgroundColor: Colors.blueAccent,
      );
    }*/
    else if (index == 1) {
      // Tutorial
      Get.toNamed(
        Routes.ONBOARDING_SCREEN,
        arguments: true,
      );
    } else if (index == 2) {
      Get.toNamed(Routes.SETTINGS);
    }
    /*else if (index == 4) {
      // Calendar
      RequestManager.getSnackToast(
        message: "Calendar",
        backgroundColor: Colors.blueAccent,
      );
    }*/
    else if (index == 3) {
      // Notification
      Get.toNamed(Routes.NOTIFICATIONS);
    } else if (index == 4) {
      // T&C
      Get.toNamed(Routes.ABOUTUS,
          arguments: [LabelKeys.termsAndCondition.tr, Constants.fromDashboard]);
    } else if (index == 5) {
      // T&C
      Get.toNamed(Routes.ABOUTUS,
          arguments: [LabelKeys.privacyPolicy.tr, Constants.fromDashboard]);
    } else if (index == 6) {
      // About Us
      Get.toNamed(Routes.ABOUTUS,
          arguments: [LabelKeys.aboutus.tr, Constants.fromDashboard]);
    } else if (index == 7) {
      //FAQs
      Get.toNamed(Routes.FAQ);
    } else if (index == 8) {
      // Contact Us
      Get.toNamed(Routes.CONTACTUS);
    } else {}
    /*pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);*/
  }

  /// This method is used to indicate that the data loading operation
  /// has been completed.
  ///
  /// It calls the [loadComplete] and [refreshCompleted] methods of
  /// [rController] and [r2Controller] to indicate that the data loading
  /// operation has been completed.
  void loadComplete() {
    rController.loadComplete();
    rController.refreshCompleted();
    r2Controller.loadComplete();
    r2Controller.refreshCompleted();
  }

  /// Gets list of upcoming trips from API.
  ///
  /// This method is used to get list of upcoming trips from API.
  /// It posts request to [EndPoints.getTripsList] with [RequestParams.tripType] set to "upcoming".
  /// If request is successfull, it assigns response to [lstTrip] and sets [isListAvailable] to true.
  /// If request is failed, it sets [isListAvailable] to false.
  /// In both cases, it calls [receiveTripApiResponse] to receive trip api response.
  void callApiForGetTripList() {
    RequestManager.postRequest(
        uri: EndPoints.getTripsList,
        hasBearer: true,
        isLoader: false,
        isFailedMessage: false,
        isSuccessMessage: false,
        body: {RequestParams.tripType: "upcoming"},
        onSuccess: (responseBody, message, status) {
          lstTrip.value = List<TripDetailsModel>.from(
              responseBody.map((x) => TripDetailsModel.fromJson(x)));
          isListAvailable.value = lstTrip.isNotEmpty;
          receiveTripApiResponse();
        },
        onFailure: (error) {
          receiveTripApiResponse();
        });
  }

  /// This method is used to receive the response of trip api.
  ///
  /// It calls the [loadComplete] to indicate that the data loading operation
  /// has been completed and then calls the [callApiForPastTrip] to get the list
  /// of past trips. Finally, it sets a random value to [restorationId] to
  /// indicate that the data has been refreshed.
  void receiveTripApiResponse() {
    loadComplete();
    callApiForPastTrip();
    restorationId(getRandomString());
  }

  /// Fetches list of past trips from API.
  ///
  /// This method posts a request to [EndPoints.getTripsList] with
  /// [RequestParams.tripType] set to "past". If the request is successful,
  /// it assigns the response to [lstPastTrip] and sets [isListAvailable] based
  /// on whether the list is not empty. Regardless of success or failure, it
  /// calls [receivePastResponse] to handle the response.

  /// Fetches list of past trips from API.
  ///
  /// This method posts a request to [EndPoints.getTripsList] with
  /// [RequestParams.tripType] set to "past". If the request is successful,
  /// it assigns the response to [lstPastTrip] and sets [isListAvailable] based
  /// on whether the list is not empty. Regardless of success or failure, it
  /// calls [receivePastResponse] to handle the response.
  void callApiForPastTrip() {
    RequestManager.postRequest(
        uri: EndPoints.getTripsList,
        hasBearer: true,
        isLoader: false,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {RequestParams.tripType: "past"},
        onSuccess: (responseBody, message, status) {
          lstPastTrip.value = List<TripDetailsModel>.from(
              responseBody.map((x) => TripDetailsModel.fromJson(x)));
          isListAvailable.value = lstPastTrip.isNotEmpty;
          receivePastResponse();
        },
        onFailure: (error) {
          receivePastResponse();
        });
  }

  /// Handles the response of past trip api.
  ///
  /// It checks if either of [lstTrip] or [lstPastTrip] is not empty. If either
  /// of them is not empty, it sets [isDataLoaded] to true, otherwise false. It
  /// also sets a random value to [isDataRestorationId] and [restorationPastId].
  /// Finally, it calls [loadComplete] and dismisses the easy loading.
  void receivePastResponse() {
    if (lstTrip.isNotEmpty || lstPastTrip.isNotEmpty) {
      isDataLoaded.value = true;
      isDataRestorationId.value = getRandomString();
    } else {
      isDataLoaded.value = false;
      isDataRestorationId.value = getRandomString();
    }
    restorationPastId(getRandomString());
    loadComplete();
    EasyLoading.dismiss();
  }

  /// Calls the API to get the user's profile.
  ///
  /// This method sends a POST request to the [EndPoints.getProfile] endpoint.
  /// It shows an easy loader while the request is in progress.
  /// If the request is successful, it updates the [userModel] with the response
  /// data and saves the login response to preferences. It also calls
  /// [callApiForGetTripList] to fetch the trip list.
  /// If the request fails, it checks for internet connectivity. If there is no

  void callApiGetProfile() {
    RequestManager.showEasyLoader();
    RequestManager.postRequest(
        uri: EndPoints.getProfile,
        hasBearer: true,
        isLoader: false,
        isSuccessMessage: false,
        isFailedMessage: false,
        body: {},
        onSuccess: (responseBody, message, status) {
          isInternetAvailable.value = true;
          var userModel = userDataFromJson(jsonEncode(responseBody));
          Preference.setLoginResponse(userModel);
          callApiForGetTripList();
        },
        onFailure: (error) {
          if (error.toString() == LabelKeys.checkInternet.tr) {
            isInternetAvailable.value = false;
            printMessage("No internet");
            EasyLoading.dismiss();
            loadComplete();
          } else {
            isInternetAvailable.value = true;
            callApiForGetTripList();
          }
        });
  }

  /// Gets single trip plan from API.
  ///
  /// This method sends a POST request to the [EndPoints.getPlans] endpoint.
  /// It shows an easy loader while the request is in progress.
  /// If the request is successful, it updates the [lstSinglePlan] with the response
  /// data, sets the first single trip plan as selected, and opens the subscription
  /// bottom sheet.
  /// If the request fails, it dismisses the easy loader.
  void getSingleTripPlan(TripDetailsModel tripDetailsMode) {
    RequestManager.postRequest(
      uri: EndPoints.getPlans,
      hasBearer: true,
      isLoader: true,
      body: {RequestParams.type: PlanType.singlePlan},
      onSuccess: (responseBody, message, status) {
        lstSinglePlan.value = List<SinglePlanModel>.from(
            responseBody.map((x) => SinglePlanModel.fromJson(x)));
        for (int i = 0; i < lstSingleTripPlanModel.length; i++) {
          lstSingleTripPlanModel[i].isSelected = false;
        }
        lstSingleTripPlanModel[0].isSelected = true;
        openSubscriptionBottomSheet(
            singleTripPlanModel: lstSingleTripPlanModel[0],
            tripDetailsModel: tripDetailsMode);
        EasyLoading.dismiss();
      },
      onFailure: (error) {
        EasyLoading.dismiss();
      },
    );
  }

  /// Opens a subscription bottom sheet with a single trip plan.
  ///
  /// If the user is a host, it navigates to the subscription plan screen.
  /// If the user is a guest, it shows a bottom sheet with the single trip plan
  /// details. If there are no single trip plans available, it shows a snackbar
  /// with a message saying "No plans found".
  void openSubscriptionBottomSheet(
      {required SingleTripPlanModel singleTripPlanModel,
      required TripDetailsModel tripDetailsModel}) {
    if (tripDetailsModel.role == 'Host') {
      Get.toNamed(Routes.SUBSCRIPTION_PLAN_SCREEN)
          ?.then((value) => callApiForGetTripList());
    } else {
      if (lstSinglePlan.isNotEmpty) {
        Get.bottomSheet(
          isScrollControlled: true,
          ignoreSafeArea: true,
          BottomSheetWithClose(
            widget: planBottomSheet(
                singleTripPlanModel: singleTripPlanModel,
                tripDetailsModel: tripDetailsModel),
            titleWidget: Text(
              singleTripPlanModel.title,
              textAlign: TextAlign.center,
              style:
                  onBackgroundTextStyleSemiBold(fontSize: AppDimens.textLarge),
            ),
          ),
        );
      } else {
        RequestManager.getSnackToast(message: LabelKeys.noPlansFound.tr);
      }
    }
  }

  /// Returns a subscription widget with a single trip plan.
  ///
  /// This widget is used as the content of a bottom sheet that is shown when the
  /// user clicks on the "Unlock Trip" button. It shows the details of the single
  /// trip plan and allows the user to purchase it. When the user clicks on the
  /// "Unlock Trip" button, it shows an easy loader and makes a payment request
  /// using the PayPal payment service. When the payment is successful, it
  /// navigates to the trip creation screen.
  Widget planBottomSheet(
      {required SingleTripPlanModel singleTripPlanModel,
      required TripDetailsModel tripDetailsModel}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SubscriptionWidget(
          singleTripPlan: lstSingleTripPlanModel,
          singleTripPlanModel: singleTripPlanModel,
          singlePlanModel: lstSinglePlan[0],
          onUnlockTripTap: () {
            RequestManager.showEasyLoader();
            payPalCallBackMethods(tripDetailsModel);
            PayPalPayment.makePayment(
              amount: double.parse(lstSinglePlan[0].discountedPrice!),
            );
            //
          },
          /*onExploreMorePlanTap: () {
            Get.toNamed(Routes.SUBSCRIPTION_PLAN_SCREEN);
          },*/
        );
      },
    );
  }

  /// Sets a callback for PayPal payment.
  ///
  /// This method sets a callback for the PayPal payment service. The callback
  /// is called when the user cancels the payment, when the payment is successful,
  /// or when there is an error with the payment. When the payment is successful,
  /// it calls the [purchasePlanAPI] method to make a request to the server to
  /// purchase a plan.
  ///
  /// The [tripDetailsModel] parameter is the trip details model for the trip
  /// that the user is trying to unlock.
  void payPalCallBackMethods(TripDetailsModel tripDetailsModel) {
    //call backs for payment
    PayPalPayment.flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          EasyLoading.dismiss();
        },
        onSuccess: (data) {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          purchasePlanAPI(data, tripDetailsModel);
        },
        onError: (data) {
          PayPalPayment.flutterPaypalNativePlugin.removeAllPurchaseItems();
          EasyLoading.dismiss();
          RequestManager.getSnackToast(message: data.reason);
        },
        onShippingChange: (data) {
          EasyLoading.dismiss();
          RequestManager.getSnackToast(
              message: data.shippingChangeAddress?.adminArea1 ?? "");
        },
      ),
    );
  }

  /// Makes a request to the server to purchase a plan.
  ///
  /// This method is called when the user makes a successful payment using the
  /// PayPal payment service. It makes a POST request to the [EndPoints.purchasePlan]
  /// endpoint to purchase a plan and unlock a trip. If the request is successful,
  /// it navigates back to the trip list screen.
  ///
  /// The [data] parameter is the PayPal approval data that is returned by the
  /// PayPal payment service when the user makes a successful payment.
  ///
  /// The [tripDetailsModel] parameter is the trip details model for the trip
  /// that the user is trying to unlock.
  void purchasePlanAPI(
      FPayPalApprovalData data, TripDetailsModel tripDetailsModel) {
    RequestManager.postRequest(
      uri: EndPoints.purchasePlan,
      hasBearer: true,
      isLoader: true,
      isSuccessMessage: true,
      body: {
        RequestParams.planType: PlanType.singlePlan,
        RequestParams.planId: lstSinglePlan[0].id,
        RequestParams.price: lstSinglePlan[0].price,
        RequestParams.tripID: tripDetailsModel.id,
        RequestParams.transactionId: data.orderId,
        RequestParams.paymentThrough: 'paypal',
      },
      onSuccess: (responseBody, message, status) {
        Get.back();
        callApiForGetTripList();
      },
      onFailure: (error) {},
    );
  }
}

  /// Returns a [Container] widget with an SVG icon.
  ///
  /// The widget is typically used in the drawer menu of the app. The SVG icon
  /// is colored with the [onSecondary] color of the current theme.
  ///
  /// The [svgImagePath] parameter is the path to the SVG image that is to be
  /// displayed in the widget.
Widget getMenuIcon(String svgImagePath) {
  return Container(
    height: AppDimens.drawerIconSize,
    width: AppDimens.drawerIconSize,
    padding: const EdgeInsets.all(AppDimens.paddingSmall),
    decoration: BoxDecoration(
      borderRadius:
          const BorderRadius.all(Radius.circular(AppDimens.radiusCornerSmall)),
      color: Get.theme.colorScheme.surfaceVariant,
    ),
    child: SvgPicture.asset(
      svgImagePath,
      colorFilter:
          ColorFilter.mode(Get.theme.colorScheme.onSecondary, BlendMode.srcIn),
    ),
  );
}

class DrawerItem {
  String title;
  Widget icon;

  DrawerItem(this.title, this.icon);
}
