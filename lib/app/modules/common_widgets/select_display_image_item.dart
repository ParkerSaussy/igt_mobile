import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/constants.dart';

import '../../models/trip_cover_images_model.dart';

class SelectDisplayImageItem extends StatelessWidget {
  const SelectDisplayImageItem(
      {Key? key,
      required this.onTap,
      required this.selectedIndex,
      required this.index,
      required this.tripCoverImages})
      : super(key: key);

  final Function onTap;
  final int selectedIndex;
  final int index;
  final TripCoverImages tripCoverImages;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //controller.selectedIndex = index;
        //controller.restorationId.value = getRandomString();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: selectedIndex == index
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.onBackground
                      .withAlpha(Constants.transparentAlpha),
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.radiusCornerLarge))),
          child: CachedNetworkImage(
            imageUrl: tripCoverImages.imageName!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppDimens.radiusCornerLarge)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
