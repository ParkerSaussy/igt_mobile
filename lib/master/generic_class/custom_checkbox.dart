import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

import '../general_utils/app_dimens.dart';
import '../general_utils/images_path.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    Key? key,
    this.width = 30.0,
    this.height = 30.0,
    this.color,
    this.iconSize,
    required this.onChanged,
    this.checkColor,
    required this.title,
    required this.isChecked,
  }) : super(key: key);

  final double width;
  final double height;
  final Color? color;
  final double? iconSize;
  final Color? checkColor;
  final Function onChanged;
  final String title;
  final bool isChecked;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged();
        /*setState(() => isChecked = !isChecked);
        widget.onChanged?.call(isChecked);*/
      },
      child: Row(
        children: [
          SizedBox(
              width: widget.width,
              height: widget.height,
              child: widget.isChecked
                  ? SvgPicture.asset(IconPath.checkBoxChecked)
                  : SvgPicture.asset(IconPath.unCheck)),
          const SizedBox(
            width: AppDimens.paddingMedium,
          ),
          Text(widget.title,
              style:
                  onBackgroundTextStyleSemiBold() /*TextStyle(
              fontSize: AppDimens.textMedium,
              color: widget.isChecked ? buttonGreen : Get.theme.colorScheme.onBackground.withAlpha(Constants.lightAlfa),
              fontFamily: Font.montSemiBold
            )*/
              )
        ],
      ),
    );
  }
}
