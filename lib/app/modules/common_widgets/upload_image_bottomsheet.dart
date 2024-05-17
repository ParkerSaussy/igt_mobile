import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/images_path.dart';
import '../../../master/general_utils/label_key.dart';
import '../../../master/general_utils/text_styles.dart';

class UploadImageBottomSheet extends StatelessWidget {
  const UploadImageBottomSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  final Function onGalleryTap;
  final Function onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () {
            onGalleryTap();
          },
          child: Row(
            children: [
              SvgPicture.asset(IconPath.iconGallery),
              const SizedBox(
                width: AppDimens.paddingMedium,
              ),
              Text(LabelKeys.gallery.tr,
                  style: onBackgroundTextStyleSemiBold(
                      fontSize: AppDimens.textMedium))
            ],
          ),
        ),
        const SizedBox(
          height: AppDimens.paddingMedium,
        ),
        const Divider(),
        const SizedBox(
          height: AppDimens.paddingMedium,
        ),
        TextButton(
          onPressed: () {
            onCameraTap();
          },
          child: Row(
            children: [
              SvgPicture.asset(IconPath.iconCamera),
              const SizedBox(
                width: AppDimens.paddingMedium,
              ),
              Text(LabelKeys.takePicture.tr,
                  style: onBackgroundTextStyleSemiBold())
            ],
          ),
        ),
        AppDimens.paddingExtraLarge.ph,
      ],
    );
  }
}
