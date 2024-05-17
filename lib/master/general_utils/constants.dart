// This class contains all the application constants
import '../../app/models/SingleTripPlanModel.dart';
import '../../app/models/reminder_model.dart';

class Constants {
  static const limit = 20;
  static const darkAlfa = 255;
  static const mediumAlfa = 222;
  static const lightAlfa = 189;
  static const veryLightAlfa = 110;
  static const transparentAlpha = 75;
  static const requestTimeout = 100;
  static const inputFieldCount = 6;
  static const timeCounter = 24;
  static const bounceDuration = 40;
  static const bounceDurationIconButtons = 100;
  static const String termsOfUseUrl =
      "https://chamasoko.dashtechinc.com/termsandcondition";

  static const String appShareMessage = "Please check this awesome event app.";
  static const String characterCountLabel = "characters";
  static const String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.chamasoko.app";

  static const REQUEST_MAX_TIMEOUT = 100;
  static const kGoogleApiKey = 'AIzaSyAMxGmzC8cnn0GMXIjZPpIoK1_0bvWY4t4';

  static const videoFileSize = 25;
  static const imageFileSize = 2;

  static const fromLogin = 1;
  static const fromSignUp = 2;
  static const fromForgot = 3;
  static const myProfile = 4;
  static const fromDashboard = 5;
  static const fromCreateTrip = 6;
  static const fromTripDetail = 7;
  static const fromSettings = 8;

  static const payPalPaymentLink = 'https://paypal.me/';
  static const venmoPaymentLink =
      'https://account.venmo.com/payment-link?recipients=%2Cdansinker&txn=pay&amount=200&note=Deposite%20amount';
  //'https://account.venmo.com/payment-link?audience=friends&recipients=%2Cdansinker&txn=pay&amount=200&note=Deposite%20amount';

  static List<ReminderModel> getReminderDaysList() {
    List<ReminderModel> lstReminder = [];
    lstReminder.add(ReminderModel(day: "2 days", daysForApi: "2"));
    lstReminder.add(ReminderModel(day: "3 days", daysForApi: "3"));
    lstReminder.add(ReminderModel(day: "4 days", daysForApi: "4"));
    lstReminder.add(ReminderModel(day: "5 days", daysForApi: "5"));
    lstReminder.add(ReminderModel(day: "6 days", daysForApi: "6"));
    lstReminder.add(ReminderModel(day: "7 days", daysForApi: "7"));
    lstReminder.add(ReminderModel(day: "8 days", daysForApi: "8"));
    return lstReminder;
  }

  static List<SingleTripPlanModel> getSingleTripPlanList() {
    List<SingleTripPlanModel> lstSingleTripPlanModel = [];
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 1,
        title: 'Group Chat',
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: 'IGT!\'s In-App Chat',
        description:
            'Unlock Premium Features For Everyone in the Group!\nBe the Hero!',
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 2,
        title: 'Expense Sharing!',
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: 'IGT!\'s Expense Sharing Tool',
        description:
            'Is Impressively User Friendly While Ensuring No One Gets Left... Holding the Bag, on an Expensive Meal or Night Out.',
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 3,
        title: 'Activities Organizer!',
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: 'IGT! Activities Organizer',
        description:
            'Centralizes all of your trip photos in one location. You can share photos in group chat or dump pictures into the Trip Memories Folder.',
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 4,
        title: 'Document Sharing!',
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: 'IGT!\'s Document Sharing!',
        description:
            'Upload and Centralize Trip Documents Like Event Flyers, Activity and Hotel PDF\'s, and Brochure or Business Card Images.',
        isSelected: false));
    lstSingleTripPlanModel.add(SingleTripPlanModel(
        id: 5,
        title: 'Memories Storage!',
        planImage:
            'https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2834&q=80',
        subTitle: 'IGT!\'s Memories Storage!',
        description:
            'Centralizes your Groups Conversation and Features Photo Sharing which Is Automatically Added into you Trip Memories Section.',
        isSelected: false));
    return lstSingleTripPlanModel;
  }
}

class SocialType {
  static const google = 'google';
  static const apple = 'apple';
}

class SignInType {
  static const email = 'email';
  static const mobile = 'mobile';
  static const social = 'social';
}

class OTPType {
  static const forgot = 'forgot';
  static const verify = 'verify';
  static const updateMobile = 'updatemobile';
}

class EventType {
  static const upcoming = 'upcoming';
  static const past = 'past';
}

class AdsType {
  static const reject = 'reject';
  static const accept = 'accept';
}

/*class FileType {
  static const image = 'image';
  static const video = 'video';
}*/

class MessageType {
  static const CText = 0;
  static const CImage = 1;
  static const CVideo = 2;
}

class NotificationType {
  static const CChat = 0;
  static const CFollow = 1;
  static const CEvent = 2;
}

class Role {
  static const host = "Host";
  static const vip = "VIP";
  static const guest = "Guest";
}

class InviteStatus {
  static const notSent = "Not Sent";
  static const sent = "Sent";
  static const approved = "Approved";
  static const declined = "Declined";
}

class InvitationAcceptReject {
  static const approved = "Approved";
  static const rejected = "Rejected";
}

class DeleteType {
  static const CDeleteForMe = 0;
  static const CDeleteForEveryOne = 1;
}

class ChatType {
  static const singleChat = 'singleChat';
  static const groupChat = 'groupChat';
}

class PlanType {
  static const singlePlan = 'single';
  static const normalPlan = 'normal';
}

class ShortBy {
  static const all = 'all';
  static const upcoming = 'upcoming';
  static const hidePast = 'hidePast';
}
