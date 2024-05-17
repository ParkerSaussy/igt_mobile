import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/images_path.dart';

class LesgoAppbarLogo extends StatelessWidget {
  LesgoAppbarLogo({
    super.key,
    this.svgImagePath,
    this.padding,
    this.height,
  });

  String? svgImagePath;
  EdgeInsetsGeometry? padding;
  double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.only(
              top: AppDimens.paddingMedium, bottom: AppDimens.paddingHuge),
      child: Align(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          svgImagePath ?? ImagesPath.lesGoLogoSvg,
          height: height ?? AppDimens.headerLogoHeight,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
