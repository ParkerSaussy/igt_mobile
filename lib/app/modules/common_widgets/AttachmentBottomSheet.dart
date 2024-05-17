import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({
    Key? key,
    required this.onDocumentTap,
    required this.onTripMemoriesTap,
    required this.onContactTap,
    required this.onMapViewTap,
    required this.onGalleryTap,
  }) : super(key: key);
  final Function onDocumentTap;
  final Function onTripMemoriesTap;
  final Function onContactTap;
  final Function onMapViewTap;
  final Function onGalleryTap;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ContainerTopRoundedCorner(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 2.5,
                  width: 35,
                  color: Colors.grey,
                ),
              ),
              AppDimens.paddingVerySmall.ph,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      IconPath.closeRoundedIcon,
                      width: AppDimens.smallIconSize,
                      height: AppDimens.smallIconSize,
                    )),
              ),
              AppDimens.paddingMedium.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      onDocumentTap();
                    },
                    child: gridItem(
                        getWidth(), IconPath.copyMix, LabelKeys.documents.tr),
                  ),
                  GestureDetector(
                    onTap: () {
                      onTripMemoriesTap();
                    },
                    child: gridItem(getWidth(), IconPath.cameraMix,
                        LabelKeys.tripMemories.tr),
                  ),
                  GestureDetector(
                    onTap: () {
                      onContactTap();
                    },
                    child: gridItem(
                        getWidth(), IconPath.userPlusMix, LabelKeys.contact.tr),
                  )
                ],
              ),
              AppDimens.paddingMedium.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      onMapViewTap();
                    },
                    child: gridItem(
                        getWidth(), IconPath.locationMix, LabelKeys.mapView.tr),
                  ),
                  GestureDetector(
                    onTap: () {
                      onGalleryTap();
                    },
                    child: gridItem(
                        getWidth(), IconPath.galleryMix, LabelKeys.gallery.tr),
                  ),
                  SizedBox(
                    width: getWidth(),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget gridItem(double width, String icon, String title) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Get.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.paddingMedium)),
            side: BorderSide(
                color: Get.theme.colorScheme.onSecondary
                    .withAlpha(Constants.transparentAlpha))),
        child: Padding(
          padding: const EdgeInsets.only(
              left: AppDimens.paddingSmall,
              right: AppDimens.paddingSmall,
              top: AppDimens.paddingMedium,
              bottom: AppDimens.paddingTiny),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              AppDimens.paddingMedium.ph,
              Text(
                '$title\n',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: onBackGroundTextStyleMedium(
                    fontSize: AppDimens.textTiny,
                    alpha: Constants.veryLightAlfa),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWidth() => ((Get.width - 49) / (4));
}
