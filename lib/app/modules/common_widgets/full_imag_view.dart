import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:photo_view/photo_view.dart';

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    super.key,
    required this.imageProvider,
  });

  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.buildAppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leadingWidget: Padding(
            padding: const EdgeInsets.only(left: AppDimens.paddingExtraLarge),
            child: CustomAppBar.backButton(
                textStyle: onPrimaryTextStyleRegular(),
                iconColor: Get.theme.colorScheme.onPrimary),
          ),
          leadingWidth: 100),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: Center(
                child: PhotoView(
                  minScale: PhotoViewComputedScale.contained * 1.0,
                  imageProvider: imageProvider,
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                ),
              ),
            ),
            // Positioned(
            //   left: 15,
            //   top: 40,
            //   child: CustomAppBar.backButton(
            //       textStyle: onPrimaryTextStyleMedium(),
            //       iconColor: Colors.white),
            // ),
          ],
        ),
      ),
    );
  }
}
