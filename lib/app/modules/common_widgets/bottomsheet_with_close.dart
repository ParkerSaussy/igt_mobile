import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/images_path.dart';
import 'container_top_rounded_corner.dart';

class BottomSheetWithClose extends StatelessWidget {
  const BottomSheetWithClose(
      {super.key, this.titleWidget, required this.widget, this.onClose});

  final Widget? titleWidget;
  final Widget widget;
  final Function? onClose;
  @override
  Widget build(BuildContext context) {
    return ContainerTopRoundedCorner(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(IconPath.bottomHorizontalLine),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: AppDimens.paddingMedium,
                  left: AppDimens.paddingMedium,
                  right: AppDimens.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  titleWidget == null
                      ? const SizedBox()
                      : Expanded(child: titleWidget!),
                  GestureDetector(
                    onTap: () {
                      printMessage("message");
                      onClose != null ? {onClose!()} : Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingSmall),
                      child: SvgPicture.asset(
                        IconPath.closeRoundedIcon,
                        height: AppDimens.normalIconSize,
                        width: AppDimens.normalIconSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget,
          ],
        ),
      ),
    );
  }
}
