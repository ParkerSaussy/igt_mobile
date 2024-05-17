import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../networking/request_manager.dart';
import '../session/preference.dart';
import 'app_dimens.dart';
import 'constants.dart';
import 'label_key.dart';

/*
 TODO This method used for gating file size
*/
bool isTooLargeFile(File file) {
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  if (sizeInMb > 10) {
    return false;
  }
  return true;
}

String concatCityName(
    String cityName, String stateAbbr, String countryName, String timezone) {
  String finalCityName;
  finalCityName = cityName;
  if (stateAbbr != '') {
    finalCityName = '$finalCityName, ($stateAbbr)';
  }
  if (countryName != '') {
    finalCityName = '$finalCityName, $countryName';
  }
  if (timezone != '') {
    finalCityName = '$finalCityName ($timezone)';
  }
  return finalCityName;
}

//FILE SIZE CALCULATOR
double fileSizeCalculator(int sizeInBytes) {
  double sizeInMb = sizeInBytes / (1024 * 1024);
  return sizeInMb;
}

///This method used for check internet connection available or not
Future<bool> isConnectedNetwork() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    try {
      final result = await InternetAddress.lookup('google.com');
      printMessage('Data:-  $result');
      printMessage('isLinkLocal:-  ${result[0].isLinkLocal}');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        printMessage('isConnectedNetwork:-  not empty');
        return true;
      } else {
        printMessage('isConnectedNetwork:-  empty');
        return false;
      }
    } on SocketException catch (_) {
      printMessage('message');
      return false;
    }
  } else {
    printMessage('isConnectedNetwork:-  off');
    return false;
  }
}

String getFinalPrice(double amount) {
  double price = amount;
  if (price > 0) {
    return price.toStringAsFixed(2);
  }
  return '0.0';
}

// This method used for gating file size
String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

/*
TODO This method used for gating random string
*/
String getRandomString({int length = 9}) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

int getRandomInt({int min = 10, int max = 50}) {
  var random = Random();
  int result = min + random.nextInt(max - min);
  return result;
}

/*
TODO This method used for gating file name from the url
*/
String getFileNameFromURL(String url) {
  File file = File(url);
  return file.path.split('/').last;
}

//  This method used for change application status bar

changeStatusBarColor(Color statusBar, Color navigationBar) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: navigationBar,
    statusBarColor: statusBar,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

// print warning message
void printWarning(var text) {
  printMessage('\x1B[33m$text\x1B[0m');
}

/// hide keyboard
void hideKeyboard() {
  final keyBoardVisible = MediaQuery.of(Get.context!).viewInsets.bottom != 0;
  if (keyBoardVisible) {
    printMessage('KEYBOARD HIDE');
    FocusScope.of(Get.context!).unfocus();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }
}

/// get device type
String getDeviceType() {
  if (Platform.isIOS) {
    return 'ios';
  } else {
    return 'android';
  }
}

/// get device id
Future<String?> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    final iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    final androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
  return null;
}

/// remove html
String removeHtmlTag(String value) {
  final exp = RegExp('&nbsp;', multiLine: true, caseSensitive: true);
  return value.replaceAll(exp, '');
}

UnderlineInputBorder border = UnderlineInputBorder(
  borderSide: BorderSide(
    color: Get.theme.colorScheme.onBackground
        .withAlpha(Constants.transparentAlpha),
  ),
);

void openCountryPicker(BuildContext context, {onSuccess}) {
  showCountryPicker(
    context: context,
    showPhoneCode: true,
    showWorldWide: false,
    //countryFilter: <String>['CA', 'US','GB','IN'] ,

    onSelect: (Country country) {
      onSuccess('+${country.phoneCode}');
    },
    countryListTheme: CountryListThemeData(
        textStyle: onBackgroundTextStyleRegular(fontSize: AppDimens.textSmall),
        backgroundColor: Get.theme.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radiusCorner),
          topRight: Radius.circular(AppDimens.radiusCorner),
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search',
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          counterText: '',
          hintStyle: onBackgroundTextStyleRegular(alpha: Constants.lightAlfa),
          labelStyle: onBackgroundTextStyleRegular(alpha: Constants.lightAlfa),
        )),
  );
}

