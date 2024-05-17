import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/app/modules/common_widgets/search_contact_badge_list.dart';
import 'package:lesgo/app/modules/common_widgets/search_contact_list.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../../master/generic_class/custom_textfield.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import 'search_contact_screen_controller.dart';

class SearchContactScreenView extends GetView<SearchContactScreenController> {
  const SearchContactScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          isCustomTitle: true,
          customTitleWidget:
              CustomAppBar.backButton(backText: LabelKeys.addNewGuest.tr),
        ),
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
                      LabelKeys.selectGuestList.tr,
                      style: onBackGroundTextStyleMedium(),
                    )
                  ],
                ),
              ),
              Obx(() => controller.isHostOrCoHost.value &&
                      controller.lstSelectedContact.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingMedium,
                          vertical: AppDimens.paddingSmall),
                      height: AppDimens.subscriptionCardHeight,
                      child: SearchContactBadgeList(
                        lstSearchContact: controller.lstSelectedContact.value,
                        onRemoveTap: (index) {
                          if (controller.lstSelectedContact[index].isSelected) {
                            controller.lstSelectedContact[index].isSelected =
                                false;
                            controller.lstSelectedContact.removeWhere(
                                (element) =>
                                    element.id ==
                                    controller.lstSelectedContact[index].id);
                          } else {
                            controller.lstSelectedContact[index].isSelected =
                                true;
                            controller.lstSelectedContact
                                .add(controller.lstSelectedContact[index]);
                            print(controller
                                .fetchedSearchContacts[index].name.first);
                          }
                          controller.fetchedContactsRestorationId.value =
                              getRandomString();
                        },
                        isTripFinalized: controller.isTripFinalized.value,
                      ),
                    )
                  : const SizedBox()),
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
                          textInputAction: TextInputAction.search,
                          controller: controller.searchTextEditController,
                          onChanged: (value) {
                            controller.fetchedSearchContacts.value = controller
                                .fetchedContacts
                                .where((element) => element.name.first
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toString().toLowerCase()))
                                .toList();
                            controller.fetchedContactsRestorationId.value =
                                getRandomString();
                          },
                          inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            hintText: LabelKeys.searchContact.tr,
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(),
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
                                controller.fetchedSearchContacts.value =
                                    controller.fetchedContacts;
                                controller.fetchedContactsRestorationId.value =
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
                          child: Obx(() => controller
                                      .fetchedContactsRestorationId.value ==
                                  ""
                              ? const NoRecordFound()
                              : controller.fetchedSearchContacts.isNotEmpty
                                  ? SearchContactList(
                                      allContacts:
                                          controller.fetchedSearchContacts,
                                      onTap: (index) {
                                        if (controller
                                            .fetchedSearchContacts[index]
                                            .isSelected) {
                                          controller
                                              .fetchedSearchContacts[index]
                                              .isSelected = false;
                                          controller.lstSelectedContact
                                              .removeWhere((element) =>
                                                  element.id ==
                                                  controller
                                                      .fetchedSearchContacts[
                                                          index]
                                                      .id);
                                        } else {
                                          controller
                                              .fetchedSearchContacts[index]
                                              .isSelected = true;
                                          controller.lstSelectedContact.add(
                                              controller.fetchedSearchContacts[
                                                  index]);
                                          print(controller
                                              .fetchedSearchContacts[index]
                                              .name
                                              .first);
                                        }
                                        controller.fetchedContactsRestorationId
                                            .value = getRandomString();
                                      },
                                      onGuestTap: (index) {
                                        controller.fetchedSearchContacts[index]
                                            .selectedRole = "Guest";
                                        controller.fetchedContactsRestorationId
                                            .value = getRandomString();
                                      },
                                      onVipTap: (index) {
                                        controller.fetchedSearchContacts[index]
                                            .selectedRole = "VIP";
                                        controller.fetchedContactsRestorationId
                                            .value = getRandomString();
                                      },
                                      onCoHostTap: (index) {
                                        if (controller
                                            .fetchedSearchContacts[index]
                                            .isCoHost) {
                                          controller
                                              .fetchedSearchContacts[index]
                                              .isCoHost = false;
                                        } else {
                                          controller
                                              .fetchedSearchContacts[index]
                                              .isCoHost = true;
                                        }
                                        controller.fetchedContactsRestorationId
                                            .value = getRandomString();
                                      },
                                      restorationId: controller
                                          .fetchedContactsRestorationId.value,
                                    )
                                  : const NoRecordFound()),
                        ),
                        isKeyboardOpen
                            ? Container()
                            : Obx(() => controller
                                    .fetchedSearchContacts.value.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: MasterButtonsBounceEffect
                                        .gradiantButton(
                                      btnText: LabelKeys.addGuest.tr,
                                      onPressed: () {
                                        if (controller
                                            .lstSelectedContact.isNotEmpty) {
                                          controller.addGuest();
                                        } else {
                                          RequestManager.getSnackToast(
                                              message: LabelKeys
                                                  .cBlankSelectContacts.tr);
                                        }
                                        /*Get.back();
                                    Get.back();*/
                                      },
                                    ),
                                  )
                                : Container()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
