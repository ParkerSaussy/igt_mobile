import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/app/modules/common_widgets/select_display_image_gridview.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/image_picker.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';

import '../../common_widgets/bottomsheet_with_close.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import '../../common_widgets/upload_image_bottomsheet.dart';
import 'select_trip_image_controller.dart';

class SelectTripImageView extends GetView<SelectTripImageController> {
  const SelectTripImageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            isCustomTitle: true,
            customTitleWidget: CustomAppBar.backButton()),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingExtraLarge,
                    right: AppDimens.paddingExtraLarge),
                child: Text(
                  LabelKeys.selectADisplayImage.tr,
                  style: onBackGroundTextStyleMedium(
                      fontSize: AppDimens.textExtraLarge),
                ),
              ),
              AppDimens.paddingXXLarge.ph,
              Expanded(
                child: ContainerTopRoundedCorner(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(AppDimens.paddingExtraLarge),
                          child: Obx(
                            () => controller.lstTripCoverImage.value.isNotEmpty
                                ? SelectDisplayImageListView(
                                    onTap: (index) {
                                      controller.selectedIndex.value = index;
                                      controller.selectedPreImage.value =
                                          controller
                                              .lstTripCoverImage[controller
                                                  .selectedIndex.value]
                                              .imageName!;
                                      controller.restorationId.value =
                                          getRandomString();
                                    },
                                    restorationId:
                                        controller.restorationId.value,
                                    lstTripCoverImage:
                                        controller.lstTripCoverImage.value,
                                    selectedIndex:
                                        controller.selectedIndex.value,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppDimens.paddingExtraLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LabelKeys.uploadedPhone.tr,
                                style: onBackGroundTextStyleMedium(
                                    fontSize: AppDimens.textLarge),
                              ),
                              Text(
                                LabelKeys.uploadedImageMsg.tr,
                                style: onBackGroundTextStyleMedium(
                                    fontSize: AppDimens.textSmall,
                                    alpha: Constants.veryLightAlfa),
                              ),
                            ],
                          ),
                        ),
                        AppDimens.paddingMedium.ph,
                        Obx(() => controller.imageSelected.value != ""
                            ? GestureDetector(
                                onTap: () {
                                  controller.selectedIndex.value = -1;
                                  controller.restorationId.value =
                                      getRandomString();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppDimens.paddingExtraLarge,
                                      right: AppDimens.paddingExtraLarge),
                                  child: Container(
                                    width: 120,
                                    //height: 160,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: controller.selectedIndex.value ==
                                                -1
                                            ? Get.theme.colorScheme.primary
                                            : Get.theme.colorScheme.onBackground
                                                .withAlpha(
                                                    Constants.transparentAlpha),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimens.radiusCornerLarge))),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 160,
                                          width: Get.width,
                                          child: CachedNetworkImage(
                                            imageUrl: controller
                                                .uploadedImageName.value,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                        .all(
                                                    Radius.circular(AppDimens
                                                        .radiusCornerLarge)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8,
                                          top: 8,
                                          child: MasterButtonsBounceEffect
                                              .iconButton(
                                                  svgUrl:
                                                      IconPath.deleteRedWhite,
                                                  iconSize:
                                                      AppDimens.normalIconSize,
                                                  borderRadius: 6,
                                                  iconPadding: 0,
                                                  onPressed: () {
                                                    Get.bottomSheet(
                                                      isScrollControlled: true,
                                                      BottomSheetWithClose(
                                                          widget:
                                                              deleteImageBottomSheet()),
                                                    );
                                                  }),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Get.bottomSheet(
                                    isScrollControlled: true,
                                    BottomSheetWithClose(
                                      widget: UploadImageBottomSheet(
                                        onGalleryTap: () async {
                                          Get.back();
                                          FGBGEvents.ignoreWhile(() async {
                                            final file =
                                            await CustomImagePicker.pickImage(
                                              source: ImageSource.gallery,
                                              isSelectMultipleImage: false,
                                              aspectRatio: const CropAspectRatio(
                                                  ratioX: 21, ratioY: 9),
                                            );
                                            if (file != "") {
                                              File selectedImage = File(file);
                                              controller.uploadTripImages(
                                                  selectedFile: selectedImage);
                                            }
                                          });
                                        },
                                        onCameraTap: () async {
                                          Get.back();
                                          FGBGEvents.ignoreWhile(() async {
                                            final file =
                                            await CustomImagePicker.pickImage(
                                              source: ImageSource.camera,
                                              aspectRatio: const CropAspectRatio(
                                                  ratioX: 23, ratioY: 9),
                                            );
                                            if (file != "") {
                                              File selectedImage = File(file);
                                              controller.uploadTripImages(
                                                  selectedFile: selectedImage);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppDimens.paddingExtraLarge,
                                      right: AppDimens.paddingExtraLarge),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    color: Get.theme.colorScheme.onBackground
                                        .withAlpha(Constants.limit),
                                    radius: const Radius.circular(12),
                                    padding: EdgeInsets.zero,
                                    dashPattern: const [3, 2],
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      child: Container(
                                        color: Get
                                            .theme.colorScheme.onBackground
                                            .withAlpha(Constants.limit),
                                        height: 160,
                                        width: 140,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height:
                                                  AppDimens.paddingExtraLarge,
                                            ),
                                            SvgPicture.asset(IconPath.shareMix),
                                            const SizedBox(
                                              height:
                                                  AppDimens.paddingExtraLarge,
                                            ),
                                            Text(
                                              LabelKeys.uploadPhoto.tr,
                                              style:
                                                  onBackgroundTextStyleRegular(
                                                      fontSize:
                                                          AppDimens.textLarge,
                                                      alpha:
                                                          Constants.lightAlfa),
                                            ),
                                            Text(
                                              LabelKeys.uploadPhotoSize.tr,
                                              textAlign: TextAlign.center,
                                              style:
                                                  onBackgroundTextStyleRegular(
                                                      fontSize:
                                                          AppDimens.textSmall,
                                                      alpha:
                                                          Constants.lightAlfa),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        AppDimens.padding90.ph,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          decoration: const BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.paddingExtraLarge,
              right: AppDimens.paddingExtraLarge,
            ),
            child: MasterButtonsBounceEffect.gradiantButton(
              onPressed: () {
                if (controller.selectedIndex.value == -1) {
                  if (controller.uploadedImageName.value.isNotEmpty) {
                    Get.back(result: controller.uploadedImageName.value);
                  } else {
                    Get.back(result: "");
                  }
                } else {
                  Get.back(result: controller.selectedPreImage.value);
                }
              },
              btnText: LabelKeys.lastStep.tr,
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteImageBottomSheet() {
    return Column(
      children: [
        AppDimens.paddingLarge.ph,
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(IconPath.iconDeletePlaceHolder),
        ),
        AppDimens.paddingLarge.ph,
        Text(
          LabelKeys.deleteThisMsg.tr,
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        AppDimens.paddingLarge.ph,
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingLarge),
                  child: MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.yes.tr,
                    onPressed: () {
                      controller.selectedImageBytes = null;
                      controller.uploadedImageName.value = "";
                      controller.imageSelected.value = "";
                      Get.back();
                    },
                  )),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingLarge),
                child: MasterButtonsBounceEffect.gradiantButton(
                  btnText: LabelKeys.no.tr,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
        AppDimens.paddingExtraLarge.ph,
      ],
    );
  }
}
