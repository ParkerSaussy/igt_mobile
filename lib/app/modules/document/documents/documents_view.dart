import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lesgo/app/modules/common_widgets/container_top_rounded_corner.dart';
import 'package:lesgo/app/modules/common_widgets/no_record_found.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../master/general_utils/app_dimens.dart';
import '../../../../master/general_utils/constants.dart';
import '../../../../master/general_utils/images_path.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/general_utils/text_styles.dart';
import '../../../../master/generic_class/custom_appbar.dart';
import '../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../models/document_list.dart';
import '../../../routes/app_pages.dart';
import 'documents_controller.dart';

class DocumentsView extends GetView<DocumentsController> {
  const DocumentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () {
            Get.focusScope?.unfocus();
          },
          child: Scaffold(
            appBar: CustomAppBar.buildAppBar(
              isCustomTitle: true,
                customTitleWidget: CustomAppBar.backButton()
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingExtraLarge),
                  child: Text(
                      controller.isSelected.value
                          ? "${controller.totalSelected.value} ${LabelKeys.selected.tr}"
                          : LabelKeys.documents.tr,
                      style: onBackGroundTextStyleMedium(
                          fontSize: AppDimens.textExtraLarge,
                          alpha: Constants.darkAlfa),
                      overflow: TextOverflow.ellipsis),
                ),
                AppDimens.paddingSmall.ph,
                Expanded(
                    child: ContainerTopRoundedCorner(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: AppDimens.paddingExtraLarge,
                        left: AppDimens.paddingMedium,
                        right: AppDimens.paddingMedium),
                    child: SizedBox(
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Obx(
                              () => controller.isDocumentFetch.value
                                  ? ListView.builder(
                                      itemCount:
                                          controller.newList!.length,
                                      restorationId: controller
                                          .restorationDocId.value,
                                      shrinkWrap: true,
                                      itemBuilder: (context, indexFirst) {
                                        String? category = controller
                                            .newList!.keys
                                            .elementAt(indexFirst);
                                        final dateTime = Date.shared()
                                            .dateConverter(category!);
                                        List<DocumentList>
                                            itemsInCategory = controller
                                                .newList![category]!;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      top: 8.0),
                                              child: Text(
                                                dateTime,
                                                style:
                                                    onBackGroundTextStyleMedium(),
                                              ),
                                            ),
                                            ListView.builder(
                                              padding: const EdgeInsets
                                                      .only(
                                                  top: AppDimens
                                                      .paddingVerySmall),
                                              scrollDirection:
                                                  Axis.vertical,
                                              itemCount:
                                                  itemsInCategory.length,
                                              restorationId: controller
                                                  .restorationDocId.value,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (context, index) {
                                                return itemBuild(
                                                    context,
                                                    index,
                                                    itemsInCategory);
                                              },
                                            ),
                                          ],
                                        );
                                      })
                                  : controller.isDataLoading.value
                                      ? const SizedBox()
                                      : Container(
                                          alignment: Alignment.center,
                                          child: const NoRecordFound()),
                            ),
                          ),
                          AppDimens.eventStatusCardWidth.ph,
                        ],
                      ),
                    ),
                  ),
                )),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      top: AppDimens.paddingExtraLarge,
                      left: AppDimens.paddingMedium,
                      bottom: AppDimens.paddingMedium,
                      right: AppDimens.paddingMedium),
                  child:MasterButtonsBounceEffect.gradiantButton(
                    btnText: LabelKeys.addNewDoc.tr,
                    onPressed: () async {
                      await Get.toNamed(Routes.ADD_DOCUMENT,
                          arguments: ["0", controller.tripId.value, null]);
                      controller.getTripDocuments(controller.tripId.value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget itemBuild(
      BuildContext context, int index, List<DocumentList> itemsInCategory) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: AppDimens.paddingSmall),
        child: Slidable(
          key: UniqueKey(),
          enabled: itemsInCategory[index].uploadedBy ==
              gc.loginData.value.id.toString(),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  /*Get.bottomSheet(
                  isScrollControlled: true,
                  BottomSheetWithClose(
                      widget: successBottomSheet(itemsInCategory[index].id)),
                );*/
                  controller.lstDoc.value.add(itemsInCategory[index].id!);
                  controller.deleteTripDocuments();
                  controller.restorationDocId.value = getRandomString();
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: LabelKeys.delete.tr,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimens.paddingSmall),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: AppDimens.paddingNano,
                      color: Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.limit),
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.paddingLarge))),
                child: Container(
                  color: itemsInCategory[index].isSelected!
                      ? Get.theme.colorScheme.primary.withAlpha(8)
                      : Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(AppDimens.paddingLarge),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(AppDimens.paddingSmall)),
                              color: itemsInCategory[index].isSelected!
                                  ? Get.theme.colorScheme.primary
                                      .withAlpha(Constants.limit)
                                  : Get.theme.colorScheme.onBackground
                                      .withAlpha(Constants.limit),
                            ),
                            child: controller.getFileExtension(
                                        itemsInCategory[index].image!) ==
                                    ".pdf"
                                ? SvgPicture.asset(IconPath.pdfIcon)
                                : SvgPicture.asset(IconPath.imageIcon),
                          ),
                          AppDimens.paddingSmall.pw,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemsInCategory[index].documentName ?? "",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textSmall,
                                    alpha: Constants.darkAlfa),
                              ),
                              Text(
                                itemsInCategory[index].document ?? "",
                                textAlign: TextAlign.center,
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textSmall,
                                    alpha: Constants.veryLightAlfa),
                              ),
                              Text(
                                itemsInCategory[index].size ?? "",
                                textAlign: TextAlign.center,
                                style: onBackgroundTextStyleRegular(
                                    fontSize: AppDimens.textSmall,
                                    alpha: Constants.veryLightAlfa),
                              ),
                              /* FutureBuilder<String>(
                                future: fileSize(itemsInCategory[index].image),
                                builder: (context, snapshot) {
                                  return Text(
                                    "Size: ${snapshot.data}",
                                    textAlign: TextAlign.center,
                                    style: onBackgroundTextStyleRegular(
                                        fontSize: AppDimens.textSmall,
                                        alpha: Constants.veryLightAlfa),
                                  );
                                },
                              ),*/
                            ],
                          ),
                        ],
                      ),
                      AppDimens.paddingSmall.pw,
                      controller.isSelected.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.paddingMedium),
                              child: SvgPicture.asset(
                                  itemsInCategory[index].isSelected!
                                      ? IconPath.radioCheckGreen
                                      : IconPath.radioUncheckWhite),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  right: AppDimens.paddingMedium),
                              child:
                                  popupEdit(itemsInCategory[index].id, index),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _dateTextWidget(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingMedium),
      child: Text(
        controller.daysBetween(
            Date.shared().stringFromDate(controller.docList[index].createdAt!)),
        style: onBackGroundTextStyleMedium(),
      ),
    );
  }

  Widget popupInfo() => Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: PopupMenuButton<int>(
          elevation: 1,
          shadowColor: Get.theme.colorScheme.onBackground,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
          itemBuilder: (context) => [
            PopupMenuItem(
              height: AppDimens.paddingMedium,
              value: 1,
              child: itemMenu(
                  LabelKeys.selectAll.tr,
                  controller.isSelected.value
                      ? IconPath.checkBoxChecked
                      : IconPath.unCheck),
              onTap: () {
                controller.isSelected.value = !controller.isSelected.value;
                controller.selectAll(controller.isSelected.value);
                controller.restorationDocId.value = getRandomString();
              },
            ),
            PopupMenuItem(
              height: AppDimens.paddingLarge,
              value: 2,
              child: itemMenu(LabelKeys.download.tr, IconPath.downloadIcon),
              onTap: () {
                for (int i = 0; i < controller.docList.value.length; i++) {
                  if (controller.docList[i].isSelected!) {
                    downloadFile(controller.docList[i].image!);
                    //downloadedFile(controller.docList[i].image!);
                  } else {
                    RequestManager.getSnackToast(
                        message: LabelKeys.cBlankDocumentSelect.tr);
                  }
                }
              },
            ),
          ],
          child: SvgPicture.asset(IconPath.moreIcon),
        ),
      );

  Widget itemMenu(String title, String icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingMedium),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
                Get.theme.colorScheme.onBackground, BlendMode.srcIn),
          ),
          AppDimens.paddingMedium.pw,
          Text(title,
              style: onSurfaceTextStyleRegular(
                  fontSize: AppDimens.textSmall, alpha: Constants.darkAlfa)),
        ],
      ),
    );
  }

  Widget popupEdit(docID, int index) => Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: PopupMenuButton<int>(
          elevation: 1,
          shadowColor: Get.theme.colorScheme.onBackground,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppDimens.paddingMedium))),
          itemBuilder: (context) => [
            if (controller.docList[index].uploadedBy ==
                gc.loginData.value.id.toString())
              PopupMenuItem(
                height: AppDimens.paddingMedium,
                value: 1,
                child: itemMenu(LabelKeys.edit.tr, IconPath.edit),
                onTap: () {
                  SchedulerBinding.instance.addPostFrameCallback((_) async {
                    await Get.toNamed(Routes.ADD_DOCUMENT, arguments: [
                      "1",
                      controller.tripId.value,
                      controller.docList[index]
                    ]);
                    controller.getTripDocuments(controller.tripId.value);
                  });
                },
              ),
            PopupMenuItem(
              height: AppDimens.paddingLarge,
              value: 2,
              child: itemMenu(LabelKeys.download.tr, IconPath.downloadIcon),
              onTap: () {
                downloadFile(controller.docList[index].image!);
                //downloadedFile(controller.docList[index].image!);
              },
            ),
            PopupMenuItem(
              height: AppDimens.paddingLarge,
              value: 3,
              child: itemMenu(LabelKeys.share.tr, IconPath.shareIcon),
              onTap: () {
                shareAndDownload(controller.docList[index].image!);
                //controller.docList.removeWhere((item) => item.id == docID);
                //controller.restorationDocId.value = getRandomString();
              },
            ),
          ],
          child: SvgPicture.asset(IconPath.moreIcon),
        ),
      );

  downloadFile(var documentUrl) async {
    try {
      /// setting filename
      //String dir = (await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS));
      Directory directory = Directory("");
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download/lesgo");
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
      printMessage("filepath${file.path}");
      RequestManager.getSnackToast(message: "Download Success.");
      controller.isSelected.value = false;

      /// writing bytes data of response in the file.
      await file.writeAsBytes(bytes);

      return file;
    } catch (err) {
      printMessage(err);
    }
  }

  shareAndDownload(var documentUrl) async {
    try {
      /// setting filename
      //String dir = (await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS));
      Directory directory = Directory("");
      if (Platform.isAndroid) {
        directory = Directory("/storage/emulated/0/Download/lesgo");
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

  Future<String> fileSize(url) async {
    String fileSize = "";
    if (url.isNotEmpty) {
      http.Response r = await http.get(Uri.parse(url));
      if (r.statusCode == 200) {
        String file = controller.getFileSizeString(
            bytes: int.parse(r.headers["content-length"]!));
        fileSize = file;
        printMessage(fileSize);
      }
    }
    return fileSize;
  }

  successBottomSheet(id) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppDimens.paddingLarge.ph,
          SvgPicture.asset(IconPath.deleteIcon),
          AppDimens.paddingLarge.ph,
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
                        controller.lstDoc.value.add(id);
                        controller.deleteTripDocuments();
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

  /*Future<void> downloadedFile(String url) async {
    var dir;
    if(Platform.isAndroid){
      dir = await getExternalStorageDirectory();
    }else{
      dir = await getApplicationDocumentsDirectory();
    }
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir!.path,
      */ /*fileName: 'downloaded_file.pdf',*/ /*
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );

    */ /*FlutterDownloader.registerCallback((id, status, progress) {
      if (status == DownloadTaskStatus.complete) {
        // Download complete
        //showNotification('Download Complete', 'File downloaded successfully');
      } else if (status == DownloadTaskStatus.failed) {
        // Download failed
        //showNotification('Download Failed', 'File download failed');
      }
    });*/ /*
  }*/
  /*Future<void> showNotification(String title, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'download_channel',
      'Download Notification',
      importance: Importance.max,
      //priority: Priority.high,
      showProgress: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin().show(
      0,
      title,
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }*/
}
