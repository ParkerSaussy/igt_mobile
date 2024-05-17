import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/SingleTripPlanModel.dart';
import 'package:lesgo/app/models/single_plan_model.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:lesgo/master/generic_class/common_network_image.dart';
import 'package:lesgo/master/generic_class/master_buttons_bounce_effect.dart';

class SubscriptionWidget extends StatelessWidget {
  const SubscriptionWidget({
    super.key,
    required this.singleTripPlan,
    required this.singleTripPlanModel,
    required this.singlePlanModel,
    required this.onUnlockTripTap,
    /*required this.onExploreMorePlanTap*/
  });

  final List<SingleTripPlanModel> singleTripPlan;
  final SingleTripPlanModel singleTripPlanModel;
  final SinglePlanModel singlePlanModel;
  final Function onUnlockTripTap;
  // final Function onExploreMorePlanTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              AppDimens.paddingExtraLarge.ph,
              Stack(
                children: [
                  CommonNetworkImage(
                    imageUrl: singleTripPlanModel.planImage,
                    width: Get.width,
                    height: 249,
                    radius: AppDimens.radiusButton,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: AppDimens.paddingLarge,
                          right: AppDimens.paddingLarge,
                          top: AppDimens.paddingSmall,
                          bottom: AppDimens.paddingSmall),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(AppDimens.radiusCornerLarge)),
                          color: const Color(0xffE9FFF4),
                          border:
                              Border.all(color: Get.theme.colorScheme.primary)),
                      child: Column(
                        children: [
                          Text(
                            LabelKeys.oneTripPlan.tr,
                            style: onBackGroundTextStyleMedium(),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "\$",
                                    style: primaryTextStyleSemiBold(
                                        fontSize: AppDimens.textLarge)),
                                TextSpan(
                                    text: "${singlePlanModel.discountedPrice}",
                                    style: primaryTextStyleSemiBold(
                                        fontSize: AppDimens.text2XLarge)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              AppDimens.paddingExtraLarge.ph,
              Text(
                singleTripPlanModel.subTitle,
                style: onBackgroundTextStyleSemiBold(
                    fontSize: AppDimens.textLarge),
              ),
              AppDimens.paddingVerySmall.ph,
              Text(
                singleTripPlanModel.description,
                textAlign: TextAlign.center,
                style: onBackgroundTextStyleRegular(alpha: Constants.lightAlfa),
              ),
              AppDimens.paddingExtraLarge.ph,
              Container(
                width: Get.width,
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingXLarge,
                    right: AppDimens.paddingXLarge,
                    top: AppDimens.paddingLarge),
                decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primaryContainer
                        .withAlpha(Constants.limit),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.radiusButton))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LabelKeys.premiumFeatures.tr,
                      style: onBackgroundTextStyleSemiBold(
                          fontSize: AppDimens.textLarge),
                    ),
                    AppDimens.paddingMedium.ph,
                    SizedBox(
                      width: Get.width,
                      child: Wrap(
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < singleTripPlan.length; i++)
                            if (!singleTripPlan[i].isSelected)
                              featureWidget(singleTripPlan[i]),
                        ],
                      ),
                    ),
                    /*GridView.builder(
                      itemCount: singleTripPlan.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 5,
                        crossAxisSpacing: 50,
                      ),
                      itemBuilder: (context, index) {
                        return featureWidget(singleTripPlan[index]);
                      },
                    ),*/
                    AppDimens.paddingMedium.ph
                  ],
                ),
              ),
              AppDimens.paddingExtraLarge.ph,
              /*SizedBox(
          height: 110,
          child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            restorationId: restorationId,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return planWidget('3 Month Plan', '\$36.00', 'Quarterly', '25% Off', index);
            },
          ),
        ),
        AppDimens.paddingXXLarge.ph,*/
            ],
          ),
        ),
        MasterButtonsBounceEffect.gradiantButton(
            btnText: LabelKeys.unlockTripNow.tr,
            onPressed: () {
              onUnlockTripTap();
            }),
        /*AppDimens.paddingMedium.ph,
        MasterButtonsBounceEffect.textButton(
          btnText: 'Explore More Plan',
          onPressed: (){
            onExploreMorePlanTap();
          },
          textStyles: primaryTextStyleSemiBold().copyWith(
            decoration: TextDecoration.underline,
          )
        ),*/
        AppDimens.paddingMedium.ph,
      ],
    );
  }

  Widget featureWidget(SingleTripPlanModel singleTripPlanModel) {
    return SizedBox(
      width: 160,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(IconPath.iconTick),
          AppDimens.paddingSmall.pw,
          Flexible(
            child: Text(
              singleTripPlanModel.title,
              style: onBackgroundTextStyleRegular(
                fontSize: AppDimens.textSmall,
              ),
            ),
          )
        ],
      ),
    );
  }

  /*Widget planWidget(String title, String price, String subTitle, String discount, int index){
    return InkWell(
      onTap: (){
        onTap(index);
      },
      child: Container(
        padding: const EdgeInsets.only(right: 4),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              height: 100,
              width: 118,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: index == selectedIndex ? Get.theme.colorScheme.primary : Get.theme.colorScheme.tertiary),
                borderRadius: const BorderRadius.all(Radius.circular(AppDimens.radiusButton)),
                color: index == selectedIndex ? Get.theme.colorScheme.primary : Get.theme.colorScheme.onPrimary
              ),
              child: Column(
                children: [
                  AppDimens.paddingExtraLarge.ph,
                  Text(
                    title,
                    style: index == selectedIndex ?
                    onPrimaryTextStyleRegular(
                      fontSize: AppDimens.textSmall,
                    ) :
                    onBackgroundTextStyleRegular(
                      fontSize: AppDimens.textSmall,
                      alpha: Constants.veryLightAlfa
                    ),
                  ),
                  Text(
                    price,
                    style: index == selectedIndex ?
                    onPrimaryTextStyleSemiBold(
                      fontSize: AppDimens.textLarge,
                    ) :
                    onBackgroundTextStyleSemiBold(
                      fontSize: AppDimens.textLarge,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: index == selectedIndex ?
                    onPrimaryTextStyleRegular(
                      fontSize: AppDimens.textSmall,
                    ) :
                    onBackgroundTextStyleRegular(
                      fontSize: AppDimens.textSmall
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: -2,
              child: Container(
                padding: const EdgeInsets.only(left: AppDimens.paddingSmall, right: AppDimens.paddingSmall),
                decoration: BoxDecoration(
                  color: index == selectedIndex ? const Color(0xffC2FFE1) : Get.theme.colorScheme.tertiary,
                  borderRadius: const BorderRadius.all(Radius.circular(AppDimens.radiusCorner)),
                  border: Border.all(color: index == selectedIndex ? Get.theme.colorScheme.primary : Colors.transparent, width: index == selectedIndex ? 1 : 0)
                ),
                child: Text(
                  discount,
                  style: onBackgroundTextStyleSemiBold(
                    fontSize: AppDimens.textTiny,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
