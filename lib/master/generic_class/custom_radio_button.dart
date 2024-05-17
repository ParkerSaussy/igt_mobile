import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../general_utils/constants.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final String value;
  final String groupValue;
  final Widget? title;
  final ValueChanged<String?> onChanged;

  const MyRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return Theme(
      data: ThemeData(
          splashColor:
              Get.theme.colorScheme.onBackground.withAlpha(Constants.limit)),
      child: InkWell(
        onTap: () {
          onChanged(value);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              _customRadioButton,
              const SizedBox(width: 15),
              if (title != null) title,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;

    return isSelected
        ? Icon(
            Icons.radio_button_checked,
            color: Get.theme.colorScheme.primary,
          )
        : Icon(
            Icons.radio_button_off_rounded,
            color: Get.theme.colorScheme.onBackground
                .withAlpha(Constants.veryLightAlfa),
          );
  }
}
