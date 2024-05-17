import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../general_utils/images_path.dart';
import '../general_utils/text_styles.dart';

class CustomCheckBoxButton extends StatelessWidget {
  const CustomCheckBoxButton({
    Key? key,
    required this.isChecked,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final bool isChecked;
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          isChecked
              ? SvgPicture.asset(IconPath.checkBoxChecked)
              : SvgPicture.asset(IconPath.unCheck),
          Text(
            "  $title",
            style:
                onBackgroundTextStyleSemiBold(), /*TextStyle(
                  fontSize: AppDimens.textMedium,
                  color: isChecked ? buttonGreen : Get.theme.colorScheme.onBackground.withAlpha(Constants.lightAlfa),
                  fontFamily: Font.montSemiBold
              )*/
          )
        ],
      ),
    );
  }
}
