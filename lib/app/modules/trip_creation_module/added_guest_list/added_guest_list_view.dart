import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/guest_with_popup_menu_list.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/session/preference.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottomsheet_with_close.dart';
import '../../common_widgets/contact_badge_list.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import 'added_guest_list_controller.dart';

class AddedGuestListView extends GetView<AddedGuestListController> {
  const AddedGuestListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (controller.fromScreen == Constants.fromCreateTrip) {
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            Get.back();
          }

          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar.buildAppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              automaticallyImplyLeading: false,
              isCustomTitle: true,
              customTitleWidget: controller.fromScreen ==
                      Constants.fromCreateTrip
                  ? GestureDetector(
                      onTap: () {
                        Get.offAllNamed(Routes.DASHBOARD);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimens.paddingMedium),
                            color: Get.theme.colorScheme.primary),
                        padding: const EdgeInsets.all(AppDimens.paddingMedium),
                        margin: const EdgeInsets.all(AppDimens.paddingMedium),
                        child: SvgPicture.asset(IconPath.homeIcon),
                      ),
                    )
                  : CustomAppBar.backButton(),
              actionWidget: [
                Row(
                  children: [
                    controller.isTripFinalized.value == false
                        ? controller.isHostOrCoHost.value
                            ? GestureDetector(
                                onTap: () async {
                                  await Get.toNamed(Routes.ADD_GUEST_IMPORT,
                                      arguments: [
                                        controller.tripDetailsModel!.id,
                                        controller.isHostOrCoHost.value,
                                        controller.isTripFinalized.value
                                      ]);
                                  controller.getAddedContacts();
                                },
                                child: SvgPicture.asset(
                                  IconPath.usersLinePlusGreen,
                                  fit: BoxFit.fill,
                                  height: AppDimens.mediumIconSize,
                                  width: AppDimens.mediumIconSize,
                                ),
                              )
                            : const SizedBox()
                        : const SizedBox(),
                    AppDimens.paddingMedium.pw,
                    MasterButtonsBounceEffect.iconButton(
                        svgUrl: IconPath.chatIconMix,
                        bgColor: Colors.transparent,
                        iconSize: AppDimens.mediumIconSize,
                        onPressed: () {
                          Get.toNamed(Routes.CHAT_DETAILS_SCREEN, arguments: [
                            controller.tripDetailsModel!.id,
                            'groupChat'
                          ]);
                        }),
                    /*SvgPicture.asset(
                      IconPath.chatIconMix,
                      fit: BoxFit.fill,
                      height: AppDimens.mediumIconSize,
                      width: AppDimens.mediumIconSize,
                    ),*/
                    AppDimens.paddingMedium.pw,
                  ],
                )
              ]),
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppDimens.paddingExtraLarge,
                      right: AppDimens.paddingExtraLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LabelKeys.invitees.tr,
                        style: onBackGroundTextStyleMedium(),
                      )
                    ],
                  ),
                ),
                /* controller.isHostOrCoHost.value
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingMedium,
                            vertical: AppDimens.paddingSmall),
                        height: AppDimens.subscriptionCardHeight,
                        child: Obx(
                          () => ContactBadgeList(
                            lstAddedGuest:
                                controller.lstAddedGuestSearchData.value,
                            onRemoveTap: (index) {
                              controller.removeGuestApi(
                                  controller.lstAddedGuestSearchData[index].id
                                      .toString(),
                                  controller
                                      .lstAddedGuestSearchData[index].uId);
                            },
                            isTripFinalized: controller.isTripFinalized.value,
                          ),
                        ),
                      )
                    : const SizedBox(),*/
                AppDimens.paddingMedium.ph,
                Expanded(
                  child: ContainerTopRoundedCorner(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.paddingExtraLarge,
                          right: AppDimens.paddingExtraLarge,
                          top: AppDimens.paddingExtraLarge),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: controller.searchTextEditController,
                            textInputAction: TextInputAction.search,
                            onChanged: (value) {
                              controller.lstAddedGuestSearchData.value =
                                  controller.lstAddedGuestModel
                                      .where((element) => element.firstName
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              value.toString().toLowerCase()))
                                      .toList();
                              controller.restorationId.value =
                                  getRandomString();
                            },
                            inputDecoration:
                                CustomTextField.prefixSuffixOnlyIcon(
                              hintText: LabelKeys.searchInvitees.tr,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Get.theme.colorScheme.onBackground
                                        .withAlpha(Constants.limit)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Get.theme.colorScheme.onBackground
                                        .withAlpha(Constants.limit)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Get.theme.colorScheme.onBackground
                                        .withAlpha(Constants.limit)),
                              ),
                              contentPadding:
                                  const EdgeInsets.all(AppDimens.paddingMedium),
                              isDense: false,
                              prefixIconConstraints:
                                  const BoxConstraints(maxHeight: 60),
                              suffixIconConstraints:
                                  const BoxConstraints(maxHeight: 60),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  controller.searchTextEditController.text = "";
                                  controller.lstAddedGuestSearchData.value =
                                      controller.lstAddedGuestModel;
                                  controller.restorationId.value =
                                      getRandomString();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    IconPath.closeRoundedIcon,
                                  ),
                                ),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  IconPath.searchIcon,
                                  height: AppDimens.normalIconSize,
                                  width: AppDimens.normalIconSize,
                                  colorFilter: ColorFilter.mode(
                                      Get.theme.colorScheme.outline,
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: AppDimens.paddingMedium,
                          ),
                          Expanded(
                            child: Obx(
                              () => controller
                                      .lstAddedGuestSearchData.isNotEmpty
                                  ? GuestWithPopupMenuList(
                                      onChatTapped: (index) {
                                        if (controller
                                                .lstAddedGuestSearchData[index]
                                                .uId !=
                                            0) {
                                          String conversationId = '';
                                          final compareTo = controller
                                              .lstAddedGuestSearchData[index]
                                              .uId!
                                              .compareTo(
                                                  gc.loginData.value.id!);
                                          if (compareTo == -1) {
                                            conversationId =
                                                '${gc.loginData.value.id!.toString()}_${controller.lstAddedGuestSearchData[index].uId}';
                                          } else {
                                            conversationId =
                                                '${controller.lstAddedGuestSearchData[index].uId}_${gc.loginData.value.id!.toString()}';
                                          }

                                          RequestManager.showEasyLoader();
                                          FirebaseFirestore.instance
                                              .collection(FireStoreCollection
                                                  .tripGroupCollection)
                                              .where('tripId',
                                                  isEqualTo: conversationId)
                                              .get()
                                              .then((value) {
                                            if (value.docs.isEmpty) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      FireStoreCollection
                                                          .tripGroupCollection)
                                                  .doc(conversationId)
                                                  .set({
                                                FireStoreParams.tripId:
                                                    conversationId,
                                                FireStoreParams.fileName: '',
                                                FireStoreParams.fileType: '',
                                                FireStoreParams.groupData: null,
                                                FireStoreParams.memberIds: [
                                                  gc.loginData.value.id!
                                                      .toString(),
                                                  controller
                                                      .lstAddedGuestSearchData[
                                                          index]
                                                      .uId
                                                      .toString()
                                                ],
                                                FireStoreParams.message: '',
                                                FireStoreParams.senderId: '',
                                                FireStoreParams.timestamp:
                                                    DateTime.now(),
                                              }).then((value) {
                                                EasyLoading.dismiss();
                                                Get.toNamed(
                                                    Routes.CHAT_DETAILS_SCREEN,
                                                    arguments: [
                                                      conversationId,
                                                      'singleChat',
                                                    ]);
                                              });
                                            } else {
                                              EasyLoading.dismiss();
                                              Get.toNamed(
                                                  Routes.CHAT_DETAILS_SCREEN,
                                                  arguments: [
                                                    conversationId,
                                                    'singleChat',
                                                  ]);
                                            }
                                          });
                                        }
                                      },
                                      isTripFinalized:
                                          controller.isTripFinalized.value,
                                      isHostOrCoHost:
                                          controller.isHostOrCoHost.value,
                                      lstAddedGuest: controller
                                          .lstAddedGuestSearchData.value,
                                      onResendTap: (index) {
                                        controller.sendInviteApiCall(controller
                                            .lstAddedGuestSearchData[index].id
                                            .toString());
                                      },
                                      onRemoveTap: (index) {
                                        controller.removeGuestApi(
                                            controller
                                                .lstAddedGuestSearchData[index]
                                                .id
                                                .toString(),
                                            controller
                                                .lstAddedGuestSearchData[index]
                                                .uId);
                                      },
                                      onSendTap: (index) {
                                        if (Preference
                                            .getIsInvitationNoteDisplayed()) {
                                          controller.sendInviteApiCall(
                                              controller
                                                  .lstAddedGuestSearchData[
                                                      index]
                                                  .id
                                                  .toString());
                                        } else {
                                          Get.bottomSheet(
                                            isScrollControlled: true,
                                            BottomSheetWithClose(
                                              widget: showNoteBottomSheet(
                                                  controller
                                                      .lstAddedGuestSearchData[
                                                          index]
                                                      .id
                                                      .toString()),
                                            ),
                                          );
                                        }
                                      },
                                      onGuestTap: (index) {
                                        final role = controller
                                            .lstAddedGuestSearchData[index]
                                            .role;
                                        if (role != "Guest") {
                                          controller.updateGuestRole(
                                              controller
                                                  .lstAddedGuestSearchData[
                                                      index]
                                                  .id
                                                  .toString(),
                                              "Guest",
                                              controller
                                                  .lstAddedGuestSearchData[
                                                      index]
                                                  .isCoHost!);
                                        }
                                      },
                                      onVIPTap: (index) {
                                        final role = controller
                                            .lstAddedGuestSearchData[index]
                                            .role;
                                        controller.updateGuestRole(
                                            controller
                                                .lstAddedGuestSearchData[index]
                                                .id
                                                .toString(),
                                            role == "VIP" ? "Guest" : "VIP",
                                            controller
                                                .lstAddedGuestSearchData[index]
                                                .isCoHost!);
                                      },
                                      onCoHostTap: (index) {
                                        if (controller
                                            .lstAddedGuestSearchData[index]
                                            .isCoHost!) {
                                          controller
                                              .lstAddedGuestSearchData[index]
                                              .isCoHost = false;
                                        } else {
                                          controller
                                              .lstAddedGuestSearchData[index]
                                              .isCoHost = true;
                                        }
                                        controller.updateGuestRole(
                                            controller
                                                .lstAddedGuestSearchData[index]
                                                .id
                                                .toString(),
                                            controller
                                                .lstAddedGuestSearchData[index]
                                                .role
                                                .toString(),
                                            controller
                                                .lstAddedGuestSearchData[index]
                                                .isCoHost!);
                                        controller.restorationId.value =
                                            getRandomString();
                                      },
                                    )
                                  : controller.isDataLoading.value
                                      ? const SizedBox()
                                      : const NoRecordFound(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showNoteBottomSheet(String guestId) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppDimens.paddingLarge.ph,
        /*Text(
          'Please Note:',
          textAlign: TextAlign.center,
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingMedium.ph,*/
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: Text(
            LabelKeys.noteSendInvitation.tr,
            style: onBackgroundTextStyleRegular(
                fontSize: AppDimens.textLarge, alpha: Constants.lightAlfa),
            textAlign: TextAlign.center,
          ),
        ),
        AppDimens.paddingLarge.ph,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: MasterButtonsBounceEffect.gradiantButton(
            btnText: LabelKeys.sendInvite.tr,
            onPressed: () {
              Get.back();
              Preference.isInvitationNoteDisplayed(true);
              controller.sendInviteApiCall(guestId);
            },
          ),
        ),
        AppDimens.padding3XLarge.ph,
      ],
    );
  }
}

class ServerTimestampConverter {
  static DateTime? fromJson(Object? json) {
    if (json is Timestamp) {
      return json.toDate();
    }
    return null;
  }
}
