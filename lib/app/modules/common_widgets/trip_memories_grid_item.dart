import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

class TripMemoriesGridItem extends StatelessWidget {
  const TripMemoriesGridItem(
      {Key? key,
      required this.tripMemoriesImageModel,
      required this.onTap,
      required this.onLongPress})
      : super(key: key);

  final dynamic tripMemoriesImageModel;
  final Function onTap;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      onLongPress: () {
        onLongPress();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Get.theme.colorScheme.onBackground
                  .withAlpha(Constants.transparentAlpha),
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.radiusCornerLarge))),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: tripMemoriesImageModel.image,
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
              Positioned(
                bottom: AppDimens.paddingLarge,
                left: AppDimens.paddingSmall,
                child: Text(
                  tripMemoriesImageModel.location ?? '',
                  style: onPrimaryTextStyleMedium(),
                ),
              ),
              tripMemoriesImageModel.isSelected
                  ? Container(
                      width: Get.width,
                      height: Get.height,
                      padding: const EdgeInsets.all(43),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(AppDimens.radiusCornerLarge)),
                      ),
                      child: SvgPicture.asset(
                        IconPath.check,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
