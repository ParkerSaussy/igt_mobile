import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/app/services/fcm_service.dart';
import 'package:lesgo/master/general_utils/app_themes.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/generic_class/paypal_payment.dart';
import 'package:lesgo/master/localization/app_translation.dart';
import 'package:lesgo/master/session/preference.dart';

///
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  HttpOverrides.global = MyHttpOverrides();
  await Preference().init();
  if (Preference.isGetNotification()) {
    Preference.isSetNotification(false);
  }
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FcmService().registerNotification();
  await FcmService().getFCMToken();
  await FcmService().initLocalNotification();
  await PayPalPayment.initPayPal();
  await saveDeviceVersion();
  setStatusBarColor();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      GetMaterialApp(
        title: 'ItsGoTime',
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.getInitPage(),
        getPages: AppPages.routes,
        theme: AppThemes.light,
        darkTheme: AppThemes.dark,
        themeMode: ThemeMode.light,
        locale: AppTranslation.getLocal(),
        fallbackLocale: AppTranslation.fallbackLocale,
        translations: AppTranslation(),
        builder: EasyLoading.init(),
      ),
    );
  });
}

