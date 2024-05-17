import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/custom_dropdown.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:lesgo/master/generic_class/image_picker.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';

import '../../common_widgets/bottomsheet_with_close.dart';
import 'add_new_photos_controller.dart';

class AddNewPhotosView extends GetView<AddNewPhotosController> {
  const AddNewPhotosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar.buildAppBar(
          isCustomTitle: true,
          customTitleWidget: CustomAppBar.backButton(),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: AppDimens.paddingExtraLarge),
                  child: Text(
                    LabelKeys.addNewPhoto.tr,
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textExtraLarge),
                  ),
                ),
                AppDimens.paddingMedium.ph,
                Expanded(
                  child: ContainerTopRoundedCorner(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: AppDimens.paddingExtraLarge,
                          right: AppDimens.paddingExtraLarge,
                          top: AppDimens.paddingXXLarge),
                      child: Form(
                        key: controller.addNewPhotoKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 160,
                                      child: Obx(() => controller
                                              .refreshString.value.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: controller
                                                      .localImagePathList
                                                      .length +
                                                  1,
                                              scrollDirection: Axis.horizontal,
                                              restorationId: controller
                                                  .refreshString.value,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return index != 0
                                                    ? imageCardView(
                                                        controller
                                                            .localImagePathList[
                                                                index - 1]
                                                            .path,
                                                        index)
                                                    : InkWell(
                                                        onTap: () {
                                                          Get.bottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              BottomSheetWithClose(
                                                                widget:
                                                                    uploadImageBottomSheet(),
                                                                titleWidget:
                                                                    Text(
                                                                  LabelKeys
                                                                      .selectPhotos
                                                                      .tr,
                                                                  style: onBackgroundTextStyleSemiBold(
                                                                      fontSize:
                                                                          AppDimens
                                                                              .textLarge),
                                                                ),
                                                              ));
                                                        },
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .onBackground
                                                              .withAlpha(
                                                                  Constants
                                                                      .limit),
                                                          radius: const Radius
                                                              .circular(12),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          dashPattern: const [
                                                            3,
                                                            2
                                                          ],
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12)),
                                                            child: Container(
                                                              color: const Color(
                                                                  0xffFAFCFE),
                                                              height: 160,
                                                              width: 140,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                      IconPath
                                                                          .shareMix),
                                                                  const SizedBox(
                                                                    height: AppDimens
                                                                        .paddingLarge,
                                                                  ),
                                                                  Text(
                                                                    "Upload Photo",
                                                                    style: onBackgroundTextStyleRegular(
                                                                        fontSize:
                                                                            AppDimens
                                                                                .textLarge,
                                                                        alpha: Constants
                                                                            .lightAlfa),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                              })
                                          : Container()),
                                    ),
                                    /*SizedBox(
                                      height: 160,
                                      child: Obx(() => controller
                                                  .imageSelected.value !=
                                              ""
                                          ? imageCardView(
                                              controller.imageSelected.value)
                                          : InkWell(
                                              onTap: () {
                                                Get.bottomSheet(
                                                    isScrollControlled: true,
                                                    BottomSheetWithClose(
                                                      widget:
                                                          uploadImageBottomSheet(),
                                                      titleWidget: Text(
                                                        LabelKeys
                                                            .selectPhotos.tr,
                                                        style: onBackgroundTextStyleSemiBold(
                                                            fontSize: AppDimens
                                                                .textLarge),
                                                      ),
                                                    ));
                                              },
                                              child: DottedBorder(
                                                borderType: BorderType.RRect,
                                                color: Get.theme.colorScheme
                                                    .onBackground
                                                    .withAlpha(Constants.limit),
                                                radius:
                                                    const Radius.circular(12),
                                                padding: EdgeInsets.zero,
                                                dashPattern: const [3, 2],
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                  child: Container(
                                                    color:
                                                        const Color(0xffFAFCFE),
                                                    height: 160,
                                                    width: 140,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            IconPath.shareMix),
                                                        const SizedBox(
                                                          height: AppDimens
                                                              .paddingLarge,
                                                        ),
                                                        Text(
                                                          LabelKeys
                                                              .uploadPhoto.tr,
                                                          style: onBackgroundTextStyleRegular(
                                                              fontSize: AppDimens
                                                                  .textLarge,
                                                              alpha: Constants
                                                                  .lightAlfa),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                    ),*/
                                    AppDimens.paddingExtraLarge.ph,
                                    CustomTextField(
                                      keyBoardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      controller: controller.captionController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        return null;
                                        /*return CustomTextField
                                            .validatorFunction(
                                                value!,
                                                ValidationTypes.other,
                                                LabelKeys
                                                    .cBlankAddTripPhotosCaption
                                                    .tr);*/
                                      },
                                      inputDecoration:
                                          CustomTextField.prefixSuffixOnlyIcon(
                                        border: const UnderlineInputBorder(),
                                        labelText: LabelKeys.caption.tr,
                                        labelStyle:
                                            onBackgroundTextStyleRegular(
                                                alpha: Constants.lightAlfa),
                                        isDense: true,
                                      ),
                                    ),
                                    AppDimens.paddingExtraLarge.ph,
                                    CustomTextField(
                                      keyBoardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      controller: controller.locationController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        return null;
                                        /*return CustomTextField
                                            .validatorFunction(
                                                value!,
                                                ValidationTypes.other,
                                                LabelKeys
                                                    .cBlankAddTripPhotosLocation
                                                    .tr);*/
                                      },
                                      inputDecoration:
                                          CustomTextField.prefixSuffixOnlyIcon(
                                        border: const UnderlineInputBorder(),
                                        labelText: LabelKeys.location.tr,
                                        labelStyle:
                                            onBackgroundTextStyleRegular(
                                                alpha: Constants.lightAlfa),
                                        isDense: true,
                                      ),
                                    ),
                                    AppDimens.paddingExtraLarge.ph,
                                    Obx(() => CustomDropDown(
                                          onTap: () {
                                            Get.focusScope?.unfocus();
                                          },
                                          labelText:
                                              LabelKeys.selectActivity.tr,
                                          options: controller.lstActivity.value,
                                          value: controller.selectedActivity,
                                          isExpanded: false,
                                          isDense: true,
                                          onChanged: (value) {
                                            controller.selectedActivity = value;
                                            controller.selectedValue.value =
                                                value!.name!;
                                            controller.selectedValueId.value =
                                                value.id!;
                                            printMessage(controller
                                                .selectedValueId.value);
                                          },
                                          /*validator: (value) {
                                            if (value == null ||
                                                value.toString().isEmpty) {
                                              return LabelKeys.cBlankAddTripPhotosSelectActivity.tr;
                                            }
                                            return null;
                                          },*/
                                          icon: SvgPicture.asset(
                                              IconPath.downArrow),
                                          getLabel: (value) => value!.name!,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            MasterButtonsBounceEffect.gradiantButton(
                                btnText: LabelKeys.save.tr,
                                onPressed: () {
                                  if (controller.addNewPhotoKey.currentState!
                                      .validate()) {
                                    controller.localImagePathList.clear();
                                    controller.addMemory();
                                  }
                                }),
                            AppDimens.paddingMedium.ph
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadImageBottomSheet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () async {
            Get.back();
            Get.focusScope?.unfocus();
            controller.localImagePathListTemp =
                await CustomImagePicker.pickMultiImage();
            if (controller.localImagePathListTemp.isNotEmpty) {
              controller.localImagePathList =
                  await CustomImagePicker.compressAndConvertImages(
                      controller.localImagePathListTemp);
              printMessage(
                  "fileImages: ${controller.localImagePathListTemp.length}");
              controller.refreshString.value = getRandomString();
            }
          },
          child: Row(
            children: [
              SvgPicture.asset(IconPath.iconGallery),
              const SizedBox(
                width: AppDimens.paddingMedium,
              ),
              Text(LabelKeys.gallery.tr,
                  style: onBackgroundTextStyleSemiBold(
                      fontSize: AppDimens.textMedium))
            ],
          ),
        ),
        const SizedBox(
          height: AppDimens.paddingMedium,
        ),
        const Divider(),
        const SizedBox(
          height: AppDimens.paddingMedium,
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            Get.focusScope?.unfocus();
            FGBGEvents.ignoreWhile(() async {
              final file =
                  await CustomImagePicker.pickImage(source: ImageSource.camera);
              if (file != "") {
                printMessage("file: $file");
                controller.localImagePathListTemp.add(XFile(file));
                controller.localImagePathList.add(File(file));
                printMessage("fileIma: ${controller.localImagePathListTemp}");
                controller.refreshString.value = getRandomString();
              }
            });
          },
          child: Row(
            children: [
              SvgPicture.asset(IconPath.iconCamera),
              const SizedBox(
                width: AppDimens.paddingMedium,
              ),
              Text(LabelKeys.takePicture.tr,
                  style: onBackgroundTextStyleSemiBold())
            ],
          ),
        ),
        const SizedBox(
          height: AppDimens.paddingExtraLarge,
        ),
      ],
    );
  }

  Widget imageCardView(String image, int index) {
    return Padding(
      padding: const EdgeInsets.only(
          right: AppDimens.paddingMedium, left: AppDimens.paddingMedium),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
                height: 160,
                width: 120,
                decoration: BoxDecoration(
                    color: const Color(0xffFAFCFE),
                    image: DecorationImage(
                        image: FileImage(File(image)), fit: BoxFit.cover),
                    borderRadius:
                        BorderRadius.circular(AppDimens.radiusCorner))),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: MasterButtonsBounceEffect.iconButton(
                svgUrl: IconPath.deleteRedWhite,
                iconSize: AppDimens.normalIconSize,
                borderRadius: 6,
                iconPadding: 0,
                onPressed: () {
                  Get.bottomSheet(
                    isScrollControlled: true,
                    BottomSheetWithClose(widget: deleteImageBottomSheet(index)),
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget deleteImageBottomSheet(int index) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(IconPath.iconDeletePlaceHolder),
        ),
        AppDimens.paddingXXLarge.ph,
        Text(
          LabelKeys.deleteThisMsg.tr,
          style: onBackGroundTextStyleMedium(fontSize: AppDimens.textLarge),
        ),
        /*Padding(
          padding: const EdgeInsets.only(
              left: AppDimens.paddingExtraLarge,
              right: AppDimens.paddingExtraLarge,
              top: AppDimens.paddingXXLarge),
          child: MasterButtonsBounceEffect.gradiantButton(
              btnText: "OK",
              onPressed: () {
                */ /*controller.localImagePathList.removeWhere((element) =>
                    element.path ==
                    controller.localImagePathList[index - 1].path);
                controller.refreshString.value = getRandomString();
                Get.back();*/ /*
                controller.imageSelected.value = "";
                controller.refreshString.value = getRandomString();
                Get.back();
              }),
        ),*/
        AppDimens.paddingXXLarge.ph,
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
                      controller.localImagePathListTemp.removeAt(index - 1);
                      controller.localImagePathList.removeAt(index - 1);
                      controller.refreshString.value = getRandomString();
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
