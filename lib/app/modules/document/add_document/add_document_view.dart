import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/label_key.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/custom_textfield.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import 'add_document_controller.dart';

class AddDocumentView extends GetView<AddDocumentController> {
  const AddDocumentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          leadingWidth: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          isCustomTitle: true,
          customTitleWidget: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: AppDimens.paddingMedium,
                  bottom: AppDimens.paddingMedium,
                  right: AppDimens.paddingMedium),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(IconPath.backArrow),
                  const SizedBox(
                    width: AppDimens.paddingMedium,
                  ),
                  Text(
                    LabelKeys.back.tr,
                    style: onBackgroundTextStyleRegular(),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Obx(
          () => Form(
            key: controller.addDocumentKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // add Document title
                    addDocumentTitle(),
                    AppDimens.paddingSmall.ph,
                    Expanded(
                      child: ContainerTopRoundedCorner(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: AppDimens.paddingExtraLarge,
                              right: AppDimens.paddingExtraLarge),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppDimens.paddingExtraLarge.ph,
                              // Document name textField
                              addDocumentNameField(),

                              AppDimens.paddingLarge.ph,
                              // upload Document
                              uploadDocument(context),

                              AppDimens.paddingLarge.ph,
                              // supported file type text label
                              supportText(),

                              AppDimens.paddingLarge.ph,
                              // uploaded file and calculate file size
                              uploadedFile()
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                submitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Submit button
  Positioned submitButton(BuildContext context) {
    return Positioned(
      bottom: AppDimens.paddingExtraLarge,
      left: AppDimens.paddingExtraLarge,
      right: AppDimens.paddingExtraLarge,
      child: MasterButtonsBounceEffect.gradiantButton(
        btnText: LabelKeys.submit.tr,
        disabled: !controller.isUpload.value,
        onPressed: () {
          //Get.back();
          if (controller.addDocumentKey.currentState!.validate()) {
            hideKeyboard();
            if (controller.editValue.value == "0") {
              controller.uploadFiles(controller.selectedDocumentFile!);
            } else {
              if (controller.isImageChange.value) {
                controller.uploadFiles(controller.selectedDocumentFile!);
              } else {
                controller.uploadTripDocument(context);
              }
            }
          }
        },
      ),
    );
  }

  /// uploaded file
  Obx uploadedFile() {
    return Obx(() => controller.lstDocument != null
        ? Container(
            padding: const EdgeInsets.all(AppDimens.paddingSmall),
            decoration: BoxDecoration(
                border: Border.all(
                  width: AppDimens.paddingTiny,
                  color: Get.theme.colorScheme.onBackground
                      .withAlpha(Constants.limit),
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(AppDimens.paddingLarge))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(AppDimens.paddingLarge),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppDimens.paddingLarge)),
                          color: Get.theme.colorScheme.onBackground
                              .withAlpha(Constants.limit),
                        ),
                        child: SvgPicture.asset(controller.getFileExtension(
                                    controller.docFileSize.value) ==
                                "pdf"
                            ? IconPath.pdfIcon
                            : IconPath.imageIcon)),
                    AppDimens.paddingSmall.pw,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.lstDocument!.documentName ?? "",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textSmall,
                              alpha: Constants.darkAlfa),
                        ),
                        Text(
                          "${controller.getFileExtension(controller.docFileSize.value)}",
                          textAlign: TextAlign.center,
                          style: onBackgroundTextStyleRegular(
                              fontSize: AppDimens.textSmall,
                              alpha: Constants.veryLightAlfa),
                        ),
                        FutureBuilder<String>(
                          future: fileSize(controller.lstDocument!.image!),
                          builder: (context, snapshot) {
                            return Text(
                              "${LabelKeys.size.tr} ${snapshot.data ?? ""}",
                              textAlign: TextAlign.center,
                              style: onBackgroundTextStyleRegular(
                                  fontSize: AppDimens.textSmall,
                                  alpha: Constants.veryLightAlfa),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
                AppDimens.paddingSmall.pw,
                GestureDetector(
                  onTap: () {
                    controller.editValue.value = "1";
                    controller.lstDocument = null;
                    controller.isUpload.value = false;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingMedium),
                    child: SvgPicture.asset(IconPath.closeRoundedIcon),
                  ),
                ),
              ],
            ),
          )
        : controller.isUpload.value &&
                controller.docFileExtension.value.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(AppDimens.paddingSmall),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: AppDimens.paddingTiny,
                      color: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.limit),
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.paddingLarge))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.all(AppDimens.paddingLarge),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppDimens.paddingLarge)),
                                color: Get.theme.colorScheme.onBackground
                                    .withAlpha(Constants.limit),
                              ),
                              child: SvgPicture.asset(
                                  controller.docFileExtension.value == "pdf"
                                      ? IconPath.pdfIcon
                                      : IconPath.imageIcon)),
                          AppDimens.paddingSmall.pw,
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  controller.docFileName.value,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: onBackgroundTextStyleRegular(
                                      fontSize: AppDimens.textSmall,
                                      alpha: Constants.darkAlfa),
                                ),
                                Text(
                                  controller.docFileExtension.value,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: onBackgroundTextStyleRegular(
                                      fontSize: AppDimens.textSmall,
                                      alpha: Constants.veryLightAlfa),
                                ),
                                Text(
                                  "${LabelKeys.size.tr} ${controller.docFileSize.value}",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: onBackgroundTextStyleRegular(
                                      fontSize: AppDimens.textSmall,
                                      alpha: Constants.veryLightAlfa),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppDimens.paddingSmall.pw,
                    GestureDetector(
                      onTap: () {
                        controller.isUpload.value = !controller.isUpload.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingMedium),
                        child: SvgPicture.asset(IconPath.closeRoundedIcon),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox());
  }

  /// supported text
  Text supportText() {
    return Text(
      LabelKeys.fileTypeText.tr,
      textAlign: TextAlign.center,
      style: onBackgroundTextStyleRegular(
          fontSize: AppDimens.textSmall, alpha: Constants.lightAlfa),
    );
  }

  /// upload document
  DottedBorder uploadDocument(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      color: Get.theme.colorScheme.onBackground.withAlpha(Constants.limit),
      radius: const Radius.circular(AppDimens.paddingLarge),
      padding: const EdgeInsets.all(AppDimens.paddingTiny),
      dashPattern: const [3, 2],
      child: ClipRRect(
        borderRadius:
            const BorderRadius.all(Radius.circular(AppDimens.textSmall)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingLarge),
              child: Text(
                LabelKeys.uploadDoc.tr,
                style: onBackgroundTextStyleRegular(
                    fontSize: AppDimens.textLarge, alpha: Constants.lightAlfa),
              ),
            ),
            GestureDetector(
              onTap: () async {
                hideKeyboard();
                controller.pickFiles();
              },
              child: Container(
                  padding: const EdgeInsets.all(AppDimens.paddingLarge),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.paddingLarge)),
                    color: Get.theme.colorScheme.onBackground
                        .withAlpha(Constants.limit),
                  ),
                  child: SvgPicture.asset(
                    IconPath.shareMix,
                    colorFilter: ColorFilter.mode(
                        Get.theme.colorScheme.onBackground, BlendMode.srcIn),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /// add document textField
  CustomTextField addDocumentNameField() {
    return CustomTextField(
        controller: controller.docController,
        focusNode: controller.docNode,
        textInputAction: TextInputAction.next,
        maxLength: 30,
        onFieldSubmitted: (v) {},
        style: generalTextStyleMedium(
            color: Get.theme.colorScheme.onBackground
                .withAlpha(Constants.veryLightAlfa)),
        inputDecoration: InputDecoration(
            labelText: LabelKeys.documentName.tr,
            labelStyle: generalTextStyleMedium(
                color: Get.theme.colorScheme.onBackground
                    .withAlpha(Constants.darkAlfa)),
            counterText: '',
            contentPadding: const EdgeInsets.fromLTRB(
                0, AppDimens.paddingMedium, 0, AppDimens.paddingMedium),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: AppDimens.paddingNano,
                    color: Get.theme.colorScheme.onBackground))),
        onChanged: (v) {
          //TextFieldValidation.validatePassword(v);
        },
        validator: (v) {
          return CustomTextField.validatorFunction(
              v!, ValidationTypes.other, LabelKeys.cBlankTripDocumentName.tr);
        });
  }

  ///add document label
  Padding addDocumentTitle() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimens.paddingExtraLarge),
      child: Text(LabelKeys.addDocument.tr,
          style: onBackGroundTextStyleMedium(
              fontSize: AppDimens.textExtraLarge, alpha: Constants.darkAlfa),
          overflow: TextOverflow.ellipsis),
    );
  }

  /// calculate file size
  Future<String> fileSize(url) async {
    //controller.fileSize.value = "";
    if (url.isNotEmpty) {
      http.Response r = await http.get(Uri.parse(url));
      if (r.statusCode == 200) {
        String file = controller.getFileSizeString(
            bytes: int.parse(r.headers["content-length"]!));
        controller.fileSize.value = file;
        printMessage(fileSize);
      }
    }
    return controller.fileSize.value;
  }
}
