import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../master/general_utils/app_dimens.dart';

class BottomRoundedContainer extends StatelessWidget {
  const BottomRoundedContainer(
      {super.key, this.bgColor, this.bottomBorderRadius, this.height});

  final Color? bgColor;
  final double? bottomBorderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppDimens.bottomRoundedContainerHeight,
      decoration: BoxDecoration(
          color: bgColor ?? Get.theme.colorScheme.primary,
          borderRadius: BorderRadius.only(
              bottomLeft:
                  Radius.circular(bottomBorderRadius ?? AppDimens.radiusCircle),
              bottomRight: Radius.circular(
                  bottomBorderRadius ?? AppDimens.radiusCircle))),
    );
  }
}
