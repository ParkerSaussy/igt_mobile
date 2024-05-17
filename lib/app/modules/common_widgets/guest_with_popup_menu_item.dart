import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../../master/generic_class/common_network_image.dart';

class GuestWithPopupMenuItem extends StatelessWidget {
  const GuestWithPopupMenuItem({
    Key? key,
    required this.onGuestTap,
    required this.onVIPTap,
    required this.onCoHostTap,
    required this.addedGuestModel,
    required this.onSendTap,
    required this.onResendTap,
    required this.onRemoveTap,
    required this.isHostOrCoHost,
    required this.isTripFinalized,
    required this.onChatTapped,
  }) : super(key: key);

  final Function onGuestTap;
  final Function onVIPTap;
  final Function onCoHostTap;
  final AddedGuestmodel addedGuestModel;
  final Function onSendTap;
  final Function onResendTap;
  final Function onRemoveTap;
  final bool isHostOrCoHost;
  final bool isTripFinalized;
  final Function onChatTapped;

  @override
  Widget build(BuildContext context) {
    return addedGuestModel.role != Role.host
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    width: 1,
                    color: Get.theme.colorScheme.onBackground
                        .withAlpha(Constants.limit)),
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppDimens.radiusCorner)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingMedium,
                        right: AppDimens.paddingMedium,
                        top: AppDimens.paddingMedium),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Image.asset(ImagesPath.sampleProfileImage),
                        CommonNetworkImage(
                          height: 70,
                          width: 55,
                          radius: 12,
                          imageUrl: addedGuestModel.profilePicture,
                        ),
                        const SizedBox(
                          width: AppDimens.paddingMedium,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      addedGuestModel.firstName ?? "",
                                      style: onBackGroundTextStyleMedium(
                                          fontSize: AppDimens.textLarge),
                                    ),
                                    const SizedBox(
                                      width: AppDimens.paddingMedium,
                                    ),
                                    Row(
                                      children: [
                                        addedGuestModel.role == "Guest"
                                            ? Container()
                                            : Container(
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffDFDBF8),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            AppDimens
                                                                .radiusCircle))),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        AppDimens.paddingXLarge,
                                                        AppDimens
                                                            .paddingVerySmall,
                                                        AppDimens.paddingXLarge,
                                                        AppDimens
                                                            .paddingVerySmall),
                                                child: Text(
                                                  addedGuestModel.role ?? "",
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff22279F), // TODO
                                                      fontSize:
                                                          AppDimens.textSmall,
                                                      fontFamily: Font
                                                          .poppins500Medium),
                                                ),
                                              ),
                                        AppDimens.paddingVerySmall.pw,
                                        addedGuestModel.isCoHost!
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffDFDBF8),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            AppDimens
                                                                .radiusCircle))),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        AppDimens.paddingXLarge,
                                                        AppDimens
                                                            .paddingVerySmall,
                                                        AppDimens.paddingXLarge,
                                                        AppDimens
                                                            .paddingVerySmall),
                                                child: Text(
                                                  LabelKeys.coHost.tr,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff22279F), // TODO
                                                      fontSize:
                                                          AppDimens.textSmall,
                                                      fontFamily: Font
                                                          .poppins500Medium),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                addedGuestModel.phoneNumber ?? "",
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textMedium,
                                    alpha: Constants.lightAlfa),
                              ),
                              Text(
                                addedGuestModel.emailId ?? "",
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textMedium,
                                    alpha: Constants.lightAlfa),
                              )
                            ],
                          ),
                        ),
                        isHostOrCoHost ? popupMenu() : const SizedBox()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppDimens.paddingMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingSmall,
                        right: AppDimens.paddingSmall),
                    child: Container(
                      width: Get.width,
                      height: 1,
                      color: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.limit),
                    ),
                  ),
                  const SizedBox(
                    height: AppDimens.paddingSmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingMedium,
                        right: AppDimens.paddingMedium,
                        bottom: AppDimens.paddingMedium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isHostOrCoHost
                            ? addedGuestModel.inviteStatus ==
                                    InviteStatus.notSent
                                ? Row(
                                    children: [
                                      MasterButtonsBounceEffect.gradiantButton(
                                          height: 40,
                                          padding: const EdgeInsets.only(
                                              left: AppDimens.paddingMedium,
                                              right: AppDimens.paddingMedium),
                                          borderRadius: AppDimens.radiusCorner,
                                          gradiantColors: [
                                            Get.theme.colorScheme.primary,
                                            Get.theme.colorScheme.primary
                                          ],
                                          btnText: LabelKeys.sendInvite.tr,
                                          onPressed: () {
                                            onSendTap();
                                          }),
                                      AppDimens.paddingVerySmall.pw,
                                      PopupMenuButton(
                                        elevation: 10,
                                        padding: const EdgeInsets.only(
                                          right: 0,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    AppDimens.paddingMedium))),
                                        icon: SvgPicture.asset(IconPath.info),
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              value: 'info',
                                              child: Text(
                                                LabelKeys.noteSendInvitation.tr,
                                                style:
                                                    onBackgroundTextStyleRegular(
                                                        fontSize:
                                                            AppDimens.textSmall,
                                                        alpha: Constants
                                                            .lightAlfa),
                                              ),
                                            ),
                                          ];
                                        },
                                      )
                                    ],
                                  )
                                : Text(
                                    addedGuestModel.inviteStatus ==
                                            InviteStatus.approved
                                        ? LabelKeys.itsGoTime.tr
                                        : addedGuestModel.inviteStatus!,
                                    style: TextStyle(
                                        //TODO
                                        color: addedGuestModel.inviteStatus ==
                                                InviteStatus.declined
                                            ? Get.theme.colorScheme.error
                                            : Get.theme.colorScheme.primary,
                                        fontSize: AppDimens.textLarge,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: Font.poppins500Medium),
                                  )
                            : const SizedBox(),
                        addedGuestModel.uId != 0
                            ? addedGuestModel.inviteStatus ==
                                    InviteStatus.declined
                                ? const SizedBox()
                                : gc.loginData.value.id == addedGuestModel.uId!
                                    ? const SizedBox()
                                    : MasterButtonsBounceEffect.iconButton(
                                        iconSize: AppDimens.normalIconSize,
                                        onPressed: () {
                                          onChatTapped();
                                        },
                                        svgUrl: IconPath.chatIconMix,
                                      )
                            : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Padding(
            // Host Detail display
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Get.theme.colorScheme.onBackground
                      .withAlpha(Constants.limit),
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppDimens.radiusCorner)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppDimens.paddingMedium,
                        right: AppDimens.paddingMedium,
                        top: AppDimens.paddingMedium),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Image.asset(ImagesPath.sampleProfileImage),
                        CommonNetworkImage(
                          height: 70,
                          width: 55,
                          radius: 12,
                          imageUrl: addedGuestModel.profilePicture,
                        ),
                        const SizedBox(
                          width: AppDimens.paddingMedium,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      addedGuestModel.firstName ?? "",
                                      style: onBackGroundTextStyleMedium(
                                          fontSize: AppDimens.textLarge),
                                    ),
                                    const SizedBox(
                                      width: AppDimens.paddingMedium,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xffDFDBF8),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      AppDimens.radiusCircle))),
                                          padding: const EdgeInsets.fromLTRB(
                                              AppDimens.paddingXLarge,
                                              AppDimens.paddingVerySmall,
                                              AppDimens.paddingXLarge,
                                              AppDimens.paddingVerySmall),
                                          child: Text(
                                            addedGuestModel.role ?? "",
                                            style: TextStyle(
                                                color: const Color(
                                                    0xff22279F), // TODO
                                                fontSize: AppDimens.textSmall,
                                                fontFamily:
                                                    Font.poppins500Medium),
                                          ),
                                        ),
                                        AppDimens.paddingVerySmall.pw,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                addedGuestModel.phoneNumber ?? "",
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textMedium,
                                    alpha: Constants.lightAlfa),
                              ),
                              Text(
                                addedGuestModel.emailId ?? "",
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textMedium,
                                    alpha: Constants.lightAlfa),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppDimens.paddingMedium,
                  ),
                  gc.loginData.value.id == addedGuestModel.uId!
                      ? const SizedBox()
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppDimens.paddingSmall,
                                  right: AppDimens.paddingSmall),
                              child: Container(
                                width: Get.width,
                                height: 1,
                                color: Get.theme.colorScheme.onBackground
                                    .withAlpha(Constants.limit),
                              ),
                            ),
                            const SizedBox(
                              height: AppDimens.paddingSmall,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: AppDimens.paddingMedium,
                                  right: AppDimens.paddingMedium,
                                  bottom: AppDimens.paddingMedium),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: MasterButtonsBounceEffect.iconButton(
                                  iconSize: AppDimens.normalIconSize,
                                  onPressed: () {
                                    onChatTapped();
                                  },
                                  svgUrl: IconPath.chatIconMix,
                                ),
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
          );
  }

  Widget popupMenu() => Theme(
        data: ThemeData(cardColor: Colors.white),
        child: PopupMenuButton<int>(
          elevation: 2,
          shadowColor: Colors.black,
          offset: const Offset(-22, 0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(AppDimens.radiusCornerSmall))),
          itemBuilder: (context) => [
            PopupMenuItem(
              //height: AppDimens.paddingMedium,
              value: 1,
              onTap: () {
                onGuestTap();
              },
              child: itemMenu(LabelKeys.guest.tr,
                  addedGuestModel.role == LabelKeys.guest.tr ? true : false),
            ),
            PopupMenuItem(
              //height: AppDimens.paddingLarge,
              value: 2,
              onTap: () {
                onVIPTap();
              },
              child: itemMenu(LabelKeys.vip.tr,
                  addedGuestModel.role == LabelKeys.vip.tr ? true : false),
            ),
            PopupMenuItem(
              //height: AppDimens.paddingMedium,
              value: 3,
              onTap: () {
                onCoHostTap();
              },
              child: itemMenu(LabelKeys.coHost.tr, addedGuestModel.isCoHost!),
            ),
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              enabled: false,
              child: Divider(
                color: Get.theme.colorScheme.outline
                    .withAlpha(Constants.lightAlfa),
              ),
            ),
            PopupMenuItem(
              enabled: isTripFinalized
                  ? false
                  : addedGuestModel.inviteStatus == InviteStatus.sent ||
                          addedGuestModel.inviteStatus == InviteStatus.declined
                      ? true
                      : false,
              value: 4,
              onTap: () {
                onResendTap();
              },
              child: Text(
                LabelKeys.resendInvite.tr,
                style: isTripFinalized
                    ? primaryTextStyleRegular(fontSize: AppDimens.textMedium)
                        .copyWith(color: Get.theme.disabledColor)
                    : addedGuestModel.inviteStatus == InviteStatus.sent ||
                            addedGuestModel.inviteStatus ==
                                InviteStatus.declined
                        ? primaryTextStyleRegular(
                            fontSize: AppDimens.textMedium)
                        : primaryTextStyleRegular(
                                fontSize: AppDimens.textMedium)
                            .copyWith(color: Get.theme.disabledColor),
              ),
            ),
            PopupMenuItem(
              enabled: isTripFinalized ? false : true,
              value: 5,
              onTap: () {
                onRemoveTap();
              },
              child: Text(
                LabelKeys.remove.tr,
                style: isTripFinalized
                    ? primaryTextStyleRegular(fontSize: AppDimens.textMedium)
                        .copyWith(color: Get.theme.disabledColor)
                    : TextStyle(
                        color: const Color(0xffCC0E36),
                        fontFamily: Font.poppins400Regular,
                        fontSize: AppDimens.textMedium), //TODO
              ),
            ),
          ],
          child: SvgPicture.asset(IconPath.moreIcon),
        ),
      );

  Widget itemMenu(String title, bool isChecked) {
    return Row(
      children: [
        SvgPicture.asset(isChecked ? IconPath.check : IconPath.unCheck),
        AppDimens.paddingSmall.pw,
        Text(title,
            style: onBackGroundTextStyleMedium(fontSize: AppDimens.textMedium)),
      ],
    );
  }
}
