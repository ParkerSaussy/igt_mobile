import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

import '../general_utils/app_dimens.dart';
import 'master_buttons_bounce_effect.dart';

class MyCustomAppBar extends StatelessWidget {
  final String? title,
      fontName,
      strLeftIconName,
      rightIconOne,
      rightIconTwo,
      rightIconThree;
  final int? fontSize;
  final Color? fontColor, lefIconColor, leftIconBorderColor, leftIconBgColor;
  Color? backgroundColor = Get.context!.theme.colorScheme.background;
  Color? iconColor;
  final double? elevation, borderRadius;
  bool? isBorderVisible = false;
  bool? isNotOnlyTitle = false;
  final VoidCallback? onPressedLeftIcon,
      onPressedRightIcon,
      rightIconOneClick,
      rightIconTwoClick,
      rightIconThreeClick;
  final Brightness? brightness;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? iconSize;

  MyCustomAppBar(
      {Key? key,
      this.title,
      this.fontName,
      this.strLeftIconName,
      this.fontSize,
      this.fontColor,
      this.backgroundColor,
      this.lefIconColor,
      this.elevation,
      this.onPressedLeftIcon,
      this.onPressedRightIcon,
      this.brightness,
      this.systemOverlayStyle,
      this.rightIconOne,
      this.rightIconTwo,
      this.rightIconThree,
      this.rightIconOneClick,
      this.iconColor,
      this.isBorderVisible,
      this.rightIconTwoClick,
      this.isNotOnlyTitle,
      this.rightIconThreeClick,
      this.borderRadius,
      this.leftIconBorderColor,
      this.leftIconBgColor,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle =
        onBackgroundTextStyleSemiBold(fontSize: AppDimens.textLarge);
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingSmall,
            vertical: AppDimens.paddingTiny),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            strLeftIconName == null
                ? const SizedBox()
                : MasterButtonsBounceEffect.iconButton(
                    bgColor: leftIconBgColor ?? Colors.transparent,
                    borderColor: leftIconBorderColor ?? Colors.transparent,
                    svgUrl: strLeftIconName!,
                    onPressed: onPressedLeftIcon,
                    borderRadius: borderRadius,
                  ),
            AppDimens.paddingMedium.pw,
            InkWell(
              onTap: onPressedLeftIcon,
              child: Text(title ?? "", style: textStyle),
            ),
            const Spacer(),
            rightIconThree != null
                ? getImage(
                    imageName: rightIconThree, onTap: rightIconThreeClick)
                : const SizedBox(),
            rightIconTwo != null
                ? getImage(imageName: rightIconTwo, onTap: rightIconTwoClick)
                : const SizedBox(),
            rightIconOne != null
                ? getImage(
                    imageName: rightIconOne,
                    onTap: rightIconOneClick,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget getImage({String? imageName, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimens.paddingMedium),
      child: MasterButtonsBounceEffect.iconButton(
        bgColor: Get.theme.colorScheme.background,
        iconPadding: 10,
        iconSize: iconSize ?? AppDimens.normalIconSize,
        svgUrl: imageName!,
        onPressed: onTap,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
