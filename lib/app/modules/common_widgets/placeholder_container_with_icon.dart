import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/text_styles.dart';

class PlaceholderContainerWithIcon extends StatelessWidget {
  const PlaceholderContainerWithIcon(
      {super.key,
      required this.widget,
      this.titleName,
      this.iconPath,
      this.endWidget,
      this.titleTextStyle});

  final String? titleName;
  final Widget widget;
  final Widget? endWidget;
  final String? iconPath;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.paddingMedium),
          border: Border.all(color: Get.theme.dividerColor),
          boxShadow: [
            BoxShadow(
              color: Get.theme.dividerColor,
              blurRadius: 1.0,
            ),
          ]),
      padding: const EdgeInsets.all(AppDimens.paddingMedium),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            iconPath != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: SvgPicture.asset(
                      iconPath!,
                      height: AppDimens.normalIconSize,
                      width: AppDimens.normalIconSize,
                      colorFilter: ColorFilter.mode(
                          Get.theme.colorScheme.primary, BlendMode.srcIn),
                    ),
                  )
                : const SizedBox(),
            AppDimens.paddingLarge.pw,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleName == null
                        ? const SizedBox()
                        : Text(
                            titleName!,
                            style: titleTextStyle ??
                                onBackGroundTextStyleMedium(
                                    fontSize: AppDimens.textLarge),
                          ),
                    widget
                  ],
                ),
              ),
            ),
            endWidget ?? const SizedBox()
          ],
        ),
      ),
    );
  }
}
