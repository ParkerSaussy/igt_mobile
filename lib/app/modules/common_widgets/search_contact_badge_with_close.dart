import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/search_contact_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/text_styles.dart';
import '../../../master/generic_class/common_network_image.dart';

class SearchContactBadgeWithClose extends StatelessWidget {
  const SearchContactBadgeWithClose({
    super.key,
    this.radius,
    this.size,
    required this.searchContactModel,
    required this.onRemoveTap,
    required this.isTripFinalized,
    /*this.model*/
  });
  final double? radius;
  final double? size;
  final SearchContactModel searchContactModel;
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
              child: searchContactModel.photo == null ||
                  searchContactModel.photo == ""
                  ? Center(
                  child: Text(
                    getInitials(
                        "${searchContactModel.name.first}")
                        .toUpperCase(),
                    style: onPrimaryTextStyleSemiBold(
                      /*fontSize: AppDimens.textSmall*/),
                  ))
                  : CommonNetworkImage(
                height: size ?? AppDimens.storyImgHeight,
                width: size ?? AppDimens.storyImgHeight,
                radius: radius ?? AppDimens.radiusCircle,
                imageUrl: searchContactModel.photo.toString(),
              ),
            ),
            isTripFinalized || searchContactModel.selectedRole == Role.host
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
