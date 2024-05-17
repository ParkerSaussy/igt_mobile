import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/bottomsheet_with_close.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/app/modules/common_widgets/placeholder_container_with_icon.dart';
import 'package:lesgo/app/modules/common_widgets/trip_memories_listview.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../master/networking/request_manager.dart';
import '../../common_widgets/container_top_rounded_corner.dart';
import 'trip_memories_screen_controller.dart';

class TripMemoriesScreenView extends GetView<TripMemoriesScreenController> {
  const TripMemoriesScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
            isCustomTitle: true,
            customTitleWidget: CustomAppBar.backButton(),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            actionWidget: [
              Row(
                children: [
                  Obx(() => controller.selectedTripImages.isNotEmpty
                      ? Row(
                          children: [
                            controller.selectedTripImages[0].createdBy ==
                                    gc.loginData.value.id
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        right: AppDimens.paddingSmall),
                                    child: MasterButtonsBounceEffect.iconButton(
                                        svgUrl: IconPath.deleteIcon,
                                        bgColor: Colors.transparent,
                                        iconSize: AppDimens.normalIconSize,
                                        onPressed: () {
                                          Get.bottomSheet(
                                            isScrollControlled: true,
                                            BottomSheetWithClose(
                                                widget:
                                                    deleteImagesBottomSheet()),
                                          );
                                        }),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: AppDimens.paddingSmall),
                              child: MasterButtonsBounceEffect.iconButton(
                                  svgUrl: IconPath.shareIcon,
                                  bgColor: Colors.transparent,
                                  iconSize: AppDimens.normalIconSize,
                                  onPressed: () {
                                    for (int i = 0;
                                        i <
                                            controller.selectedTripImages.value
                                                .length;
                                        i++) {
                                      shareAndDownload(controller
                                          .selectedTripImages[i].image!);
                                    }
                                  }),
                            )
                          ],
                        )
                      : Container()),
                ],
              ),
            ]),
        body: SizedBox(
          width: Get.width,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // trip photos title
                  tripPhotosLabel(),
                  AppDimens.paddingMedium.ph,
                  dropboxLinkTextField(),
                  AppDimens.paddingMedium.ph,
                  // trip photos list
                  Expanded(
                    child: ContainerTopRoundedCorner(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: AppDimens.paddingExtraLarge),
                        child: Obx(
                          () => controller.isMemoriesFetch.value
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft:
                                        Radius.circular(AppDimens.radiusCircle),
                                    topRight:
                                        Radius.circular(AppDimens.radiusCircle),
                                  ),
                                  child: TripMemoriesListView(
                                    gridRestorationId:
                                        controller.gridRestorationId.value,
                                    newList: controller.newList,
                                    onTap: (gridIndex, listIndex) {
                                      String? category = controller
                                          .newList!.keys
                                          .elementAt(listIndex);
                                      List itemsInCategory =
                                          controller.newList![category]!;
                                      if (controller.isLongPressEnabled.value) {
                                        if (controller.selectedIndex ==
                                            gridIndex) {
                                          for (int i = 0;
                                              i < itemsInCategory.length;
                                              i++) {
                                            itemsInCategory[i].isSelected =
                                                false;
                                          }
                                          controller.selectedTripImages.clear();
                                          controller.lstTrip.clear();
                                        } else {
                                          controller.selectedTripImages.clear();
                                          controller.lstTrip.clear();
                                          controller.selectedIndex = gridIndex;
                                          for (int i = 0;
                                              i < itemsInCategory.length;
                                              i++) {
                                            itemsInCategory[i].isSelected =
                                                false;
                                          }
                                          itemsInCategory[gridIndex]
                                              .isSelected = true;
                                          controller.selectedTripImages
                                              .add(itemsInCategory[gridIndex]);
                                          controller.lstTrip.add(
                                              itemsInCategory[gridIndex].id);
                                          printMessage(controller.lstTrip);
                                        }
                                        if (controller
                                            .selectedTripImages.isEmpty) {
                                          controller.isLongPressEnabled.value =
                                              false;
                                          controller.gridRestorationId.value =
                                              getRandomString();
                                        } else {
                                          controller.gridRestorationId.value =
                                              getRandomString();
                                        }
                                      } else {
                                        Get.toNamed(
                                            Routes.PREVIEW_TRIP_MEMORIES,
                                            arguments: [
                                              itemsInCategory,
                                              gridIndex
                                            ]);
                                      }
                                    },
                                    onLongPress: (gridIndex, listIndex) {
                                      String? category = controller
                                          .newList!.keys
                                          .elementAt(listIndex);
                                      List itemsInCategory =
                                          controller.newList![category]!;
                                      if (!controller
                                          .isLongPressEnabled.value) {
                                        controller.selectedIndex = gridIndex;
                                        for (int i = 0;
                                            i < itemsInCategory.length;
                                            i++) {
                                          itemsInCategory[i].isSelected = false;
                                        }
                                        itemsInCategory[gridIndex].isSelected =
                                            true;
                                        controller.selectedTripImages
                                            .add(itemsInCategory[gridIndex]);
                                        controller.lstTrip
                                            .add(itemsInCategory[gridIndex].id);
                                        printMessage(controller.lstTrip);
                                        controller.isLongPressEnabled.value =
                                            true;
                                        controller.gridRestorationId.value =
                                            getRandomString();
                                      }
                                    },
                                  ),
                                )
                              : controller.isDataLoading.value
                                  ? const SizedBox()
                                  : const NoRecordFound(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Add Images button
              addImagesButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// add images button
  Positioned addImagesButton() {
    return Positioned(
        bottom: AppDimens.paddingExtraLarge,
        left: AppDimens.paddingExtraLarge,
        right: AppDimens.paddingExtraLarge,
        child: MasterButtonsBounceEffect.gradiantButton(
          btnText: LabelKeys.addImages.tr,
          onPressed: () async {
            await Get.toNamed(Routes.ADD_NEW_PHOTOS,
                arguments: controller.tripId.value);
            controller.memoryListing(controller.tripId.value);
          },
        ));
  }

  /// trip photos label
  Padding tripPhotosLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimens.paddingExtraLarge),
      child: Text(
        LabelKeys.tripPhotos.tr,
        style: onBackGroundTextStyleMedium(fontSize: AppDimens.textExtraLarge),
      ),
    );
  }

  /// image download on local storage and share images
  shareAndDownload(var documentUrl) async {
    try {
      /// setting filename
      //String dir = (await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS));
      Directory directory = Directory("");
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download/lesgo/tripmemory");
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      //if (await File('$dir/$filename').exists()) return File('$dir/$filename');
      final exPath = directory.path;
      await Directory(exPath).create(recursive: true);

      String url = documentUrl;
      printMessage("url $url");
      String fileType = getFileNameFromURL(url);

      /// requesting http to get url
      var request = await HttpClient().getUrl(Uri.parse(url));

      /// closing request and getting response
      var response = await request.close();

      /// getting response data in bytes
      var bytes = await consolidateHttpClientResponseBytes(response);

      /// generating a local system file with name as 'filename' and path as '$dir/$filename'
      File file = File("$exPath/$fileType");
      printMessage("filepath ${file.path}");

      /// writing bytes data of response in the file.
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)], subject: "Share");

      return file;
    } catch (err) {
      printMessage(err);
      EasyLoading.dismiss();
    }
  }

  /// open bottomSheet for delete single image
  deleteImagesBottomSheet() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LabelKeys.areYouSureWantDelete.tr,
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
                        Get.back();
                        controller.callApiForDeleteMemory();
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
          AppDimens.padding3XLarge.ph,
        ],
      ),
    );
  }

  Widget dropboxLinkTextField() {
    return Obx(() => controller.dropboxUrl.value.isEmpty &&
            controller.tripRole.value != "Host"
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(
                left: AppDimens.paddingExtraLarge,
                right: AppDimens.paddingExtraLarge),
            child: PlaceholderContainerWithIcon(
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "share your memories in below folder",
                    style: onBackgroundTextStyleRegular(
                        alpha: Constants.lightAlfa,
                        fontSize: AppDimens.textSmall),
                  ),
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: AppDimens.paddingSmall),
                        child: GestureDetector(
                            onTap: () {
                              //launchUrl(Uri.parse(controller.dropboxUrl.value));
                              launchURL(
                                  "https://${controller.dropboxUrl.value}");
                            },
                            child: SvgPicture.asset(
                                !controller.isDropboxLinkEdit.value
                                    ? IconPath.urlIcon
                                    : IconPath.attachmentIcon)),
                      ),
                      AppDimens.paddingMedium.pw,
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (controller
                                    .dropboxLinkController.text.isNotEmpty &&
                                !controller.isDropboxLinkEdit.value) {
                              /*launchUrl(
                                  Uri.parse(controller.dropboxLinkController.text));*/
                              launchURL(
                                  "https://${controller.dropboxLinkController.text}");
                            }
                          },
                          child: Form(
                            autovalidateMode: controller.activationMode.value,
                            key: controller.urlFormKey,
                            child: CustomTextField(
                              controller: controller.dropboxLinkController,
                              keyBoardType: TextInputType.url,
                              //autoFocus: controller.autoFocus.value,
                              focusNode: controller.focusNodeUrl,
                              style: onBackGroundTextStyleMedium().copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                } else {
                                  return CustomTextField.validatorFunction(
                                      value,
                                      ValidationTypes.url,
                                      LabelKeys.cBlankActivityEventUrl.tr);
                                }
                                /*bool validURL =
                                    Uri.parse(controller.dropboxLinkController.text)
                                        .isAbsolute;
                                if (validURL) {
                                  return null;
                                } else {
                                  return LabelKeys.cBlankActivityEventUrl.tr;
                                }*/

                                /* bool validURL = Uri.parse(controller.txtLinkController.text).isAbsolute;
                                   CustomTextField.isValidUrl(
                                      value,
                                      ValidationTypes.url,
                                      LabelKeys.cBlankActivityEventUrl.tr);*/
                              },
                              readOnly: !controller.isDropboxLinkEdit.value,
                              enabled: controller.isDropboxLinkEdit.value &&
                                  controller.tripRole.value == "Host",
                              inputDecoration:
                                  CustomTextField.prefixSuffixOnlyIcon(
                                      prefixRightPadding: 0,
                                      contentPadding: const EdgeInsets.only(
                                          left: AppDimens.paddingSmall,
                                          top: AppDimens.paddingSmall),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      alignLabelWithHint: true,
                                      isDense: true,
                                      hintText: "Enter link",
                                      counterText: ""),
                            ),
                          ),
                        ),
                      ),
                      AppDimens.paddingMedium.pw,
                      controller.tripRole.value == "Host"
                          ? !controller.isDropboxLinkEdit.value
                              ? GestureDetector(
                                  onTap: () {
                                    controller.isDropboxLinkEdit.value = true;
                                    controller.focusNodeUrl.requestFocus();
                                  },
                                  child: SvgPicture.asset(IconPath.editIcon))
                              : MasterButtonsBounceEffect.textButton(
                                  textStyles: primaryTextStyleSemiBold(),
                                  onPressed: () {
                                    if (controller.isDropboxLinkEdit.value) {
                                      if (controller.urlFormKey.currentState!
                                          .validate()) {
                                        hideKeyboard();
                                        //controller.autoFocus.value = false;
                                        controller.callApiForDropboxUrl();
                                      } else {
                                        controller.activationMode.value =
                                            AutovalidateMode.onUserInteraction;
                                      }
                                    }
                                  },
                                  btnText: LabelKeys.save.tr)
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
              titleName: "Memories bucket link",
            ),
          ));
  }
}
