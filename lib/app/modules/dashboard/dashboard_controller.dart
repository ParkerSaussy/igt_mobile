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

  void didChangeAppLifecycleState(AppLifecycleState state) {
    events.add(state.toString());
    printMessage("Listener State ${state.toString()}");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
  }

  //Refresh Data
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

  addDrawerList() {
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

  onSelectItem(int index) {
    Get.back();
    changeTabbarIndex(index);
  }

  changeTabbarIndex(int index) {
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

  void loadComplete() {
    rController.loadComplete();
    rController.refreshCompleted();
    r2Controller.loadComplete();
    r2Controller.refreshCompleted();
  }

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

  void receiveTripApiResponse() {
    loadComplete();
    callApiForPastTrip();
    restorationId(getRandomString());
  }

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
