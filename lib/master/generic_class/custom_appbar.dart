import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/images_path.dart';
import '../general_utils/text_styles.dart';

class CustomAppBar {
  static buildAppBar({
    Widget? leadingWidget,
    bool automaticallyImplyLeading = false,
    String title = '',
    Color? backgroundColor,
    double? elevation,
    List<Widget>? actionWidget,
    bool? centerTitle,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool? isCustomTitle = false,
    Widget? customTitleWidget,
    PreferredSizeWidget? bottomWidet,
    double? leadingWidth,
  }) {
    return AppBar(
      leading: leadingWidget,
      scrolledUnderElevation: 0,
      leadingWidth: leadingWidth,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: isCustomTitle!
          ? customTitleWidget
          : Text(
              title,
              maxLines: 2,
              style: secondaryTextStyleSemiBold(
                fontSize: AppDimens.textLarge,
              ),
            ),
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      actions: actionWidget,
      centerTitle: centerTitle ?? false,
      bottom: bottomWidet,
    );
  }

  static backButton(
      {Function? onBack,
      TextStyle? textStyle,
      Color? iconColor,
      String? backText}) {
    return InkWell(
      onTap: () => (onBack != null ? {onBack()} : {Get.back()}),
      child: Padding(
        padding: const EdgeInsets.only(
            top: AppDimens.paddingMedium,
            bottom: AppDimens.paddingMedium,
            right: AppDimens.paddingMedium),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              IconPath.backArrow,
              colorFilter:
                  ColorFilter.mode(iconColor ?? Colors.black, BlendMode.srcIn),
            ),
            const SizedBox(
              width: AppDimens.paddingMedium,
            ),
            Text(
              backText ?? "Back",
              style: textStyle ?? onBackgroundTextStyleRegular(),
            )
          ],
        ),
      ),
    );
  }
}
