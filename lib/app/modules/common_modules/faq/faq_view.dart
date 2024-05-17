import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/custom_appbar.dart';
import 'package:lesgo/master/generic_class/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

import 'faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingExtraLarge),
              child: Text(LabelKeys.faqs.tr,
                  style: onBackGroundTextStyleMedium(
                      fontSize: AppDimens.textExtraLarge,
                      alpha: Constants.darkAlfa),
                  overflow: TextOverflow.ellipsis),
            ),
            AppDimens.paddingMedium.ph,
            Expanded(
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimens.radiusCircle),
                      topRight: Radius.circular(AppDimens.radiusCircle)),
                ),
                color: Get.theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: AppDimens.paddingExtraLarge,
                      right: AppDimens.paddingExtraLarge),
                  child: Column(
                    children: [
                      AppDimens.paddingExtraLarge.ph,
                      Container(
                        padding: const EdgeInsets.only(
                            left: AppDimens.paddingMedium,
                            right: AppDimens.paddingSmall),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: AppDimens.paddingNano,
                              color: Get.theme.colorScheme.background
                                  .withAlpha(Constants.veryLightAlfa),
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(AppDimens.paddingMedium))),
                        child: CustomTextField(
                          controller: controller.txtFaqSearchController,
                          onChanged: (value) {
                            if (value.trim().isNotEmpty) {
                              controller.faqSearchList.value = controller
                                  .faqList
                                  .where((element) => element.question!
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toString().toLowerCase()))
                                  .toList();
                              controller.restorationFaq.value =
                                  getRandomString();
                            } else {
                              controller.faqSearchList.value =
                                  controller.faqList;
                              controller.restorationFaq.value =
                                  getRandomString();
                            }
                          },
                          inputDecoration: CustomTextField.prefixSuffixOnlyIcon(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            isDense: false,
                            suffixIconConstraints:
                                const BoxConstraints(maxHeight: 60),
                            prefixIconConstraints:
                                const BoxConstraints(maxHeight: 60),
                            contentPadding: const EdgeInsets.fromLTRB(
                                0, 18, AppDimens.paddingExtraLarge, 15),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.txtFaqSearchController.text = "";
                                controller.faqSearchList.value =
                                    controller.faqList;
                                controller.restorationFaq.value =
                                    getRandomString();
                              },
                              child: SvgPicture.asset(
                                IconPath.closeRoundedIcon,
                              ),
                            ),
                            prefixIcon: SvgPicture.asset(
                              IconPath.searchIcon,
                            ),
                          ),
                        ),
                      ),
                      AppDimens.paddingExtraLarge.ph,
                      Expanded(
                        child: Obx(() => controller.faqSearchList.value.isEmpty
                            ? const SizedBox()
                            : ListView.builder(
                                key: Key(
                                    'builder ${controller.selected.toString()}'), //attention
                                scrollDirection: Axis.vertical,
                                itemCount: controller.faqSearchList.length,
                                restorationId: controller.restorationFaq.value,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return itemBuild(context, index);
                                },
                              )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget itemBuild(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      decoration: BoxDecoration(
          border: Border.all(
            width: AppDimens.paddingNano,
            color: Colors.black.withAlpha(Constants.limit),
          ),
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.paddingLarge))),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          key: Key(index.toString()),
          initiallyExpanded: index == controller.selected,
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Text(
            controller.faqSearchList[index].question!,
            textAlign: TextAlign.start,
            style: onBackGroundTextStyleMedium(
              fontSize: AppDimens.textMedium,
            ),
          ),
          onExpansionChanged: (value) {
            if (value) {
              const Duration(milliseconds: 2);
              controller.selected = index;
            } else {
              controller.selected = -1;
            }
            controller.restorationFaq.value = getRandomString();
          },
          trailing: index == controller.selected
              ? SvgPicture.asset(IconPath.minusIcon)
              : SvgPicture.asset(
                  IconPath.plus,
                  colorFilter: ColorFilter.mode(
                      Get.theme.colorScheme.onBackground
                          .withAlpha(Constants.veryLightAlfa),
                      BlendMode.srcIn),
                ),
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Html(
                  data: controller.faqSearchList[index].answer!,
                  onLinkTap: (url, attributes, document) {
                    printMessage(url!);
                    launchUrl(Uri.parse(url));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
