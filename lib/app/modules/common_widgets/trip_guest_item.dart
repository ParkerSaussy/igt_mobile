import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

import '../../../master/generic_class/common_network_image.dart';

class TripGuestItem extends StatelessWidget {
  const TripGuestItem(
      {Key? key, required this.onTap, required this.addedGuestModel})
      : super(key: key);

  final AddedGuestmodel addedGuestModel;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.paddingTiny),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                width: 1,
                color: Get.theme.colorScheme.onBackground
                    .withAlpha(Constants.limit)),
            borderRadius:
                const BorderRadius.all(Radius.circular(AppDimens.radiusCorner)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0.5), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingMedium,
                    right: AppDimens.paddingMedium,
                    top: AppDimens.paddingMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppDimens.paddingSmall),
                        child: CommonNetworkImage(
                          height: 70,
                          width: 55,
                          radius: 12,
                          imageUrl: addedGuestModel.profilePicture,
                        ),
                      ),
                      addedGuestModel.isSelected
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child:
                                  SvgPicture.asset(IconPath.userRightGreenBg))
                          : Container()
                    ]),
                    AppDimens.paddingMedium.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${addedGuestModel.firstName ?? ""} ${addedGuestModel.lastName ?? ""}",
                                  style: onBackGroundTextStyleMedium(
                                      fontSize: AppDimens.textLarge),
                                ),
                              ),
                              /*const SizedBox(
                                width: AppDimens.paddingMedium,
                              ),
                              MasterButtonsBounceEffect.iconButton(
                                  svgUrl: IconPath.moreIcon),*/
                            ],
                          ),
                          Text(
                            addedGuestModel.phoneNumber ?? "",
                            style: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textMedium,
                                alpha: Constants.lightAlfa),
                          ),
                          Text(
                            addedGuestModel.emailId ?? "",
                            style: onBackgroundTextStyleRegular(
                                fontSize: AppDimens.textMedium,
                                alpha: Constants.lightAlfa),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: AppDimens.paddingMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppDimens.paddingSmall,
                    right: AppDimens.paddingSmall),
                child: Container(
                  width: Get.width,
                  height: 1,
                  color: Get.theme.colorScheme.onBackground
                      .withAlpha(Constants.limit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
