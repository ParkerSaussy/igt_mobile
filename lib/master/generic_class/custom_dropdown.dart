import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

class CustomDropDown<T> extends StatelessWidget {
  final Key? dropDownKey;
  final String labelText;
  final String hintText;
  final List<T> options;
  final T value;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;
  final Function onTap;
  final Widget icon;
  final bool? isExpanded;
  final bool? isDense;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;
  final AutovalidateMode? autoValidateMode;

  const CustomDropDown(
      {super.key,
      this.labelText = 'Please select an Option',
      this.hintText = 'Please select an Option',
      this.options = const [],
      required this.getLabel,
      required this.value,
      required this.onChanged,
      required this.onTap,
      required this.icon,
      this.dropDownKey,
      this.isExpanded,
      this.isDense,
      this.prefixIcon,
      this.validator,
      this.autoValidateMode});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: Get.theme.colorScheme.primaryContainer),
      child: DropdownButtonFormField<T>(
        key: key,
        value: value,
        isDense: isDense ?? true,
        isExpanded: isExpanded ?? false,
        icon: icon,
        onTap: () {
          onTap();
        },
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: autoValidateMode,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: onBackgroundTextStyleRegular(alpha: Constants.lightAlfa),
          floatingLabelStyle: onBackgroundTextStyleRegular(),
          hintText: hintText,
          isDense: true,
          prefixIcon: prefixIcon,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        items: options.map((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              getLabel(value),
              style: primaryTextStyleSemiBold(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
