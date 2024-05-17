import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

class CustomTextField extends StatelessWidget {
  //OUTLINE BORDERS

  static OutlineInputBorder outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.colorScheme.onBackground),
  );
  static OutlineInputBorder outlineEnabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.primaryColor),
  );
  static OutlineInputBorder outlineDisabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.disabledColor),
  );
  static OutlineInputBorder outlineFocusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.colorScheme.error),
  );
  static OutlineInputBorder outlineFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.focusColor),
  );
  static OutlineInputBorder outlineErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.colorScheme.error),
  );

  //UNDERLINE BORDERS

  static UnderlineInputBorder underlineBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.colorScheme.onPrimary),
  );
  static UnderlineInputBorder underlineEnabledBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.primaryColor),
  );
  static UnderlineInputBorder underlineDisabledBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.disabledColor),
  );
  static UnderlineInputBorder underlineFocusedErrorBorder =
      UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.colorScheme.error),
  );
  static UnderlineInputBorder underlineFocusedBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.focusColor),
  );
  static UnderlineInputBorder underlineErrorBorder = UnderlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Get.theme.colorScheme.error),
  );

  const CustomTextField(
      {Key? key,
      this.controller,
      this.initialValue,
      this.focusNode,
      this.keyBoardType,
      this.textCapitalization,
      this.style,
      this.textDirection,
      this.textAlign,
      this.textAlignVertical,
      this.autoFocus,
      this.readOnly,
      this.showCursor,
      this.obscuringCharacter,
      this.obscureText,
      this.autoCorrect,
      this.expands,
      this.maxLength,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.validator,
      this.inputFormatters,
      this.enabled,
      this.cursorWidth,
      this.cursorHeight,
      this.autovalidateMode,
      this.inputDecoration,
      this.textInputAction,
      this.cursorRadius,
      this.validationTypes,
      this.maxLines = 1,
      this.minLines})
      : super(key: key);

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyBoardType;
  final TextCapitalization? textCapitalization;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? autoFocus;
  final bool? readOnly;
  final bool? showCursor;
  final String? obscuringCharacter;
  final bool? obscureText;
  final bool? autoCorrect;
  final bool? expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final AutovalidateMode? autovalidateMode;
  final InputDecoration? inputDecoration;
  final TextInputAction? textInputAction;
  final ValidationTypes? validationTypes;
  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      initialValue:
          initialValue, // Default Value Of TextField But Only used when controller is not assigned
      focusNode:
          focusNode, // Each textfield has it's own node and it's used to retrieve focus for particular textfield
      decoration:
          inputDecoration, //To Decorate TextFormField Like suffix prefix Icon, Border, label etc...
      keyboardType:
          keyBoardType, // You can set keyboard type here like number, email address, datetime, name etc...
      textCapitalization: textCapitalization != null
          ? textCapitalization!
          : TextCapitalization
              .sentences, // ".none means all letters are small in keyboard", ".words means first letter is capital in keyboard after every .", ".sentence means Very first letter is capital in keyboard", ".characters means all letter is capital in keyboard"
      style: style, // To Set Default Style Of Text
      textDirection:
          textDirection, // Use it to set Text Direction Like ltr or rtl
      textAlign: textAlign ??
          TextAlign
              .start, // To Align Text Horizontally start, end, center etc..
      textAlignVertical:
          textAlignVertical, // To Align text Vertically Top, Bottom Or Center inside textformfield
      autofocus: autoFocus ??
          false, // if it's value is true This shows keyboard as soon as screen opens
      readOnly: readOnly ??
          false, // if it's true then you can not able to type any thing inside textformfield but you can select & copy content from textformfield
      showCursor: showCursor ?? true, // it's use to show or hide cursor
      obscuringCharacter:
          obscuringCharacter ?? '•', // You can set any character here
      obscureText: obscureText ??
          false, // obscureText used for password text-field it shows '•'.
      autocorrect:
          autoCorrect ?? true, // It will auto correct any spell mistakes
      expands: expands ??
          false, // It's expand text-field but it works only when minLines & maxLines will be null
      maxLength: maxLength ?? 50, //It sets maximum character into text-field..
      onChanged: onChanged, // Get value when user starts typing on text-field
      onTap: onTap, // Called when user taps on text-field
      onEditingComplete:
          onEditingComplete, // it's called when keyboard is closed using done or send button
      onFieldSubmitted:
          onFieldSubmitted, // it's called when focus has been changed
      onSaved: onSaved,
      validator: validator, // TO Check Whether Text field is empty or not
      inputFormatters:
          inputFormatters, //it's used for formatting text which typed inside text-field like Phone Number formatting
      enabled: enabled ??
          true, // By setting this true user can not able to do any action on text-field
      cursorWidth: cursorWidth ?? 2.0, // you can set width of cursor
      cursorHeight: cursorHeight, // You can set height of cursor
      cursorRadius: cursorRadius, //TO set Radius of cursor
      autovalidateMode:
          autovalidateMode, // when to check validation like .onUserInteraction so once user starts typing then it's check for validator
      textInputAction:
          textInputAction, //You can set keyboard return key type like done, go, next etc...
      maxLines: maxLines,
      minLines: minLines,
    );
  }

  /*static InputDecoration simpleDecoration({
    InputBorder? border,
    String? hintText,
    String? labelText,
    bool? isDense,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    bool? alignLabelWithHint,
    String? counterText,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      border: border ?? InputBorder.none,
      hintText: hintText,
      labelText: labelText,
      hintStyle: hintStyle,
      labelStyle: labelStyle,
      isDense: isDense,
      alignLabelWithHint: alignLabelWithHint,
      counterText: counterText,
      contentPadding: contentPadding,
    );
  }

  static InputDecoration suffixIcon(
      {required Callback suffixOnPressed,
      hintText,
      required bool isShowPassword,
      InputBorder? border,
      String? labelText,
      bool? isDense,
      TextStyle? hintStyle,
      TextStyle? labelStyle,
      required SvgPicture passwordVisibleIcon,
      required SvgPicture passwordHideIcon}) {
    return InputDecoration(
        border: border ?? InputBorder.none,
        hintText: hintText,
        suffixIcon: MasterButtonsBounceEffect.iconButton(
            */ /*onTap: suffixOnPressed,
          icon: isShowPassword ? passwordVisibleIcon : passwordHideIcon,
          tooltip: isShowPassword ? 'Show' : 'Hide',*/ /*
            svgUrl: ""),
        labelText: labelText,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        isDense: isDense);
  }

  static InputDecoration onlySuffixIcon(
      {hintText,
      InputBorder? border,
      required Widget suffixIcon,
      String? labelText,
      bool? isDense,
      TextStyle? hintStyle,
      TextStyle? labelStyle,
      EdgeInsetsGeometry? contentPadding,
      InputBorder? focusedBorder}) {
    return InputDecoration(
      border: border ?? InputBorder.none,
      labelText: labelText,
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: hintStyle,
      labelStyle: labelStyle,
      isDense: isDense,
      contentPadding: contentPadding,
      focusedBorder: focusedBorder ??
          const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
    );
  }

  static InputDecoration prefixIcon(
      {hintText,
      InputBorder? border,
      required Widget prefixIcon,
      String? labelText,
      bool? isDense,
      TextStyle? hintStyle,
      TextStyle? labelStyle,
      EdgeInsetsGeometry? contentPadding}) {
    return InputDecoration(
        border: border ?? InputBorder.none,
        labelText: labelText,
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        isDense: isDense,
        contentPadding: contentPadding);
  }*/

  /*static InputDecoration prefixSuffixIcon(
      {
      hintText,
        bool? isShowPassword,
      InputBorder? border,
      Widget? prefixIcon,
      Widget? suffixIcon,
      String? labelText,
      bool? isDense,
      TextStyle? hintStyle,
      TextStyle? labelStyle,}) {
    return InputDecoration(
        border: border ?? InputBorder.none,
        labelText: labelText,
        suffixIcon: suffixIcon,
        */ /*IconButton(
          icon: isShowPassword ? passwordVisibleIcon : passwordHideIcon,
          onPressed: suffixOnPressed,
          tooltip: isShowPassword ? 'Show' : 'Hide',
        ),*/ /*
        prefixIcon: prefixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        isDense: isDense);
  }*/

  static validatorFunction(
      String value, ValidationTypes validationTypes, String validationMsg) {
    if (value.isEmpty) {
      return validationMsg;
    } else {
      switch (validationTypes) {
        case ValidationTypes.email:
          validationMsg = "Please enter valid email address";
          return validateEmail(value, validationMsg);
        case ValidationTypes.phone:
          validationMsg = "Please enter valid phone number";
          return validatePhone(value, validationMsg);
        case ValidationTypes.password:
          validationMsg = "Password must be 8 characters";
          return validatePassword(value, validationMsg);
        case ValidationTypes.zipcode:
          validationMsg = "Please enter valid zipcode";
          return validateZipCode(value, validationMsg);
        case ValidationTypes.url:
          return validateUrl(value, validationMsg);
        case ValidationTypes.other:
          return otherValidation(value, validationMsg);
        default:
          break;
      }
    }
  }

  static bool isValidUrl(String url) {
    final RegExp urlRegExp = RegExp(
      r'^(https?):\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegExp.hasMatch(url);
  }

  static validateEmail(String email, String validationMsg) {
    if (!GetUtils.isEmail(email)) {
      return validationMsg;
    } else {
      return null;
    }
  }

  static validatePhone(String phone, String validationMsg) {
    if (!GetUtils.isPhoneNumber(phone)) {
      return validationMsg;
    } else {
      return null;
    }
  }

  static validateUrl(String url, String validationMsg) {
    if (!GetUtils.isURL(url)) {
      return validationMsg;
    } else {
      return null;
    }
  }

  static validatePassword(String password, String validationMsg) {
    if (password.length < 8) {
      return validationMsg;
    }
  }

  static validateZipCode(String zipCode, String validationMsg) {
    if (zipCode.length < 6) {
      return validationMsg;
    }
  }

  static otherValidation(String value, String validationMsg) {
    if (value.isEmpty) {
      return validationMsg;
    }
  }

  /*static InputDecoration onlyPrefixIcon(
      {hintText,
      InputBorder? border,
      required Widget prefixIcon,
      String? labelText,
      bool? isDense,
      TextStyle? hintStyle,
      TextStyle? labelStyle,
      EdgeInsetsGeometry? contentPadding,
      InputBorder? focusedBorder,
      bool? isFilled,
      Color? fillColor}) {
    return InputDecoration(
      border: border ?? InputBorder.none,
      labelText: labelText,
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: hintStyle,
      labelStyle: labelStyle,
      isDense: isDense,
      contentPadding: contentPadding,
      focusedBorder: focusedBorder ??
          const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
      filled: isFilled,
      fillColor: fillColor,
    );
  }*/

  ///
  static InputDecoration prefixSuffixOnlyIcon({
    String? hintText,
    InputBorder? border,
    InputBorder? enabledBorder,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? labelText,
    String? counterText,
    String? prefixText,
    String? suffixText,
    bool? isDense,
    bool? alignLabelWithHint,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextStyle? counterStyle,
    double? prefixRightPadding,
    bool? isFilled,
    Color? fillColor,
    EdgeInsetsGeometry? contentPadding,
    InputBorder? focusedBorder,
    BoxConstraints? prefixIconConstraints,
    BoxConstraints? suffixIconConstraints,
  }) {
    return InputDecoration(
      border: border ?? InputBorder.none,
      enabledBorder: enabledBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: Get.theme.colorScheme.outlineVariant),
          ),
      labelText: labelText,
      suffixIcon: suffixIcon,
      prefixText: prefixText ?? "",
      suffixText: suffixText ?? "",
      prefixIcon: Padding(
        padding: EdgeInsets.only(right: prefixRightPadding ?? 10),
        child: prefixIcon,
      ),
      hintText: hintText,
      hintStyle: hintStyle,
      alignLabelWithHint: alignLabelWithHint,
      filled: isFilled,
      fillColor: fillColor,
      labelStyle: labelStyle ?? onBackgroundTextStyleRegular(),
      isDense: isDense,
      counterText: counterText ?? "",
      counterStyle: counterStyle,
      contentPadding:
          contentPadding ?? const EdgeInsets.only(top: 5, bottom: 5),
      focusedBorder: focusedBorder ?? const UnderlineInputBorder(),
      prefixIconConstraints:
          prefixIconConstraints ?? const BoxConstraints(maxHeight: 30),
      suffixIconConstraints:
          suffixIconConstraints ?? const BoxConstraints(maxHeight: 30),
    );
  }
}

enum ValidationTypes { email, phone, password, zipcode, url, other }
