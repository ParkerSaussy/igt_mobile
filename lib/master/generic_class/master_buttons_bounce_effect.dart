import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/constants.dart';
import '../general_utils/text_styles.dart';

class MasterButtonsBounceEffect {
  /// flutter_bounce: required for bouncy effect
  static Color primaryColor = Get.theme.colorScheme.primary;
  static Color primaryContainerColor = Get.theme.colorScheme.primaryContainer;
  static Color disabledColor = Get.theme.disabledColor;
  static Color disabledIconColor =
      Get.theme.colorScheme.surface.withAlpha(Constants.lightAlfa);
  static TextStyle disabledTextStyle = onPrimaryTextStyleSemiBold();

  /// This will generate [flatButton],[raisedButton]
  static Widget colorButton({
    double? height,
    double? elevation,
    Color? buttonColor,
    double? borderRadius,
    TextStyle? textStyles,
    Function? onPressed,
    Function? disabledPressed,
    bool disabled = false,
    required String btnText,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: SizedBox(
        height: height ?? AppDimens.buttonHeight,
        child: Card(
          elevation: disabled ? 0 : (elevation ?? 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          color: disabled ? disabledColor : buttonColor ?? primaryColor,
          child: Center(
            child: Text(
              btnText,
              style: disabled
                  ? disabledTextStyle
                  : textStyles ?? onPrimaryTextStyleMedium(),
            ),
          ),
        ),
      ),
    );
  }

  /// This will generate [flatButton],[raisedButton] With Icon
  static Widget iconColorButton({
    double? height,
    double? elevation,
    Color? buttonColor,
    double? borderRadius,
    TextStyle? textStyles,
    required String iconPath,
    Color? iconColor,
    Function? disabledPressed,
    bool disabled = false,
    Function? onPressed,
    required String btnText,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: SizedBox(
        height: height ?? AppDimens.buttonHeight,
        child: Card(
          surfaceTintColor: Colors.transparent,
          elevation: disabled ? 0 : elevation ?? 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          color: disabled ? disabledColor : buttonColor ?? primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath,
                    colorFilter: disabled
                        ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                        : iconColor != null
                            ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                            : null),
                AppDimens.paddingSmall.pw,
                Text(
                  btnText,
                  style: disabled
                      ? disabledTextStyle
                      : textStyles ??
                          onPrimaryTextStyleMedium(
                              fontSize: AppDimens.textMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// This will generate [textButton]
  static Widget textButton({
    double? height,
    Color? textColor,
    //double? width,   // Remove comment when custom size is required.
    TextStyle? textStyles,
    Function? onPressed,
    Function? disabledPressed,
    bool disabled = false,
    required String btnText,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: SizedBox(
        height: height ?? AppDimens.buttonHeight,
        child: TextButton(
          onPressed: null,
          child: Text(
            btnText,
            style: disabled
                ? disabledTextStyle
                : textStyles ??
                    onPrimaryTextStyleMedium(fontSize: AppDimens.textMedium),
          ),
        ),
      ),
    );
  }

  /// This will generate [textButton With Icon]
  static Widget textButtonWithIcon({
    double? height,
    Color? textColor,
    Color? iconColor,
    double? borderRadius,
    //double? width,   // Remove comment when custom size is required.
    TextStyle? textStyles,
    Function? onPressed,
    Function? disabledPressed,
    bool disabled = false,
    required String iconPath,
    required String btnText,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: SizedBox(
        height: height ?? AppDimens.buttonHeight,
        //width: width ?? double.infinity,
        child: TextButton.icon(
          icon: SvgPicture.asset(iconPath,
              colorFilter: disabled
                  ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                  : iconColor != null
                      ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                      : null),
          onPressed: null,
          label: Text(
            btnText,
            style: disabled
                ? disabledTextStyle
                : textStyles ??
                    primaryTextStyleSemiBold(fontSize: AppDimens.textMedium),
          ),
          style: ButtonStyle(
              //backgroundColor: MaterialStateProperty.all(darkHugeButtonColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 0)))),
        ),
      ),
    );
  }

  /// This will generate [IconButton With Text], [onPressed] will work for icon only
  static Widget iconButtonWithText({
    required String svgUrl,
    double? height,
    Color? iconColor,
    double? borderRadius,
    Color? borderColor,
    double? borderSize,
    Color? bgColor,
    double? iconPadding,
    Function? disabledPressed,
    bool disabled = false,
    required String title,
    Color? background,
    Function? onPressed,
    TextStyle? textStyle,
  }) {
    return Bounce(
      duration: Duration(
          milliseconds: disabled ? 0 : Constants.bounceDurationIconButtons),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: Container(
        height: height ?? AppDimens.buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? AppDimens.radiusButton)),
          color: disabled
              ? disabledColor
              : (bgColor ?? Get.theme.colorScheme.surface),
          border: Border.all(
            color: disabled
                ? disabledColor
                : borderColor ?? (bgColor ?? Get.theme.colorScheme.surface),
            width: borderSize ?? 0,
          ),
        ),
        padding: EdgeInsets.all(iconPadding ?? AppDimens.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgUrl,
                colorFilter: disabled
                    ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                    : iconColor != null
                        ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                        : null),
            AppDimens.paddingMedium.pw,
            Text(
              title,
              style: disabled
                  ? onSurfaceTextStyleSemiBold(
                      fontSize: AppDimens.textLarge, alpha: Constants.lightAlfa)
                  : textStyle ??
                      onBackgroundTextStyleSemiBold(
                          fontSize: AppDimens.textLarge,
                          alpha: Constants.darkAlfa),
            ),
          ],
        ),
      ),
    );
  }

  /// This will generate [IconButton]
  static Widget iconButton({
    required String svgUrl,
    //double? height,
    Color? iconColor,
    double? borderRadius,
    Color? borderColor,
    double? borderSize,
    Color? bgColor,
    Function? disabledPressed,
    bool disabled = false,
    double? iconPadding,
    double? iconSize,
    Function? onPressed,
  }) {
    return Bounce(
      duration: Duration(
          milliseconds: disabled ? 0 : Constants.bounceDurationIconButtons),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: Container(
        // alignment: Alignment.center,
        //height: height ?? AppDimens.buttonHeight,
        //width: height ?? AppDimens.buttonHeight,
        decoration: BoxDecoration(
          //shape: BoxShape.circle,
          borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? AppDimens.radiusButton)),
          color: disabled
              ? disabledColor
              : bgColor ?? Get.theme.colorScheme.surface,
          border: Border.all(
            color: disabled
                ? disabledColor
                : borderColor ?? (bgColor ?? Get.theme.colorScheme.surface),
            width: disabled ? 0 : borderSize ?? 0,
          ),
        ),
        padding: EdgeInsets.all(iconPadding ?? AppDimens.paddingSmall),

        child: SvgPicture.asset(svgUrl,
            fit: BoxFit.cover,
            height: iconSize ?? AppDimens.smallIconSize,
            width: iconSize ?? AppDimens.smallIconSize,
            colorFilter: disabled
                ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                : iconColor != null
                    ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                    : null),
      ),
    );
  }

