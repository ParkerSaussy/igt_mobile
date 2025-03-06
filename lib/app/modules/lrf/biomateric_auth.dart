import 'dart:io' as io;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/networking/request_manager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../../../master/session/preference.dart';
import '../../routes/app_pages.dart';

class BiomatericAuth extends StatefulWidget {
  final RemoteMessage? message;
  bool isClose = false;

  BiomatericAuth({super.key, this.message, this.isClose = false});

  @override
  State<BiomatericAuth> createState() => _BiomatericAuthState();
}

class _BiomatericAuthState extends State<BiomatericAuth> {


  final LocalAuthentication auth = LocalAuthentication();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authBiometrics();
  }

  /// Authenticate the user using biometric authentication. If the user is
  /// successfully authenticated, the app will navigate to the next screen.
  /// If the user is not authenticated, the app will show an alert dialog
  /// asking the user to authenticate.
  ///
  /// If the device does not support biometric authentication, the app
  /// will navigate to the next screen. If the device does not have any
  /// biometric authentication enrolled, the app will show an alert dialog
  /// asking the user to enroll.
  ///
  /// If the user is locked out or permanently locked out of biometric
  /// authentication, the app will navigate to the next screen.
  ///
  /// If biometric authentication is not available, the app will show an
  /// alert dialog asking the user to authenticate on iOS, and will navigate
  /// to the next screen on Android.
  ///
  /// If any other error occurs, the app will show a snack toast with the
  /// error message.
  Future<void> authBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if(canAuthenticate){
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to use ItsGoTime App',
            options: const AuthenticationOptions()
        );
        if(didAuthenticate){
          goToNextScreen();
        }else{
          _showAlertDialog();
        }
        print("didAuthenticate: ${didAuthenticate}");
      } on PlatformException catch (e) {
        printMessage("Bio Exception ${e.message} ${e.code}");
        if (e.code == auth_error.notEnrolled) {
          // Add handling of no hardware here.
          goToNextScreen();
        } else if (e.code == auth_error.lockedOut ||
            e.code == auth_error.permanentlyLockedOut) {
          goToNextScreen();
        } else if (e.code == auth_error.notAvailable) {
          if(io.Platform.isIOS){
            _showAlertDialog();
          }else{
            goToNextScreen();
          }
        } else {
          printMessage("Auth error " + e.message.toString() + " " + e.code);
          RequestManager.getSnackToast(message: "Something went wrong please try again ${e.message!}");
        }
      }
    }else{
      printMessage("Can't authenticate");
      goToNextScreen();
    }
  }

  /// Navigate to the next screen based on the type of message.
  ///
  /// If `isClose` is true, navigate back.
  /// If `message` is null, navigate to the dashboard screen.
  /// If `message.type` is 'groupChat', navigate to the chat details screen
  /// with the trip ID and type as 'groupChat'.
  /// If `message.type` is 'singleChat', navigate to the chat details screen
  /// with the conversation ID and type as 'singleChat'.
  /// If `message.type` is 'invite', navigate to the trip detail screen
  /// with the trip ID.
  /// If `message.type` is 'due_date', navigate to the trip detail screen
  /// with the trip ID.
  /// If `message.type` is 'accept_invite', navigate to the trip detail screen
  /// with the trip ID.
  /// If `message.type` is 'reject_invite', navigate to the trip detail screen
  /// with the trip ID.
  /// If `message.type` is 'add_city', navigate to the trip detail screen
  /// with the trip ID.
  /// If `message.type` is 'add_date', navigate to the trip detail screen
  /// with the trip ID.
  /// If `message.type` is 'plan', navigate to the subscription plan screen.
  /// If `message.type` is 'activity', navigate to the activities detail screen
  /// with the trip ID.
  /// If `message.type` is 'ge', navigate to the expense resolution tabs screen
  /// with the trip ID.
  /// If `message.type` is none of the above, navigate to the dashboard screen.
  void goToNextScreen(){
    if(widget.isClose){
      Get.back();
      return;
    }
    if(widget.message == null){
      Get.offAllNamed(Routes.DASHBOARD);
    }else{
      if (widget.message!.data['type'] == 'groupChat') {
        Get.toNamed(Routes.CHAT_DETAILS_SCREEN, arguments: [
          int.parse(widget.message!.data['tripId'].toString()),
          'groupChat'
        ]);
      } else if (widget.message!.data['type'] == 'singleChat') {
        Get.offAllNamed(Routes.CHAT_DETAILS_SCREEN, arguments: [
          widget.message!.data['conversationId'].toString(),
          'singleChat'
        ]);
      } else if (widget.message!.data['type'] == 'invite') {
        Get.offAllNamed(Routes.TRIP_DETAIL,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      } else if (widget.message!.data['type'] == 'due_date') {
        Get.offAllNamed(Routes.TRIP_DETAIL,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      } else if (widget.message!.data['type'] == 'accept_invite') {
        Get.offAllNamed(Routes.TRIP_DETAIL,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      } else if (widget.message!.data['type'] == 'reject_invite') {
        Get.offAllNamed(Routes.TRIP_DETAIL,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      } else if (widget.message!.data['type'] == 'add_city') {
        Get.offAllNamed(Routes.TRIP_DETAIL,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      } else if (widget.message!.data['type'] == 'add_date') {
        Get.offAllNamed(Routes.TRIP_DETAIL,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      } else if (widget.message!.data['type'] == 'plan') {
        Get.offAllNamed(Routes.SUBSCRIPTION_PLAN_SCREEN);
      } else if (widget.message!.data['type'] == 'activity') {
        Get.offAllNamed(Routes.ACTIVITIES_DETAIL,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      } else if (widget.message!.data['type'] == 'ge') {
        Get.offAllNamed(Routes.EXPANSE_RESOLUTION_TABS,
            arguments: [int.parse(widget.message!.data['tripId'].toString())]);
      }else{
        Preference.isSetNotification(false);
        Get.offAllNamed(Routes.DASHBOARD);
      }
    }
  }

  /// Displays an alert dialog informing the user that the app is locked 
  /// and requires authentication for access.
  ///
  /// The dialog provides an option to 'Unlock now', which will close 
  /// the dialog and trigger the biometric authentication process.

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ItsGoTime is locked'),
          content: Text('Authentication is required to access the ItsGoTime app'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
                authBiometrics();
              },
              child: Text('Unlock now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: Container(

      ),
    );
  }
}
