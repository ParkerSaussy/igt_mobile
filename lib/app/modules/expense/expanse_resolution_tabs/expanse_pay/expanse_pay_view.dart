import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/scrollview_rounded_corner.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../master/general_utils/app_dimens.dart';
import '../../../../../master/general_utils/constants.dart';
import '../../../../../master/general_utils/images_path.dart';
import '../../../../../master/general_utils/label_key.dart';
import '../../../../../master/general_utils/text_styles.dart';
import '../../../../../master/generic_class/custom_appbar.dart';
import '../../../../../master/generic_class/custom_radio_button2.dart';
import '../../../../../master/generic_class/custom_textfield.dart';
import '../../../../../master/generic_class/master_buttons_bounce_effect.dart';
import '../../../common_widgets/bottomsheet_with_close.dart';
import '../../../common_widgets/container_top_rounded_corner.dart';
import '../../../common_widgets/placeholder_container_with_icon.dart';
import 'expanse_pay_controller.dart';

class ExpansePayView extends GetView<ExpansePayController> {
  const ExpansePayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.buildAppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          isCustomTitle: true,
          customTitleWidget: CustomAppBar.backButton(),
        ),
        body: ContainerTopRoundedCorner(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.only(
                  top: AppDimens.paddingMedium,
                  left: AppDimens.paddingExtraLarge,
                  right: AppDimens.paddingExtraLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ScrollViewRoundedCorner(
                      child: Form(
                        autovalidateMode: controller.activationMode.value,
                        key: controller.expenseFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppDimens.paddingLarge.ph,
                            PlaceholderContainerWithIcon(
                              widget: CustomTextField(
                                controller: controller.unequalController,
                                maxLength: 8,
                                inputDecoration:
                                    CustomTextField.prefixSuffixOnlyIcon(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  prefixRightPadding: 0,
                                  prefixText: '\$',
                                  hintText: '0.00',
                                  hintStyle: onBackgroundTextStyleRegular(
                                      alpha: Constants.transparentAlpha),
                                ),
                                keyBoardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d{0,2})')),
                                ],
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return LabelKeys.validAddExpenseAmount.tr;
                                  } else if (double.parse(v) >
                                      controller.amount!) {
                                    return "${LabelKeys.youOnlyNeedPay.tr} \$${controller.amount}";
                                  } else if (double.parse(v) <= 0) {
                                    return LabelKeys.validAddExpenseAmount.tr;
                                  }
                                  return null;
                                },
                              ),
                              titleName:
                                  '${LabelKeys.youOwe.tr} ${controller.model?.opponent}',
                              titleTextStyle: secondaryTextStyleMedium(
                                  fontSize: AppDimens.textLarge),
                            ),
                            AppDimens.paddingLarge.ph,
                            Text(LabelKeys.selectPaymentMethod.tr,
                                style: onBackGroundTextStyleMedium(
                                    fontSize: AppDimens.textLarge),
                                overflow: TextOverflow.ellipsis),
                            AppDimens.paddingLarge.ph,
                            MyRadioListTile<int>(
                              value: "0",
                              img: IconPath.dollarIcon,
                              groupValue: controller.payment.value,
                              title: LabelKeys.cash.tr,
                              onChanged: (value) {
                                controller.payment.value = value!;
                              },
                            ),
                            AppDimens.paddingSmall.ph,
                            MyRadioListTile<int>(
                              value: "1",
                              img: IconPath.paypalIcon,
                              groupValue: controller.payment.value,
                              title: LabelKeys.payPal.tr,
                              onChanged: (value) {
                                controller.payment.value = value!;
                              },
                            ),
                            AppDimens.paddingSmall.ph,
                            MyRadioListTile<int>(
                              value: "2",
                              img: IconPath.venmoIcon,
                              groupValue: controller.payment.value,
                              title: LabelKeys.venmo.tr,
                              onChanged: (value) {
                                controller.payment.value = value!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.paddingLarge),
                    child: MasterButtonsBounceEffect.gradiantButton(
                      btnText: LabelKeys.submit.tr,
                      onPressed: () async {
                        if (controller.expenseFormKey.currentState!
                            .validate()) {
                          hideKeyboard();
                          Get.focusScope?.unfocus();

                          if (controller.payment.value == "0") //cash
                          {
                            Get.bottomSheet(
                              isScrollControlled: true,
                              BottomSheetWithClose(
                                  widget: showConfirmBottomSheet()),
                            );
                          } else if (controller.payment.value == "1") // Paypal
                          {
                            FGBGEvents.ignoreWhile(() async {
                              await launchUrl(
                                Uri.parse(controller.getPaypalLink(
                                    controller.model?.paypalUsername)),
                              );
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              while (WidgetsBinding.instance.lifecycleState !=
                                  AppLifecycleState.resumed) {
                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                              }
                              Get.bottomSheet(
                                isScrollControlled: true,
                                BottomSheetWithClose(
                                    widget: showConfirmBottomSheet()),
                              );
                            });
                          } else // Venmo
                          {
                            FGBGEvents.ignoreWhile(() async {
                              await launchUrl(
                                Uri.parse(controller.getVenmoPaymentLink(
                                    controller.model?.venmoUsername,
                                    controller.unequalController.text)),
                              );
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              while (WidgetsBinding.instance.lifecycleState !=
                                  AppLifecycleState.resumed) {
                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                              }
                              Get.bottomSheet(
                                isScrollControlled: true,
                                BottomSheetWithClose(
                                    widget: showConfirmBottomSheet()),
                              );
                            });
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showConfirmBottomSheet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppDimens.paddingLarge.ph,
        AppDimens.paddingMedium.ph,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: Text(
            LabelKeys.haveYouMadePayment.tr,
            style: onBackgroundTextStyleRegular(
                fontSize: AppDimens.textLarge, alpha: Constants.lightAlfa),
            textAlign: TextAlign.center,
          ),
        ),
        AppDimens.paddingLarge.ph,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MasterButtonsBounceEffect.gradiantButton(
                  btnText: LabelKeys.yes.tr,
                  onPressed: () {
                    Get.back();
                    controller.payToUser();
                  },
                ),
              ),
              AppDimens.paddingLarge.pw,
              Expanded(
                child: MasterButtonsBounceEffect.gradiantButton(
                  btnText: LabelKeys.no.tr,
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
        AppDimens.padding3XLarge.ph,
      ],
    );
  }
}
