import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';

import 'preview_trip_memories_controller.dart';

class PreviewTripMemoriesView extends GetView<PreviewTripMemoriesController> {
  const PreviewTripMemoriesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: CustomAppBar.buildAppBar(
              elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.light),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(
                  () => Stack(
                    children: [
                      controller.lstTripMemoriesImage.isNotEmpty
                          ? PageView.builder(
                              controller: controller.pageController,
                              itemCount: controller.lstTripMemoriesImage.length,
                              onPageChanged: (value) {
                                controller.currentIndex.value = value;
                              },
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: controller
                                          .lstTripMemoriesImage[
                                              controller.currentIndex.value]
                                          .image ??
                                      "",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            AppDimens.radiusCornerLarge),
                                        bottomRight: Radius.circular(
                                            AppDimens.radiusCornerLarge),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Container(),
                      Positioned(
                        left: 15,
                        top: 40,
                        child: CustomAppBar.backButton(
                            textStyle: onPrimaryTextStyleMedium(),
                            iconColor: Colors.white),
                      ),
                      Positioned(
                        bottom: 230,
                        //left: -20,
                        child: GestureDetector(
                          onTap: () {
                            controller.onPrevious();
                          },
                          child: SvgPicture.asset(
                            IconPath.iconLeftArrow,
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 230,
                        right: 0,
                        //left: -20,
                        child: GestureDetector(
                          onTap: () {
                            controller.onNext();
                          },
                          child: SvgPicture.asset(
                            IconPath.iconRightArrow,
                            fit: BoxFit.none,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: AppDimens.paddingExtraLarge,
                        left: AppDimens.paddingExtraLarge,
                        child: Text(
                          controller
                                  .lstTripMemoriesImage[
                                      controller.currentIndex.value]
                                  .location ??
                              "",
                          style: onPrimaryTextStyleMedium(),
                        ),
                      ),
                      Obx(() => controller
                                  .lstTripMemoriesImage[
                                      controller.currentIndex.value]
                                  .getActivityName !=
                              null
                          ? Positioned(
                              bottom: AppDimens.paddingExtraLarge,
                              right: AppDimens.paddingExtraLarge,
                              child: Text(
                                controller
                                        .lstTripMemoriesImage[
                                            controller.currentIndex.value]
                                        .getActivityName!
                                        .name ??
                                    "",
                                style: onPrimaryTextStyleMedium(),
                              ),
                            )
                          : Container())
                    ],
                  ),
                ),
              ),
              AppDimens.paddingLarge.ph,
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(
                      bottom: AppDimens.paddingHuge,
                      left: AppDimens.paddingMedium),
                  child: Text(
                    controller
                            .lstTripMemoriesImage[controller.currentIndex.value]
                            .caption ??
                        "",
                    style: onBackgroundTextStyleRegular(
                      fontSize: AppDimens.textLarge,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