  /// Gradiant Button
  static Widget gradiantButton({
    double? height,
    List<Color>? gradiantColors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    required String btnText,
    TextStyle? textStyles,
    Function? disabledPressed,
    bool disabled = false,
    Function? onPressed,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: Container(
        height: height ?? AppDimens.buttonHeight,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDimens.radiusButton),
          gradient: LinearGradient(
            colors: disabled
                ? [
                    disabledColor,
                    disabledColor,
                  ]
                : gradiantColors ??
                    [
                      primaryContainerColor,
                      primaryColor,
                    ],
            stops: const [0.0, 0.7],
            begin: begin ?? Alignment.bottomLeft,
            end: end ?? Alignment.topRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Text(
              btnText,
              style: disabled
                  ? disabledTextStyle
                  : textStyles ??
                      onPrimaryTextStyleMedium(fontSize: AppDimens.textLarge),
            ),
          ),
        ),
      ),
    );
  }

  ///
  static Widget gradiantButtonWithIcon({
    required String svgUrl,
    double? height,
    Color? iconColor,
    List<Color>? gradiantColors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double? borderRadius,
    required String btnText,
    TextStyle? textStyles,
    Function? disabledPressed,
    bool disabled = false,
    Function? onPressed,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: Container(
        height: height ?? AppDimens.buttonHeight,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDimens.radiusButton),
          gradient: LinearGradient(
            colors: disabled
                ? [
                    disabledColor,
                    disabledColor,
                  ]
                : gradiantColors ??
                    [
                      primaryContainerColor,
                      primaryColor,
                    ],
            //stops: const [0.0, 0.8],
            begin: begin ?? Alignment.bottomLeft,
            end: end ?? Alignment.topRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svgUrl,
                colorFilter: disabled
                    ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                    : iconColor != null
                        ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                        : null),
            AppDimens.paddingSmall.pw,
            Text(
              btnText.toUpperCase(),
              style: disabled
                  ? disabledTextStyle
                  : textStyles ??
                      onPrimaryTextStyleMedium(fontSize: AppDimens.textMedium),
            ),
          ],
        ),
      ),
    );
  }

  ///
  static Widget floatingButtonGradient({
    required String svgUrl,
    bool disabled = false,
    bool isMini = false,
    Color? iconColor,
    Function? onPressed,
    double? elevation,
    List<Color>? gradiantColors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double? borderRadius,
    String? tooltipText,
  }) {
    return Bounce(
      duration: Duration(
          milliseconds: disabled ? 0 : Constants.bounceDurationIconButtons),
      onPressed: () =>
          disabled ? null : (onPressed != null ? {onPressed()} : {}),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 50),
            boxShadow: [
              BoxShadow(
                color: elevation == 0
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.5),
                offset: Offset(0, elevation ?? 0),
                blurRadius: 6,
              ),
            ],
            gradient: LinearGradient(
              colors: disabled
                  ? [
                      disabledColor,
                      disabledColor,
                    ]
                  : gradiantColors ??
                      [
                        primaryContainerColor,
                        primaryColor,
                      ],
              //stops: const [0.0, 0.8],
              begin: begin ?? Alignment.bottomLeft,
              end: end ?? Alignment.topRight,
            ),
          ),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.transparent,
            onPressed: null,
            tooltip: tooltipText,
            mini: isMini,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 50),
            ),
            child: SvgPicture.asset(svgUrl,
                colorFilter: disabled
                    ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                    : iconColor != null
                        ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                        : null),
          ),
        ),
      ),
    );
  }

  ///
  static Widget gradientFABExtended({
    String? svgUrl,
    bool disabled = false,
    Color? iconColor,
    List<Color>? gradiantColors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double? size,
    Function? onPressed,
    double? elevation,
    double? borderRadius,
    double? height,
    String? tooltipText,
    required String labelText,
    TextStyle? textStyles,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () =>
          disabled ? null : (onPressed != null ? {onPressed()} : {}),
      child: Container(
        width: Get.width,
        height: height ?? AppDimens.buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(0, elevation ?? 2),
              blurRadius: 6,
            ),
          ],
          gradient: LinearGradient(
            colors: disabled
                ? [
                    disabledColor,
                    disabledColor,
                  ]
                : gradiantColors ??
                    [
                      primaryContainerColor,
                      primaryColor,
                    ],
            //stops: const [0.0, 0.8],
            begin: begin ?? Alignment.bottomLeft,
            end: end ?? Alignment.topRight,
          ),
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 50),
          ),
          onPressed: null,
          tooltip: tooltipText,
          label: Row(
            children: [
              if (svgUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(svgUrl,
                      colorFilter: disabled
                          ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                          : iconColor != null
                              ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                              : null),
                )
              else
                const SizedBox(),
              FittedBox(
                child: Center(
                  child: Text(
                    labelText,
                    style: disabled
                        ? disabledTextStyle
                        : textStyles ??
                            onPrimaryTextStyleSemiBold(
                                fontSize: AppDimens.textLarge),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  static Widget gradiantButtonWithRightIcon({
    required String svgUrl,
    double? height,
    double? width,
    Color? iconColor,
    List<Color>? gradiantColors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    double? borderRadius,
    required String btnText,
    TextStyle? textStyles,
    Function? disabledPressed,
    bool disabled = false,
    Function? onPressed,
  }) {
    return Bounce(
      duration: Duration(milliseconds: disabled ? 0 : Constants.bounceDuration),
      onPressed: () => disabled
          ? {
              (disabledPressed != null ? {disabledPressed()} : {})
            }
          : (onPressed != null ? {onPressed()} : {}),
      child: Container(
        height: height ?? AppDimens.buttonHeight,
        width: width ?? AppDimens.buttonHeight,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppDimens.radiusButton),
          gradient: LinearGradient(
            colors: disabled
                ? [
                    disabledColor,
                    disabledColor,
                  ]
                : gradiantColors ??
                    [
                      primaryContainerColor,
                      primaryColor,
                    ],
            //stops: const [0.0, 0.8],
            begin: begin ?? Alignment.bottomLeft,
            end: end ?? Alignment.topRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  btnText,
                  style: disabled
                      ? disabledTextStyle
                      : textStyles ??
                          onPrimaryTextStyleSemiBold(
                              fontSize: AppDimens.textMedium),
                ),
              ),
            ),
            AppDimens.paddingSmall.pw,
            SvgPicture.asset(svgUrl,
                colorFilter: disabled
                    ? ColorFilter.mode(disabledIconColor, BlendMode.srcIn)
                    : iconColor != null
                        ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                        : null),
            AppDimens.paddingLarge.pw,
          ],
        ),
      ),
    );
  }
}
