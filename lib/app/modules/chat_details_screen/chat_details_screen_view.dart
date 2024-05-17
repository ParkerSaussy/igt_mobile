import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/app/models/message_model.dart';
import 'package:lesgo/app/modules/common_widgets/chat_bubble_with_tail.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/common_widgets/full_imag_view.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/app/services/firestore_services.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:lesgo/master/session/preference.dart';

import '../../../master/generic_class/image_picker.dart';
import 'chat_details_screen_controller.dart';

class ChatDetailsScreenView extends GetView<ChatDetailsScreenController> {
  const ChatDetailsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          for (int i = 0; i < controller.lstSelecetdMessages.length; i++) {
            FirebaseFirestore.instance
                .collection(FireStoreCollection.tripGroupCollection)
                .doc(controller.tripId.toString())
                .collection(FireStoreCollection.tripMessages)
                .doc(controller.lstSelecetdMessages[i].messageId)
                .update({FireStoreParams.isSelected: false});
          }
          gc.chatTripId.value = "";
          if (Preference.isGetNotification()) {
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            Get.back();
          }
          return true;
        },
        child: Scaffold(
          appBar: CustomAppBar.buildAppBar(
              leadingWidth: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              isCustomTitle: true,
              customTitleWidget: Obx(() => controller.isDetailsFetched.value
                  ? controller.isGroup.value == ChatType.singleChat
                      ? InkWell(
                          onTap: () {
                            for (int i = 0;
                                i < controller.lstSelecetdMessages.length;
                                i++) {
                              FirebaseFirestore.instance
                                  .collection(
                                      FireStoreCollection.tripGroupCollection)
                                  .doc(controller.tripId.toString())
                                  .collection(FireStoreCollection.tripMessages)
                                  .doc(controller
                                      .lstSelecetdMessages[i].messageId)
                                  .update({FireStoreParams.isSelected: false});
                            }
                            if (Preference.isGetNotification()) {
                              Get.offAllNamed(Routes.DASHBOARD);
                            } else {
                              Get.back();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                //top: AppDimens.paddingMedium,
                                bottom: AppDimens.paddingMedium,
                                right: AppDimens.paddingMedium),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(IconPath.backArrow),
                                const SizedBox(
                                  width: AppDimens.paddingMedium,
                                ),
                                Container(
                                  width: AppDimens.largeIconSize,
                                  height: AppDimens.largeIconSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppDimens.radiusCornerLarge),
                                  ),
                                  child: CommonNetworkImage(
                                    imageUrl: controller.receiverDetails!
                                        .get('profileImage'),
                                    radius: AppDimens.radiusCornerLarge,
                                  ),
                                ),
                                const SizedBox(
                                  width: AppDimens.paddingMedium,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.receiverDetails!.get('firstName') ?? ""} ${controller.receiverDetails!.get('lastName') ?? ""}",
                                      style: onBackGroundTextStyleMedium(
                                          fontSize: AppDimens.textLarge),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            for (int i = 0;
                                i < controller.lstSelecetdMessages.length;
                                i++) {
                              FirebaseFirestore.instance
                                  .collection(
                                      FireStoreCollection.tripGroupCollection)
                                  .doc(controller.tripId.toString())
                                  .collection(FireStoreCollection.tripMessages)
                                  .doc(controller
                                      .lstSelecetdMessages[i].messageId)
                                  .update({FireStoreParams.isSelected: false});
                            }
                            gc.chatTripId.value = "";
                            if (Preference.isGetNotification()) {
                              Get.offAllNamed(Routes.DASHBOARD);
                            } else {
                              Get.back();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: AppDimens.paddingMedium,
                                bottom: AppDimens.paddingMedium,
                                right: AppDimens.paddingMedium),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(IconPath.backArrow),
                                const SizedBox(
                                  width: AppDimens.paddingMedium,
                                ),
                                Container(
                                  width: AppDimens.largeIconSize,
                                  height: AppDimens.largeIconSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppDimens.radiusCornerLarge),
                                  ),
                                  child: CommonNetworkImage(
                                    imageUrl: controller.conversationListModel!
                                        .groupData!.groupImage,
                                    radius: AppDimens.radiusCornerLarge,
                                  ),
                                ),
                                const SizedBox(
                                  width: AppDimens.paddingMedium,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.conversationListModel!
                                          .groupData!.groupName,
                                      style: onBackGroundTextStyleMedium(
                                          fontSize: AppDimens.textLarge),
                                    ),
                                    Text(
                                        "${LabelKeys.guest.tr} (${controller.conversationListModel!.memberIds!.length})",
                                        style: onBackgroundTextStyleRegular(
                                            fontSize: AppDimens.textSmall))
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                  : const SizedBox()),
              actionWidget: [
                Obx(
                  () => controller.lstSelecetdMessages.value.isNotEmpty
                      ? Row(
                          children: [
                            /*controller.lstSelecetdMessages.length == 1
                                ? controller.lstSelecetdMessages[0]
                                            .messageType ==
                                        0
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (controller.lstSelecetdMessages[0]
                                                  .messageType ==
                                              0) {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: controller
                                                            .lstSelecetdMessages[
                                                                0]
                                                            .message ??
                                                        ''));
                                            controller.isLongPressEnables =
                                                false;
                                            FirebaseFirestore.instance
                                                .collection(FireStoreCollection
                                                    .tripGroupCollection)
                                                .doc(controller.tripId
                                                    .toString())
                                                .collection(FireStoreCollection
                                                    .tripMessages)
                                                .doc(controller
                                                    .lstSelecetdMessages[0]
                                                    .messageId)
                                                .update({
                                              FireStoreParams.isSelected: false
                                            });
                                            controller.lstSelecetdMessages
                                                .clear();
                                            controller.restorationId.value =
                                                getRandomString();
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              AppDimens.paddingMedium),
                                          child:
                                              SvgPicture.asset(IconPath.copy),
                                        ))
                                    : const SizedBox()
                                : const SizedBox(),*/
                            GestureDetector(
                                onTap: () {
                                  int isEnd = 0;
                                  if (controller.isGroup.value ==
                                      ChatType.singleChat) {
                                    for (int i = 0;
                                        i <
                                            controller
                                                .lstSelecetdMessages.length;
                                        i++) {
                                      FirebaseFirestore.instance
                                          .collection(FireStoreCollection
                                              .tripGroupCollection)
                                          .doc(controller.conversationId
                                              .toString())
                                          .collection(
                                              FireStoreCollection.tripMessages)
                                          .doc(controller
                                              .lstSelecetdMessages[i].messageId)
                                          .delete();
                                      isEnd++;
                                    }
                                  } else {
                                    for (int i = 0;
                                        i <
                                            controller
                                                .lstSelecetdMessages.length;
                                        i++) {
                                      FirebaseFirestore.instance
                                          .collection(FireStoreCollection
                                              .tripGroupCollection)
                                          .doc(controller.tripId.toString())
                                          .collection(
                                              FireStoreCollection.tripMessages)
                                          .doc(controller
                                              .lstSelecetdMessages[i].messageId)
                                          .delete();
                                      isEnd++;
                                    }
                                  }

                                  if (isEnd ==
                                      controller.lstSelecetdMessages.length) {
                                    controller.lstSelecetdMessages.clear();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      AppDimens.paddingMedium),
                                  child: SvgPicture.asset(IconPath.deleteIcon),
                                )),
                          ],
                        )
                      : const SizedBox(),
                )
              ]),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDimens.paddingSmall.ph,
                  Expanded(
                      child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppDimens.radiusCircle),
                        topRight: Radius.circular(AppDimens.radiusCircle)),
                    child: ContainerTopRoundedCorner(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 10, top: 0),
                              child: controller.isGroup.value ==
                                      ChatType.singleChat
                                  ? getMessages(
                                      controller.conversationId.toString())
                                  : getMessages(controller.tripId.toString()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: AppDimens.paddingExtraLarge,
                                bottom: AppDimens.paddingExtraLarge,
                                right: AppDimens.paddingExtraLarge),
                            child: CustomTextField(
                              maxLength: 600,
                              controller: controller.txtMessageController,
                              minLines: 1,
                              maxLines: 5,
                              focusNode: controller.messageFocus,
                              textCapitalization: TextCapitalization.sentences,
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Get.theme.colorScheme.onSecondary
                                            .withAlpha(
                                                Constants.transparentAlpha)),
                                    borderRadius: BorderRadius.circular(
                                        AppDimens.radiusCircle)),
                                isDense: true,
                                contentPadding: const EdgeInsets.all(
                                    AppDimens.paddingLarge),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Get.theme.colorScheme.onSecondary
                                            .withAlpha(
                                                Constants.transparentAlpha)),
                                    borderRadius: BorderRadius.circular(
                                        AppDimens.radiusCircle)),
                                hintText: LabelKeys.typeMessage.tr,
                                hintStyle: onBackgroundTextStyleRegular(
                                    alpha: Constants.lightAlfa,
                                    fontSize: AppDimens.textMedium),
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() =>
                                        MasterButtonsBounceEffect.iconButton(
                                            iconSize: AppDimens.normalIconSize,
                                            iconColor: controller
                                                    .showEmojiPicker.value
                                                ? Get.theme.colorScheme.primary
                                                : Colors.grey,
                                            bgColor: Colors.transparent,
                                            onPressed: () {
                                              Get.focusScope?.unfocus();
                                              if (controller
                                                  .showEmojiPicker.value) {
                                                controller.showEmojiPicker
                                                    .value = false;
                                              } else {
                                                controller.showEmojiPicker
                                                    .value = true;
                                              }
                                            },
                                            svgUrl: IconPath.smileyKeyIcon)),
                                    Container(
                                      width: 1,
                                      height: 20,
                                      color: Get.theme.colorScheme.onSecondary
                                          .withAlpha(
                                              Constants.transparentAlpha),
                                    )
                                  ],
                                ),
                                prefixIconConstraints:
                                    const BoxConstraints(maxHeight: 60),
                                suffixIconConstraints:
                                    const BoxConstraints(maxHeight: 60),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MasterButtonsBounceEffect.iconButton(
                                        bgColor: Colors.transparent,
                                        iconSize: AppDimens.normalIconSize,
                                        onPressed: () async {
                                          hideKeyboard();
                                          FGBGEvents.ignoreWhile(() async {
                                            controller.localImagePathListTemp =
                                            await CustomImagePicker
                                                .pickMultiImage();
                                            if (controller.localImagePathListTemp
                                                .isNotEmpty) {
                                              controller.addMemory();
                                            }
                                          });
                                        },
                                        svgUrl: IconPath.iconGallery),
                                    MasterButtonsBounceEffect.iconButton(
                                        iconSize: AppDimens.normalIconSize,
                                        bgColor: Colors.transparent,
                                        onPressed: () async {
                                          FGBGEvents.ignoreWhile(() async {
                                            final pickedImage =
                                                await CustomImagePicker
                                                    .pickImage(
                                                        source:
                                                            ImageSource.camera);
                                            if (pickedImage != '') {
                                              controller.localImagePathListTemp
                                                  .add(XFile(pickedImage));
                                              controller.addMemory();
                                            }
                                          });
                                        },
                                        svgUrl: IconPath.iconCamera),
                                    MasterButtonsBounceEffect.iconButton(
                                        iconSize: AppDimens.largeIconSize,
                                        bgColor: Colors.transparent,
                                        onPressed: () {
                                          print(
                                              "sdfjhsdfj111: ${controller.txtMessageController.text}");
                                          if (controller
                                              .txtMessageController.text
                                              .trim()
                                              .isNotEmpty) {
                                            if (controller.isGroup.value ==
                                                ChatType.singleChat) {
                                              controller
                                                  .sendMessageForSingleChat(
                                                      0, "", "", "");
                                            } else {
                                              controller
                                                  .sendMessageGroupMessage(
                                                      0, "", "", "");
                                            }
                                          }
                                        },
                                        svgUrl: IconPath.sendRoundWithGreenBg),
                                    //AppDimens.paddingSmall.pw,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(() => controller.showEmojiPicker.value
                              ? Expanded(child: buildSticker())
                              : const SizedBox())
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridItem(double width, String icon, String title) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.paddingMedium)),
            side: BorderSide(
                color: Get.theme.colorScheme.onSecondary
                    .withAlpha(Constants.transparentAlpha))),
        child: Padding(
          padding: const EdgeInsets.only(
              left: AppDimens.paddingSmall,
              right: AppDimens.paddingSmall,
              top: AppDimens.paddingMedium,
              bottom: AppDimens.paddingTiny),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              AppDimens.paddingMedium.ph,
              Text(
                '$title\n',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: onBackGroundTextStyleMedium(
                    fontSize: AppDimens.textTiny,
                    alpha: Constants.veryLightAlfa),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWidth() => ((Get.width - 49) / (4));

  Widget getMessages(docId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FireStoreCollection.tripGroupCollection)
          .doc(docId)
          .collection(FireStoreCollection.tripMessages)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center();
        }
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data!.docs.isNotEmpty) {
              controller.lstMessage.value =
                  MessageListModel.fromJson(snapshot.requireData.docs)
                      .conversationList;
              controller.lstMessage
                  .removeWhere((element) => element.timestamp == null);
              final newList = groupBy(
                  controller.lstMessage,
                  (p0) => Date.shared().readFirebaseTimestamp(p0.timestamp!,
                      format: 'dd MMMM yyyy'));
              //controller.scrollToBottom();
              return ListView.builder(
                itemCount: newList.length,
                reverse: true,
                itemBuilder: (context, indexFirst) {
                  String? category = newList.keys.elementAt(indexFirst);
                  List<MessageModel> itemsInCategory = newList[category]!;
                  return Column(
                    children: [
                      AppDimens.paddingMedium.ph,
                      Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          category,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      AppDimens.paddingMedium.ph,
                      ListView.builder(
                        itemCount: itemsInCategory.length,
                        controller: controller.scrollController,
                        reverse: true,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, indexTwo) {
                          MessageModel item = itemsInCategory[indexTwo];
                          return InkWell(
                            onTap: () {
                              if (controller.isLongPressEnables) {
                                if (item.senderId ==
                                    gc.loginData.value.id.toString()) {
                                  if (item.isSelected!) {
                                    item.isSelected = false;
                                    FirebaseFirestore.instance
                                        .collection(FireStoreCollection
                                            .tripGroupCollection)
                                        .doc(docId)
                                        .collection(
                                            FireStoreCollection.tripMessages)
                                        .doc(item.messageId)
                                        .update({
                                      FireStoreParams.isSelected: false
                                    });
                                    controller.lstSelecetdMessages.removeWhere(
                                        (element) =>
                                            element.messageId ==
                                            itemsInCategory[indexTwo]
                                                .messageId);
                                    controller.restorationId.value =
                                        getRandomString();
                                  } else {
                                    item.isSelected = true;
                                    FirebaseFirestore.instance
                                        .collection(FireStoreCollection
                                            .tripGroupCollection)
                                        .doc(docId)
                                        .collection(
                                            FireStoreCollection.tripMessages)
                                        .doc(item.messageId)
                                        .update(
                                            {FireStoreParams.isSelected: true});
                                    controller.lstSelecetdMessages.add(item);
                                    controller.restorationId.value =
                                        getRandomString();
                                  }
                                  if (controller.lstSelecetdMessages.isEmpty) {
                                    controller.isLongPressEnables = false;
                                    controller.lstSelecetdMessages.clear();
                                    controller.restorationId.value =
                                        getRandomString();
                                  }
                                }
                              } else {
                                if (item.messageType == 1) {
                                  //Get.toNamed(Routes.PREVIEW_CHAT_IMAGES, arguments: [item]);
                                  Get.to(HeroPhotoViewRouteWrapper(
                                      imageProvider: CachedNetworkImageProvider(
                                          item.message!)));
                                }
                              }
                            },
                            onLongPress: () {
                              if (item.senderId ==
                                  gc.loginData.value.id.toString()) {
                                if (item.isSelected!) {
                                  item.isSelected = false;
                                  FirebaseFirestore.instance
                                      .collection(FireStoreCollection
                                          .tripGroupCollection)
                                      .doc(docId)
                                      .collection(
                                          FireStoreCollection.tripMessages)
                                      .doc(item.messageId)
                                      .update(
                                          {FireStoreParams.isSelected: false});
                                  controller.lstSelecetdMessages.removeWhere(
                                      (element) =>
                                          element.messageId ==
                                          itemsInCategory[indexTwo].messageId);
                                } else {
                                  item.isSelected = true;
                                  FirebaseFirestore.instance
                                      .collection(FireStoreCollection
                                          .tripGroupCollection)
                                      .doc(docId)
                                      .collection(
                                          FireStoreCollection.tripMessages)
                                      .doc(item.messageId)
                                      .update(
                                          {FireStoreParams.isSelected: true});
                                  controller.lstSelecetdMessages.add(item);
                                }
                                controller.isLongPressEnables = true;
                                controller.restorationId.value =
                                    getRandomString();
                              }
                            },
                            child: Container(
                              color: item.isSelected!
                                  ? Get.theme.colorScheme.primary
                                      .withAlpha(Constants.veryLightAlfa)
                                  : Colors.transparent,
                              padding: EdgeInsets.only(
                                left: (item.senderId !=
                                        gc.loginData.value.id.toString())
                                    ? AppDimens.paddingMedium
                                    : AppDimens.paddingHuge,
                                right: (item.senderId ==
                                        gc.loginData.value.id.toString())
                                    ? AppDimens.paddingMedium
                                    : AppDimens.paddingHuge,
                              ),
                              child: Align(
                                alignment: ((item.senderId ==
                                        gc.loginData.value.id.toString())
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Column(
                                    crossAxisAlignment: (item.senderId !=
                                            gc.loginData.value.id.toString())
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection(FireStoreCollection
                                                .usersCollection)
                                            .doc(item.senderId)
                                            .snapshots(),
                                        builder: (context, snapshotUser) {
                                          if (snapshotUser.hasError) {
                                            return const Center();
                                          }
                                          if (snapshotUser.hasData) {
                                            return ChatBubbleWithTail(
                                              text: item.message ?? "",
                                              //seen: true,
                                              //delivered: true,
                                              replyWidget: Container(),
                                              messageType: item.messageType,
                                              messageModel: item,
                                              title:
                                                  "${snapshotUser.data!.get("firstName")} ${snapshotUser.data!.get("lastName")}",
                                              time: Date.shared()
                                                  .readFirebaseTimestamp(
                                                      item.timestamp!),
                                              isSender: item.senderId !=
                                                      gc.loginData.value.id
                                                          .toString()
                                                  ? false
                                                  : true,
                                              color: ((item.senderId !=
                                                      gc.loginData.value.id
                                                          .toString())
                                                  ? const Color(0xffEAF2FB)
                                                  : const Color(0xffFEDD9E)),
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ]),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
              );
            }
          }
        }
        return Container();
      },
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
      textEditingController: controller.txtMessageController,
      onEmojiSelected: (emoji, category) {
        printMessage(emoji);
      },
      config: Config(
        columns: 7,
        emojiSizeMax: 32 *
            (foundation.defaultTargetPlatform == TargetPlatform.iOS
                ? 1.30
                : 1.0),
        // Issue: https://github.com/flutter/flutter/issues/28894
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: const Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        recentTabBehavior: RecentTabBehavior.RECENT,
        recentsLimit: 28,
        noRecents: Text(
          LabelKeys.noRecent.tr,
          style: const TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
        // Needs to be const Widget
        loadingIndicator: const SizedBox.shrink(),
        // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
  }
}

/*
Get.bottomSheet(
isScrollControlled: true,
BottomSheetWithClose(
widget: Column(
children: [
AppDimens.paddingMedium.ph,
Row(
mainAxisAlignment:
MainAxisAlignment
    .spaceEvenly,
children: [
GestureDetector(
onTap: () {},
child: gridItem(
getWidth(),
IconPath.copyMix,
"Documents"),
),
GestureDetector(
onTap: () {
//onTripMemoriesTap();
},
child: gridItem(
getWidth(),
IconPath.cameraMix,
"Trip Memories"),
),
GestureDetector(
onTap: () {
//onContactTap();
},
child: gridItem(
getWidth(),
IconPath.userPlusMix,
"Contact"),
)
],
),
AppDimens.paddingMedium.ph,
Row(
mainAxisAlignment:
MainAxisAlignment
    .spaceEvenly,
children: [
GestureDetector(
onTap: () {
//onMapViewTap();
},
child: gridItem(
getWidth(),
IconPath.locationMix,
"Map View"),
),
GestureDetector(
onTap: () {
//onGalleryTap();
},
child: gridItem(
getWidth(),
IconPath.galleryMix,
"Gallery"),
),
SizedBox(
width: getWidth(),
)
],
),
AppDimens.paddingExtraLarge.ph,
],
),
),
);
*/