///
Widget skeletonChat(Widget child) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return child;
      });
}

///
Widget skeletonHome(Widget child) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: 1,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return child;
      });
}

skeletonGridList(Widget child) {
  return GridView.builder(
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0 / 1.10,
          crossAxisSpacing: 12),
      padding: const EdgeInsets.only(top: AppDimens.radiusButton),
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return child;
      });
}

void clearPreference() {
  Preference.clearPreference();
}

void printMessage(message) {
  if (kDebugMode) {
    print(message);
  }
}

Future<int> getBatteryLevel(address) async {
  try {
    const channel = MethodChannel('com.afh.in/channelName');
    final int value = await channel.invokeMethod('batteryLevel', address);
    return value;
  } on PlatformException catch (e) {
    printMessage(e.message);
    return 0;
  }
}

/*Future<String> cropImage(XFile file) async {
  final cropImageFile = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      sourcePath: file.path,
      maxWidth: 512,
      maxHeight: 512,
      compressFormat: ImageCompressFormat.jpg);
  return cropImageFile!.path;
}*/

Future<void> launchURL(url, {Function? onThen}) async {
  FGBGEvents.ignoreWhile(() async {
    printMessage("Launch Url");
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)
        .then((value) => onThen!(value))) {
      throw 'Could not launch $url';
    }
  });
}

// check permission for camera and storage permission

checkpermission_opencamera(Widget widget) async {
  if (Platform.isAndroid) {
    // Android-specific code
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted) {
      await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: Get.context!,
          builder: ((context) => widget));
    } else if (await Permission.camera.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else {
      RequestManager.getSnackToast(
//          title: LabelKeys.success,
          //message: LabelKeys.strAllowCameraMsg.tr,
          colorText: Get.context?.theme.colorScheme.onBackground
              .withAlpha(Constants.darkAlfa),
          backgroundColor: Get.theme.colorScheme.background);
    }
  } else if (Platform.isIOS) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        builder: ((builder) => widget));
  }
}

String getConversationDate(int timestamp) {
  DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();

  if (isToday(timestamp)) {
    return 'Today';
  } else if (isYesterday(timestamp)) {
    return 'Yesterday';
  } else {
    return '${msgDate.day}/${msgDate.month}/${msgDate.year}';
  }
}

String hasValidUrl(String value) {
  String pattern =
      r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter url';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid url';
  }
  return value;
}

bool isToday(int timestamp) {
  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  final conversationDate = DateTime(msgDate.year, msgDate.month, msgDate.day);
  return conversationDate == today;
}

bool isYesterday(int timestamp) {
  final yesterday = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  DateTime msgDate = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  final conversationDate = DateTime(msgDate.year, msgDate.month, msgDate.day);
  return conversationDate == yesterday;
}

/*String getStringDateFromTimestamp(int timestamp, String format) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
  return DateFormat(format).format(date);
}*/

class RandomDigits {
  static const maxNumericDigits = 17;
  static final _random = Random();

  static int getInteger(int digitCount) {
    if (digitCount > maxNumericDigits || digitCount < 1) {
      throw RangeError.range(0, 1, maxNumericDigits, 'Digit Count');
    }
    var digit = _random.nextInt(9) + 1; // first digit must not be a zero
    int n = digit;

    for (var i = 0; i < digitCount - 1; i++) {
      digit = _random.nextInt(10);
      n *= 10;
      n += digit;
    }
    return n;
  }

  static String getString(int digitCount) {
    String s = '';
    for (var i = 0; i < digitCount; i++) {
      s += _random.nextInt(10).toString();
    }
    return s;
  }

