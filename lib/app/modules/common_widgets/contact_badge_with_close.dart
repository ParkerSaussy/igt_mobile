import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/text_styles.dart';
import '../../../master/generic_class/common_network_image.dart';

class ContactBadgeWithClose extends StatelessWidget {
  const ContactBadgeWithClose({
    super.key,
    this.radius,
    this.size,
    required this.addedGuestModel,
    required this.onRemoveTap,
    required this.isTripFinalized,
    /*this.model*/
  });
  final double? radius;
  final double? size;
  final AddedGuestmodel addedGuestModel;
  final Function onRemoveTap;
  final bool isTripFinalized;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: size ?? AppDimens.storyImgHeight,
              width: size ?? AppDimens.storyImgHeight,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.primary,
                borderRadius: BorderRadius.all(
                    Radius.circular(radius ?? AppDimens.radiusCircle)),
              ),
              child: addedGuestModel.profilePicture == null ||
                      addedGuestModel.profilePicture == ""
                  ? Center(
                      child: Text(
                      getInitials(
                              "${addedGuestModel.firstName ?? ""} ${addedGuestModel.lastName ?? ""}")
                          .toUpperCase(),
                      style: onPrimaryTextStyleSemiBold(
                          /*fontSize: AppDimens.textSmall*/),
                    ))
                  : CommonNetworkImage(
                      height: size ?? AppDimens.storyImgHeight,
                      width: size ?? AppDimens.storyImgHeight,
                      radius: radius ?? AppDimens.radiusCircle,
                      imageUrl: addedGuestModel.profilePicture,
                    ),
            ),
            isTripFinalized /*|| addedGuestModel.role == Role.host*/
                ? const SizedBox()
                : Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        onRemoveTap();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.surfaceVariant
                              .withAlpha(Constants.mediumAlfa),
                          border: Border.all(
                              color: Get.theme.colorScheme.surfaceTint),
                          borderRadius: BorderRadius.all(Radius.circular(
                              radius ?? AppDimens.radiusCircle)),
                        ),
                        child: SvgPicture.asset(
                          IconPath.iconCloseIcon,
                          colorFilter: ColorFilter.mode(
                              Get.theme.colorScheme.onBackground,
                              BlendMode.srcIn),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ],
    );
  }
}
