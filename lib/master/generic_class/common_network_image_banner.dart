import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/images_path.dart';

class CommonNetworkImageBanner extends StatefulWidget {
  const CommonNetworkImageBanner(
      {super.key,
      this.imageUrl,
      this.height,
      this.width,
      this.radius,
      this.errorImage,
      this.placeholderWidget});

  final String? imageUrl;
  final double? height;
  final double? width;
  final double? radius;
  final String? errorImage;
  final Widget? placeholderWidget;

  @override
  _CommonNetworkImageBannerState createState() =>
      _CommonNetworkImageBannerState();
}

class _CommonNetworkImageBannerState extends State<CommonNetworkImageBanner> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(widget.radius ?? AppDimens.radiusButton),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(widget.radius ?? AppDimens.radiusButton),
          ),
        ),
        child: ((widget.imageUrl ?? '').isEmpty)
            ? SvgPicture.asset(
                IconPath.placeHolderSvg,
                fit: BoxFit.cover,
                height: widget.height ?? 100,
                width: widget.width ?? double.infinity,
              )
            : CachedNetworkImage(
                imageUrl: widget.imageUrl ?? "",
                fit: BoxFit.cover,
                height: widget.height ?? 100,
                width: widget.width ?? double.infinity,
                placeholder: (context, url) =>
                    widget.placeholderWidget ??
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(
                          widget.radius ?? AppDimens.radiusButton),
                      child: SvgPicture.asset(
                        widget.errorImage ?? IconPath.placeHolderSvg,
                        fit: BoxFit.cover,
                      ),
                    ),
                errorWidget: (context, url, error) => SvgPicture.asset(
                    IconPath.placeHolderSvg,
                    fit: BoxFit.cover),
              ),
      ),
    );
  }
}

/*
class CommonImage extends StatelessWidget {
  const CommonImage({this.imageUrl, this.height, this.width});
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
        progressIndicatorBuilder: (context, url, downloadProgress) =>Image.asset(ImagesPath.avatar, color: lightPrimaryColor, fit: BoxFit.fill),
        errorWidget: (context, url, error) =>Image.asset(ImagesPath.avatar, fit: BoxFit.fill));
  }
}*/