  Widget commonUploadImageBottomSheet(VoidCallback getImage) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimens.paddingExtraLarge),
              topRight: Radius.circular(AppDimens.paddingExtraLarge),
            ),
            color: Get.theme.colorScheme.background,
          ),
          padding: const EdgeInsets.only(
              left: AppDimens.paddingExtraLarge,
              right: AppDimens.paddingExtraLarge,
              bottom: AppDimens.paddingExtraLarge,
              top: AppDimens.paddingExtraLarge),
          width: double.infinity,
          //height: 150,
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: AppDimens.paddingExtraLarge),
                  child: Container(
                    height: 3,
                    width: AppDimens.userProfileSize,
                    color: Get.theme.colorScheme.tertiary,
                  ),
                ),
              ),
              Text(
                LabelKeys.chooseProfilePic.tr,
                style:
                    onPrimaryTextStyleSemiBold(fontSize: AppDimens.textLarge),
              ),
              AppDimens.paddingExtraLarge.ph,
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                      icon: Icon(Icons.camera,
                          color: Get.theme.colorScheme.tertiary),
                      onPressed: () {
                        Get.back();
                        getImage();
                      },
                      label: Text(LabelKeys.camera.tr,
                          style: onPrimaryTextStyleSemiBold()),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.image,
                          color: Get.theme.colorScheme.tertiary),
                      onPressed: () {
                        Get.back();
                        getImage();
                      },
                      label: Text(LabelKeys.gallery.tr,
                          style: onPrimaryTextStyleSemiBold()),
                    ),
                  ]),
            ],
          ),
        )
      ],
    );
  }
}

Future<String> cropImage(PickedFile file) async {
  final cropImageFile = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      sourcePath: file.path,
      maxWidth: 512,
      maxHeight: 512,
      compressFormat: ImageCompressFormat.jpg);

  return cropImageFile!.path;
}

extension EmptyPadding on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );

  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}

extension StringSetup on String {
  Widget get titleText => Text(
        toString(),
        style: onBackgroundTextStyleSemiBold(),
      );
//SizedBox get pw => SizedBox(width: toDouble(),);
}

//DATE PICKER
Future<DateTime?> datePicker({DateTime? firstDate}) async {
  DateTime? pickedDate;
  final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: firstDate ?? DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: firstDate ?? DateTime(1996),
      builder: (context, child) {
        return child!;
      },
      lastDate: DateTime(2101));
  if (picked != null) {
    pickedDate = picked;
  }
  return pickedDate;
}

Future<void> saveDeviceVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  Preference.setVersionCode(version);
  /*var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    Preference.setVersionCode(iosDeviceInfo.systemVersion); // unique ID on iOS
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    Preference.setVersionCode(
        androidDeviceInfo.version.codename); // unique ID on Android
  }*/
}

//Time Picker
Future<TimeOfDay?> timePicker(TimeOfDay initialTime,
    {bool is24HourFormat = false}) async {
  TimeOfDay? pickedTimeString;
  final TimeOfDay? pickedTime = await showTimePicker(
    initialTime: initialTime,
    context: Get.context!,
    initialEntryMode: TimePickerEntryMode.inputOnly,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(alwaysUse24HourFormat: is24HourFormat),
        child: child!,
      );
    },
  );
  if (pickedTime != null) {
    pickedTimeString = pickedTime;
  }
  return pickedTimeString;
}

//TO Set Status bar color transparent
void setStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString =
      parse(document.body?.text).documentElement!.outerHtml;
  return parsedString;
}

String getInitials(String string) => string.isNotEmpty
    ? string.trim().split(RegExp(' +')).map((s) => s[0]).join()
    : '';

String? getFileExtension(String fileName) {
  try {
    return ".${fileName.split('.').last}";
  } catch (e) {
    return null;
  }
}

DateTime convertUTCtoLocal(DateTime date){
  DateTime local = date.toLocal();
  Duration offset = local.timeZoneOffset;
  printMessage("Offset $offset");
  printMessage("Local $local");
  var newLocal = local.add(-offset);
  printMessage("new Local $newLocal");
  var newUtc = newLocal.toUtc();
  printMessage("final local ${newUtc.toLocal()}");
  return newUtc;
}

DateTime addTime(DateTime dateTime,String time){
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  return dateTime.add(Duration(hours: hours,minutes: minutes));
}
