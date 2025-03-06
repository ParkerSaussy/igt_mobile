import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/lrf/biomateric_auth.dart';
import 'package:lesgo/app/routes/app_pages.dart';
import 'package:lesgo/master/networking/request_manager.dart';

import '../../master/general_utils/common_stuff.dart';
import '../../master/session/preference.dart';

class FcmService {
  static bool isChatDetailOpen = false;
  static var conversationID = "";
  static var serverKey =
      "AAAAd2hiAsQ:APA91bHUHRb8KgCCnXBo6MKRDWJrJsJK6yMpjFbsOWunvuqQxFwoHCkYxnlCTwwJII5K41VK2hgWknlrEcJs3qJPgn0C56-9j1SJmv2QRfc1m9b9ONZSYRrofxZq4uiKwyfYP1oEvuko";
  AndroidNotificationChannel? channel;

  void printWarning(var text) {
    printMessage('\x1B[33m$text\x1B[0m');
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the local notification plugin.
  ///
  /// This function will be called when the app is initialized.
  /// It will initialize the local notification plugin with the default settings.
  /// When the user taps on a notification, it will navigate to the corresponding screen.
  /// If the user is not logged in, it will navigate to the login screen.
  /// If the user is logged in, it will navigate to the corresponding screen based on the type of notification.
  /// The type of notification is determined by the 'type' key in the payload of the notification.
  /// The following types are supported:
  /// - groupChat: Navigate to the chat details screen with the trip id and type as groupChat.
  /// - singleChat: Navigate to the chat details screen with the conversation id and type as singleChat.
  /// - invite: Navigate to the trip detail screen with the trip id.
  /// - due_date: Navigate to the trip detail screen with the trip id.
  /// - accept_invite: Navigate to the trip detail screen with the trip id.
  /// - reject_invite: Navigate to the trip detail screen with the trip id.
  /// - add_city: Navigate to the trip detail screen with the trip id.
  /// - add_date: Navigate to the trip detail screen with the trip id.
  /// - activity: Navigate to the activities detail screen with the trip id.
  /// - plan: Navigate to the subscription plan screen.
  /// - trip: Navigate to the trip detail screen with the trip id.
  /// - ge: Navigate to the expense resolution tabs screen with the trip id.
  Future<void> initLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        printMessage("FCM flutterLocalNotificationsPlugin");
        if (Preference.getIsLogin()) {
          Preference.isSetNotification(true);
          final payload = decodePayload(details.payload.toString());
          if (payload['type'] == 'groupChat') {
            Get.offAllNamed(Routes.CHAT_DETAILS_SCREEN, arguments: [
              int.parse(payload['tripId'].toString()),
              'groupChat'
            ]);
          } else if (payload['type'] == 'singleChat') {
            Get.offAllNamed(Routes.CHAT_DETAILS_SCREEN, arguments: [
              payload['conversationId'].toString(),
              'singleChat'
            ]);
          } else if (payload['type'] == 'invite') {
            Get.offAllNamed(Routes.TRIP_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'due_date') {
            Get.offAllNamed(Routes.TRIP_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'accept_invite') {
            Get.offAllNamed(Routes.TRIP_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'reject_invite') {
            Get.offAllNamed(Routes.TRIP_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'add_city') {
            Get.offAllNamed(Routes.TRIP_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'add_date') {
            Get.offAllNamed(Routes.TRIP_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'activity') {
            Get.offAllNamed(Routes.ACTIVITIES_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'plan') {
            Get.offAllNamed(Routes.SUBSCRIPTION_PLAN_SCREEN);
          } else if (payload['type'] == 'trip') {
            Get.offAllNamed(Routes.TRIP_DETAIL,
                arguments: [int.parse(payload['tripId'].toString())]);
          } else if (payload['type'] == 'ge') {
            Get.offAllNamed(Routes.EXPANSE_RESOLUTION_TABS,
                arguments: [int.parse(payload['tripId'].toString())]);
          }
        }
      },
    );
  }

  /// Decodes the payload of a notification.
  ///
  /// The payload is expected to be a string in the format of a JSON object.
  /// The function will split the string into key-value pairs and return a map.
  ///
  /// For example, if the payload is '{"key1":"value1","key2":"value2"}',
  /// the function will return {key1: value1, key2: value2}.
  Map<String, String> decodePayload(String payload) {
    var entries = payload
        .substring(1, payload.length - 1)
        .split(RegExp(r',\s?'))
        .map((e) => e.split(RegExp(r':\s?')))
        .map((e) => MapEntry(e.first, e.last));
    var result = Map.fromEntries(entries);
    return result;
  }

  getFCMToken() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      printMessage('FCM Token - $token');
      Preference.setFirebaseToken(token!);
    }).onError((error, stackTrace) {
      printMessage('FCM error - $error');
    });
  }

  /// Register notification
  ///
  /// This function will request permission for push notifications,
  /// and set up the notification channel.
  ///
  /// If the user is not logged in, it will not request permission.
  ///
  /// If the user is logged in, it will request permission and set up the notification channel.
  /// It will also listen for the following events:
  /// - `onMessage`: When a message is received while the app is in the foreground.
  /// - `onMessageOpenedApp`: When a message is received while the app is in the background.
  /// - `onBackgroundMessage`: When a message is received while the app is in the background.
  ///
  /// The notification will be displayed using the local notification plugin.
  /// The notification will have the following properties:
  /// - `title`: The title of the notification.
  /// - `body`: The body of the notification.
  /// - `payload`: The payload of the notification.
  /// - `sound`: The sound of the notification.
  /// - `badge`: The badge of the notification.
  /// - `vibrate`: The vibration of the notification.
  /// - `channelId`: The id of the notification channel.
  /// - `channelName`: The name of the notification channel.
  /// - `channelDescription`: The description of the notification channel.
  Future<void> registerNotification() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // titleescription
      importance: Importance.high,
    );
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (GetPlatform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      if (info.model.toLowerCase().contains("ipad")) {
        printMessage("its iPad");
      } else {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true,
        );
      }
    } else {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );
    }

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Preference.isSetNotification(true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          printMessage("ECM getInitialMessage");
          Future.delayed(
            const Duration(milliseconds: 1700),
            () {
              if (Preference.getIsLogin()) {
                Get.offAll(BiomatericAuth(message: message,));
              }
            },
          );
        });
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      printMessage("sdf: ${message.data}");
      printMessage("FCM onMessage");
      showLocalNotifications(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Preference.isSetNotification(true);
      printMessage("FCM onMessageOpenedApp");
      if (Preference.getIsLogin()) {
        Get.offAll(BiomatericAuth(message: message,));
        /*if (message.data['type'] == 'groupChat') {
          Get.toNamed(Routes.CHAT_DETAILS_SCREEN, arguments: [
            int.parse(message.data['tripId'].toString()),
            'groupChat'
          ]);
        } else if (message.data['type'] == 'singleChat') {
          Get.offAllNamed(Routes.CHAT_DETAILS_SCREEN, arguments: [
            message.data['conversationId'].toString(),
            'singleChat'
          ]);
        } else if (message.data['type'] == 'invite') {
          Get.offAllNamed(Routes.TRIP_DETAIL,
              arguments: [int.parse(message.data['tripId'].toString())]);
        } else if (message.data['type'] == 'due_date') {
          Get.offAllNamed(Routes.TRIP_DETAIL,
              arguments: [int.parse(message.data['tripId'].toString())]);
        } else if (message.data['type'] == 'accept_invite') {
          Get.offAllNamed(Routes.TRIP_DETAIL,
              arguments: [int.parse(message.data['tripId'].toString())]);
        } else if (message.data['type'] == 'reject_invite') {
          Get.offAllNamed(Routes.TRIP_DETAIL,
              arguments: [int.parse(message.data['tripId'].toString())]);
        } else if (message.data['type'] == 'add_city') {
          Get.offAllNamed(Routes.TRIP_DETAIL,
              arguments: [int.parse(message.data['tripId'].toString())]);
        } else if (message.data['type'] == 'add_date') {
          Get.offAllNamed(Routes.TRIP_DETAIL,
              arguments: [int.parse(message.data['tripId'].toString())]);
        } else if (message.data['type'] == 'plan') {
          Get.offAllNamed(Routes.SUBSCRIPTION_PLAN_SCREEN);
        } else if (message.data['type'] == 'activity') {
          Get.offAllNamed(Routes.ACTIVITIES_DETAIL,
              arguments: [int.parse(message.data['tripId'].toString())]);
        } else if (message.data['type'] == 'ge') {
          Get.offAllNamed(Routes.EXPANSE_RESOLUTION_TABS,
              arguments: [int.parse(message.data['tripId'].toString())]);
        }*/
      }
    });

    FirebaseMessaging.onBackgroundMessage(
        (message) => showLocalNotifications(message));
  }

  showLocalNotifications(RemoteMessage message) async {
    printMessage("dsfsdf: ${message.data}");
    printMessage("FCM showLocalNotifications");
    const iosNotificationDetail = DarwinNotificationDetails(
        presentAlert: false, presentBadge: false, presentSound: false);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel!.id, channel!.name);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetail);
    if (message.data['tripId'] != gc.chatTripId.value) {
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data.toString());
    }
  }
}
