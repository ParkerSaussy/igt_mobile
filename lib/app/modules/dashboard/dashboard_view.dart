import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/bottom_rounded_container.dart';
import 'package:lesgo/app/modules/lrf/biomateric_auth.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../../master/generic_class/common_network_image.dart';
import '../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../master/networking/request_manager.dart';
import '../../../master/session/preference.dart';
import '../../routes/app_pages.dart';
import '../common_widgets/lesgo_appbar_logo.dart';
import '../common_widgets/trip_card_list.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FGBGNotifier(onEvent: (event) {
      controller.events.add(event.toString());
      printMessage("Listener ${event.toString()}");
      if(event == FGBGType.foreground){
        Get.to(BiomatericAuth(message: null,isClose: true,));
      }
    }, child: GetBuilder<DashboardController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          Get.focusScope?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar.buildAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Get.theme.colorScheme.primary,
            isCustomTitle: true,
            customTitleWidget: Center(
              child: LesgoAppbarLogo(
                padding: EdgeInsets.zero,
              ),
            ),
            actionWidget: [
              GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.MYPROFILE,
                        arguments: Constants.fromDashboard);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingMedium),
                    child: Obx(
                      () => Container(
                          width: AppDimens.mediumIconSize,
                          height: AppDimens.mediumIconSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFF004120),
                                strokeAlign: BorderSide.strokeAlignOutside),
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusCorner),
                          ),
                          child: CommonNetworkImage(
                              imageUrl: gc.loginData.value.profileImage ?? "",
                              width: 46,
                              height: 46,
                              errorWidget: Icon(Icons.person),
                              radius: AppDimens.radiusCorner)),
                    ),
                  )),
            ],
            leadingWidget: GestureDetector(
              onTap: () {
                //gc.loginData.value = Preference.getLoginResponse();
                controller.update();
                if (!controller.drawerKey.currentState!.isDrawerOpen) {
                  controller.drawerKey.currentState!.openDrawer();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingLarge),
                child: SvgPicture.asset(IconPath.drawer),
              ),
            ),
          ),
          drawer: drawerView(),
          key: controller.drawerKey,
          body: SafeArea(
            bottom: false,
            child: Obx(
              () => Stack(
                children: [
                  const BottomRoundedContainer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingLarge),
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: WaterDropMaterialHeader(
                        backgroundColor: Get.theme.colorScheme.primary,
                      ),
                      controller: controller.r2Controller,
                      onRefresh: controller.onRefresh,
                      onLoading: controller.onLoading,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${LabelKeys.hello.tr} ${gc.loginData.value.firstName == null ? "" : gc.loginData.value.firstName.toString()}!",
                            style: onPrimaryTextStyleMedium(
                                fontSize: AppDimens.textLarge),
                          ),
                          tripList()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Obx(
            () => controller.isDataLoaded.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingLarge),
                    child: MasterButtonsBounceEffect.gradientFABExtended(
                      labelText: LabelKeys.createEvent.tr,
                      onPressed: () async {
                        await Get.toNamed(Routes.CREATE_TRIP);
                        controller.callApiForGetTripList();
                      },
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      );
    }));

  }

  drawerView() {
    return Obx(
      () => Drawer(
        child: Column(children: [
          SizedBox(
            height: AppDimens.drawerHeaderHeight,
            width: Get.width,
            child: Theme(
              data: Theme.of(Get.context!).copyWith(
                dividerTheme: const DividerThemeData(color: Colors.transparent),
              ),
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gc.loginData.value.firstName == null
                          ? ""
                          : gc.loginData.value.firstName.toString(),
                      style: primaryTextStyleSemiBold(),
                    ),
                    AppDimens.paddingSmall.ph,
                    Text(
                      gc.loginData.value.email == null
                          ? ""
                          : gc.loginData.value.email.toString(),
                      style: onBackgroundTextStyleRegular(
                          alpha: Constants.lightAlfa),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: controller.drawerOptions),
            ),
          ),
          ListTile(
            leading: Text(
              "${LabelKeys.version.tr} ${Preference.getVersionCode()}",
              style: onBackgroundTextStyleRegular(alpha: Constants.lightAlfa),
            ),
          ),
        ]),
      ),
    );
  }

  Widget tripList() {
    return Obx(() => controller.isInternetAvailable.value
        ? Expanded(child: withInternet())
        : Expanded(child: noInternet()));
  }

  Widget noInternet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            IconPath.noInternetConnection,
            height: 200,
            width: 200,
          ),
          Text(LabelKeys.noInternetConnection.tr,
              style: onBackGroundTextStyleMedium(
                fontSize: AppDimens.textLarge,
              ),
              overflow: TextOverflow.ellipsis),
          Text(
              "Whoops, no internet connection \nfound. Please check your connection",
              maxLines: 2,
              style: onBackgroundTextStyleRegular(
                  fontSize: AppDimens.textSmall, alpha: Constants.lightAlfa),
              overflow: TextOverflow.ellipsis),
          MasterButtonsBounceEffect.textButton(
              btnText: "Retry",
              textStyles: primaryTextStyleSemiBold(),
              onPressed: () {
                controller.callApiGetProfile();
              })
        ],
      ),
    );
  }

  Widget withInternet() {
    return controller.isDataRestorationId.value.isEmpty
        ? const SizedBox()
        : controller.isDataLoaded.value
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppDimens.paddingMedium),
                      child: Text(
                        controller.listCurrentIndex.value == 0
                            ? LabelKeys.upcomingTrips.tr
                            : LabelKeys.pastTrips.tr,
                        style: onPrimaryTextStyleSemiBold(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListViewObserver(
                      onObserve: (resultModel) {
                        controller.listCurrentIndex.value =
                            resultModel.firstChild!.index;
                      },
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: false,
                        header: WaterDropMaterialHeader(
                          backgroundColor: Get.theme.colorScheme.primary,
                        ),
                        controller: controller.rController,
                        onRefresh: controller.onRefresh,
                        onLoading: controller.onLoading,
                        child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return index == 0
                                ? Obx(() => TripCardList(
                                      isPastTrip: false,
                                      padding:
                                          const EdgeInsets.only(bottom: 00),
                                      scrollDirection: Axis.vertical,
                                      restorationId:
                                          controller.restorationId.value,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: AppDimens.paddingSmall),
                                      scrollController:
                                          controller.scrollController,
                                      isLast: controller.isLast.value,
                                      onItemClicked: (index) async {
                                        await Get.toNamed(Routes.TRIP_DETAIL,
                                            arguments: [
                                              controller.lstTrip[index].id
                                            ]);
                                        controller.callApiForGetTripList();
                                      },
                                      modelList: controller.lstTrip.value,
                                      onChatTap: (index) {
                                        if (controller.lstTrip[index].isPaid ==
                                                0 ||
                                            controller.lstTrip[index].isPaid ==
                                                null) {
                                          controller.getSingleTripPlan(
                                              controller.lstTrip[index]);
                                        } else {
                                          Get.toNamed(
                                              Routes.CHAT_DETAILS_SCREEN,
                                              arguments: [
                                                controller.lstTrip[index].id,
                                                'groupChat'
                                              ]);
                                        }
                                      },
                                      onBarChartTap: (index) {
                                        Get.toNamed(Routes.POLL_DETAIL,
                                            arguments: [
                                              controller.lstTrip[index],
                                              true
                                            ]);
                                      },
                                    ))
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => controller
                                                    .listCurrentIndex.value ==
                                                1
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: AppDimens
                                                        .paddingMedium),
                                                child: Container(),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: AppDimens
                                                        .paddingMedium),
                                                child: Text(
                                                  LabelKeys.pastTrips.tr,
                                                  style:
                                                      onBackgroundTextStyleSemiBold(),
                                                ),
                                              ),
                                      ),
                                      Obx(
                                        () => TripCardList(
                                          isPastTrip: true,
                                          padding:
                                              const EdgeInsets.only(bottom: 70),
                                          scrollDirection: Axis.vertical,
                                          restorationId: controller
                                              .restorationPastId.value,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: AppDimens.paddingSmall),
                                          scrollController:
                                              controller.scrollController,
                                          isLast: controller.isLast.value,
                                          onItemClicked: (index) async {
                                            await Get.toNamed(
                                                Routes.TRIP_DETAIL,
                                                arguments: [
                                                  controller
                                                      .lstPastTrip[index].id
                                                ]);
                                            controller.callApiForGetTripList();
                                          },
                                          modelList:
                                              controller.lstPastTrip.value,
                                          onChatTap: (index) {
                                            if (controller.lstPastTrip[index]
                                                        .isPaid ==
                                                    0 ||
                                                controller.lstPastTrip[index]
                                                        .isPaid ==
                                                    null) {
                                              controller.getSingleTripPlan(
                                                  controller
                                                      .lstPastTrip[index]);
                                            } else {
                                              Get.toNamed(
                                                  Routes.CHAT_DETAILS_SCREEN,
                                                  arguments: [
                                                    controller
                                                        .lstPastTrip[index].id,
                                                    'groupChat'
                                                  ]);
                                            }
                                          },
                                          onBarChartTap: (index) {
                                            Get.toNamed(Routes.POLL_DETAIL,
                                                arguments: [
                                                  controller.lstTrip[index],
                                                  true
                                                ]);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : createEventView();
  }

  Widget createEventView() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: AppDimens.paddingMedium),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(80),
            ),
            color: Colors.white,
            border: Border.all(
                color: Get.theme.colorScheme.outline,
                strokeAlign: BorderSide.strokeAlignOutside),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              AppDimens.paddingMedium.ph,
              Image.asset(ImagesPath.dashBoardNoDataImage, fit: BoxFit.cover),
              AppDimens.padding3XLarge.ph,
              Text(
                LabelKeys.createYourFirstTrip.tr,
                style: onBackgroundTextStyleSemiBold(
                    fontSize: AppDimens.textExtraLarge),
              ),
              AppDimens.paddingMedium.ph,
              Text(
                LabelKeys.maximumGuestAttending.tr,
                textAlign: TextAlign.center,
                style:
                    onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingHuge,
                    vertical: AppDimens.paddingHuge),
                child: MasterButtonsBounceEffect.gradiantButtonWithRightIcon(
                  btnText: LabelKeys.createEvent.tr,
                  svgUrl: IconPath.icAddWithBG,
                  width: Get.width,
                  onPressed: () async {
                    //controller.isListAvailable.value = true;
                    await Get.toNamed(Routes.CREATE_TRIP);
                    controller.callApiForGetTripList();
                  },
                ),
              ),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}
