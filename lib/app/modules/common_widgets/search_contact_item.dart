import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/search_contact_model.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

class SearchContactItem extends StatelessWidget {
  const SearchContactItem(
      {Key? key,
      required this.selectedContact,
      required this.onGuestTap,
      required this.onVipTap,
      required this.onCoHostTap})
      : super(key: key);

  //final Widget popupMenu;
  final SearchContactModel selectedContact;
  final Function onGuestTap;
  final Function onVipTap;
  final Function onCoHostTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1,
              color: Get.theme.colorScheme.onBackground
                  .withAlpha(Constants.limit)),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.radiusCorner)),
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
                  Stack(children: [
                    SizedBox(
                      width: 60,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.paddingTiny),
                          child: selectedContact.photo != null
                              ? Image.memory(
                                  selectedContact.photo!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  ImagesPath.placeHolderPng,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    selectedContact.isSelected
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: SvgPicture.asset(IconPath.userRightGreenBg))
                        : Container()
                  ]),
                  const SizedBox(
                    width: AppDimens.paddingMedium,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedContact.name.first,
                                style: onBackGroundTextStyleMedium(
                                    fontSize: AppDimens.textLarge),
                              ),
                            ),
                            popupMenu(),
                          ],
                        ),
                        Text(
                          selectedContact.phones.isNotEmpty
                              ? selectedContact.phones[0].number
                              : '',
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.lightAlfa),
                        ),
                        Text(
                          selectedContact.emails[0].address,
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textMedium,
                              alpha: Constants.lightAlfa),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: AppDimens.paddingMedium,
            ),
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
              child: itemMenu(
                  LabelKeys.guest.tr,
                  selectedContact.selectedRole == LabelKeys.guest.tr
                      ? true
                      : false),
            ),
            PopupMenuItem(
              //height: AppDimens.paddingLarge,
              value: 2,
              onTap: () {
                onVipTap();
              },
              child: itemMenu(
                  LabelKeys.vip.tr,
                  selectedContact.selectedRole == LabelKeys.vip.tr
                      ? true
                      : false),
            ),
            PopupMenuItem(
              value: 3,
              onTap: () {
                onCoHostTap();
              },
              child: itemMenu(LabelKeys.coHost.tr, selectedContact.isCoHost),
            ),
          ],
          child: SvgPicture.asset(
            IconPath.moreIcon,
            height: AppDimens.normalIconSize,
            width: AppDimens.normalIconSize,
          ),
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
