import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/images_path.dart';

class CommonNetworkImage extends StatelessWidget {
  const CommonNetworkImage({
    super.key,
    this.imageUrl,
    this.height,
    this.width,
    this.radius,
    this.errorImage,
    this.boxFit,
    this.borderRadius,
    this.placeholderWidget,
    this.errorWidget,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final double? radius;
  final String? errorImage;
  final BoxFit? boxFit;
  final BorderRadius? borderRadius;
  final Widget? placeholderWidget;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      fit: boxFit ?? BoxFit.fill,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ??
              BorderRadius.circular(radius ?? AppDimens.radiusButton),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      height: height ?? AppDimens.userProfileSize,
      width: width ?? AppDimens.userProfileSize,
      placeholder: (context, url) =>
          placeholderWidget ??
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius:
                BorderRadius.circular(radius ?? AppDimens.radiusButton),
            child: SvgPicture.asset(
              errorImage ?? IconPath.placeHolderSvg,
              fit: BoxFit.cover,
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius:
                  BorderRadius.circular(radius ?? AppDimens.radiusButton),
              child: SvgPicture.asset(errorImage ?? IconPath.placeHolderSvg,
                  fit: BoxFit.cover)),
    );
  }
}

class CommonImage extends StatelessWidget {
  const CommonImage({super.key, this.imageUrl, this.height, this.width});

  final String? imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        height: height,
        width: width,
        imageUrl: imageUrl ?? "",
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Image.asset(ImagesPath.sampleProfileImage,
                color: Get.theme.colorScheme.primary, fit: BoxFit.fill),
        errorWidget: (context, url, error) =>
            Image.asset(ImagesPath.sampleProfileImage, fit: BoxFit.fill));
  }
}
