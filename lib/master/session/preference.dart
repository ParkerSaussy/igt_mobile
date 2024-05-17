import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../app/models/user_data.dart';
import '../../app/services/firestore_services.dart';
import '../general_utils/label_key.dart';
import '../networking/request_manager.dart';

///
class Preference {
  static GetStorage? box;
  static const keyBearerToken = 'bearer_token';
  static const sbPreference = 'chama_soko_preference';
  static const keyIsLogin = 'is_login';
  static const keyIsNotification = 'is_notification';
  static const keyIsSkipOnBoarding = 'is_trial_show';
  static const keyIsEventEdit = 'is_event_edit';
  static const keyIsLoaderShow = 'is_loader';
  static const keyLanguage = 'language';
  static const keyUserType = 'userType';
  static const keyFirebaseToken = 'firebase_token';
  static const keyLoginData = 'login_data';
  static const keySetPassword = 'password';
  static const keyDeviceUrl = 'device_url';
  static const keyDeviceName = 'device_name';
  static const keyDeviceAddress = 'device_address';
  static const keyCards = 'cards';
  static const keyToken = 'token';
  static const keyLoginType = 'login_type';
  static const keyVersionCode = 'version_code';
  static const keySpotifyToken = '_sb_spotify_token';
  static const keyIsInvitationNoteDisplayed =
      'key_is_invitation_note_displayed';

  ///
  Future<void> init() async {
    await GetStorage.init(sbPreference);
    box = GetStorage(sbPreference);
  }

  static setIsLogin(bool isLogin) async {
    box?.write(keyIsLogin, isLogin);
  }

  static getIsLogin() {
    if (box != null && box!.hasData(keyIsLogin)) {
      bool cx = box!.read(keyIsLogin);
      if (cx) gc.setLoginData(getLoginResponse());
      return cx;
    }
    return false;
  }

  static isSetNotification(bool isNotification) {
    box?.write(keyIsNotification, isNotification);
  }

  static bool isGetNotification() {
    if (box != null && box!.hasData(keyIsNotification)) {
      bool cx = box!.read(keyIsNotification);
      return cx;
    }
    return false;
  }

  static isInvitationNoteDisplayed(bool isInvitationNoteDisplayed) {
    box?.write(keyIsInvitationNoteDisplayed, isInvitationNoteDisplayed);
  }

  static bool getIsInvitationNoteDisplayed() {
    if (box != null && box!.hasData(keyIsInvitationNoteDisplayed)) {
      bool cx = box!.read(keyIsInvitationNoteDisplayed);
      return cx;
    }
    return false;
  }

  static setLoginResponse(UserData? loginResponse) {
    if (loginResponse == null) {
      box?.write(keyLoginData, '');
      return;
    }
    box?.write(keyLoginData, jsonEncode(loginResponse));
    gc.setLoginData(loginResponse);
  }

  static getLoginResponse() {
    var json = box?.read(keyLoginData);
    if (json == null || json == '') {
      return null;
    }
    UserData loginResponse = UserData.fromJson(jsonDecode(json));
    return loginResponse;
  }

  static setIsSkipOnBoarding(bool isTrial) async {
    box?.write(keyIsSkipOnBoarding, isTrial);
  }

  static getIsSkipOnBoarding() {
    if (box != null && box!.hasData(keyIsSkipOnBoarding)) {
      bool cx = box!.read(keyIsSkipOnBoarding);
      return cx;
    }
    return false;
  }

  static setIsEventEdit(bool isEventEdit) async {
    box?.write(keyIsEventEdit, isEventEdit);
  }

  static getIsEventEdit() {
    if (box != null && box!.hasData(keyIsEventEdit)) {
      bool cx = box!.read(keyIsEventEdit);
      return cx;
    }
    return false;
  }

  static void setLanguage(String lang) {
    box?.write(keyLanguage, lang);
  }

  static getLanguage() {
    if (box != null && box!.hasData(keyLanguage)) {
      String cx = box!.read(keyLanguage);
      return cx;
    }
    return 'EN';
  }

  static void setUserType(String userType) {
    box?.write(keyUserType, userType);
  }

  static getUserType() {
    if (box != null && box!.hasData(keyUserType)) {
      String cx = box!.read(keyUserType);
      return cx;
    }
    return LabelKeys.guest.tr;
  }

  static void setBearerToken(String token) {
    box?.write(keyBearerToken, token);
  }

  ///
  static String getBearerToken() {
    if (box != null && box!.hasData(keyBearerToken)) {
      return box!.read(keyBearerToken) ?? '';
    }
    return '';
  }

  ///
  static void setFirebaseToken(String token) {
    box?.write(keyFirebaseToken, token);
  }

  static getFirebaseToken() {
    if (box != null && box!.hasData(keyFirebaseToken)) {
      return box!.read(keyFirebaseToken);
    }
    return '';
  }

  static setShowLoader(bool isLogin) async {
    await box?.write(keyIsLoaderShow, isLogin);
  }

  static bool? getShowLoader() {
    if (box != null && box!.hasData(keyIsLoaderShow)) {
      return box!.read(keyIsLoaderShow);
    }
    return false;
  }

  static void setPassword(String password) {
    box?.write(keySetPassword, password);
  }

  static getPassword() {
    if (box != null && box!.hasData(keySetPassword)) {
      String cx = box!.read(keySetPassword);
      return cx;
    }
    return '';
  }

  static void setDeviceImage(String url) {
    box?.write(keyDeviceUrl, url);
  }

  static void setDeviceName(String name) {
    box?.write(keyDeviceName, name);
  }

  static getDeviceImage() {
    if (box != null && box!.hasData(keyDeviceUrl)) {
      String cx = box!.read(keyDeviceUrl);
      return cx;
    }
    return '';
  }

  static getDeviceName() {
    if (box != null && box!.hasData(keyDeviceName)) {
      String cx = box!.read(keyDeviceName);
      return cx;
    }
    return '';
  }

  static setSpotifyToken(String token) {
    box?.write(keySpotifyToken, token);
  }

  static String getSpotifyToken() {
    if (box != null && box!.hasData(keySpotifyToken)) {
      return box?.read(keySpotifyToken);
    }
    return '';
  }

  static setLoginType(String loginType) {
    box?.write(keyLoginType, loginType);
  }

  static getLoginType() {
    if (box?.read(keyLoginType) != null) {
      return box?.read(keyLoginType);
    }
    return 'email';
  }

  static setVersionCode(String versionCode) {
    box?.write(keyVersionCode, versionCode);
  }

  static getVersionCode() {
    if (box?.read(keyVersionCode) != null) {
      return box?.read(keyVersionCode);
    }
    return '1.0.0';
  }

  static void clearPreference() {
    FireStoreServices.clearFirebaseToken(
        userId: gc.loginData.value.id.toString());
    Preference.setBearerToken('');
    Preference.setLoginType('');
    Preference.setFirebaseToken('');
    Preference.setIsLogin(false);
    Preference.setLoginResponse(UserData());
  }
}
