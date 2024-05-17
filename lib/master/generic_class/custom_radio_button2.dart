import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/constants.dart';
import '../general_utils/images_path.dart';
import '../general_utils/text_styles.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final String value;
  final String img;
  final String groupValue;
  final String? title;
  final ValueChanged<String?> onChanged;

  const MyRadioListTile({
    super.key,
    required this.value,
    required this.img,
    required this.groupValue,
    required this.onChanged,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Theme(
      data: ThemeData(
          splashColor:
              Get.theme.colorScheme.onBackground.withAlpha(Constants.limit)),
      child: InkWell(
        onTap: () {
          onChanged(value);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimens.paddingSmall),
          padding: const EdgeInsets.all(AppDimens.paddingLarge),
          decoration: BoxDecoration(
              border: Border.all(
                width: AppDimens.paddingNano,
                color: Get.theme.colorScheme.background
                    .withAlpha(Constants.veryLightAlfa),
              ),
              color: isSelected
                  ? Get.theme.colorScheme.primary
                      .withAlpha(Constants.inputFieldCount)
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(
                  Radius.circular(AppDimens.paddingLarge))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.paddingTiny),
                    child: SvgPicture.asset(img),
                  ),
                  AppDimens.paddingMedium.pw,
                  Text(
                    title.toString(),
                    style: onBackGroundTextStyleMedium(
                        fontSize: AppDimens.textLarge),
                  ),
                ],
              ),
              _customRadioButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;

    return isSelected
        ? SvgPicture.asset(
            IconPath.selectedItemIcon,
            colorFilter: ColorFilter.mode(
                Get.theme.colorScheme.primary, BlendMode.srcIn),
          )
        : const SizedBox();
  }
}
