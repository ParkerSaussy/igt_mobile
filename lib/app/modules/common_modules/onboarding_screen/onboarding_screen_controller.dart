import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/session/preference.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../master/networking/request_manager.dart';
import '../../../models/you_tube_video_urls.dart';
import '../../../routes/app_pages.dart';

class OnboardingScreenController extends GetxController {
  RxInt currentIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  RxBool fromDashboard = false.obs;
  RxBool isVideoPlaying = false.obs;
  RxString restorationId = "".obs;
  List<YouTubeVideoUrls> youTubeVideoUrls = [];
  List lstSlides = [
    ImagesPath.onBoarding00,
    ImagesPath.onBoarding01,
    ImagesPath.onBoarding02,
    ImagesPath.onBoarding03,
    ImagesPath.onBoarding04,
  ];
//https://www.youtube.com/watch?v=vIjjICFf6Kc
  List youtubeLinks = [
    "",
    "",
    "vIjjICFf6Kc",
    "",
    "",
  ];

  List onBoardingTitles = [
    LabelKeys.istGoTimeMsg1.tr,
    LabelKeys.itsGoTimeMsg2.tr,
    LabelKeys.itsGoTimeMsg3.tr,
    LabelKeys.itsGoTimeMsg4.tr,
    LabelKeys.itsGoTimeMsg5.tr
  ];

  late YoutubePlayerController youtubePlayerController;
  // RefreshController refreshController = RefreshController(initialRefresh: false);
  // var refreshKey = ''.obs;

  @override
  /// This is called when the widget is initialized.
  /// It sets the [fromDashboard] from the Get arguments,
  /// calls the API to get the YouTube video URLs and
  /// calls [refreshMethod] to refresh the screen.
  void onInit() {
    super.onInit();
    fromDashboard.value = Get.arguments;
    callApiForYoutubeVideoList();
    refreshMethod();
  }

  /// This method is used to refresh the screen.
  ///
  /// It calls the [loadComplete] and [refreshCompleted] methods
  /// of the [refreshController] and regenerates the [refreshKey].
  ///
  /// This method is used when the user wants to refresh the
  /// onboarding screen.
  void refreshMethod() {
    //refreshController.loadComplete();
    //refreshController.refreshCompleted();
    //refreshKey.value = getRandomString();
  }

  /// This method is used when the user taps on the skip button.
  ///
  /// If [fromDashboard] is true, it navigates back to the previous screen.
  /// Otherwise, it sets the value of [isSkipOnBoarding] to true,
  /// and navigates to the login screen.
  void onSkip() {
    if (fromDashboard.value) {
      Get.back();
    } else {
      Preference.setIsSkipOnBoarding(true);
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  /// This method is used when the user taps on the next button.
  ///
  /// If the current index is the last index of [lstSlides], it checks if [fromDashboard] is true or false.
  /// If [fromDashboard] is true, it navigates back to the previous screen.
  /// Otherwise, it sets the value of [isSkipOnBoarding] to true,
  /// and navigates to the login screen.
  /// If the current index is not the last index of [lstSlides], it moves to the next page.
  /// Finally, it sets the value of [isVideoPlaying] to false.
  void onNext() {
    if (lstSlides.length - 1 == currentIndex.value) {
      if (fromDashboard.value) {
        Get.back();
      } else {
        Preference.setIsSkipOnBoarding(true);
        Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
    isVideoPlaying.value = false;
  }

  /// This method is used to call the API to get the YouTube video URLs.
  ///
  /// It calls the [RequestManager.postRequest] method with the [EndPoints.youtubeUrls] endpoint,
  /// [hasBearer] set to true, [isLoader], [isFailedMessage], and [isSuccessMessage] set to false,
  /// and [body] set to `{RequestParams.type: "walkthrough"}`.
  ///
  /// If the response is successful, it clears the [youTubeVideoUrls] list and adds the response to it.
  /// If the [youTubeVideoUrls] list is empty, it calls the [addEmptyData] method to add empty data to it.
  /// Finally, it sets a new value to [restorationId] using [getRandomString].
  ///
  /// If the response is not successful, it calls the [addEmptyData] method to add empty data to the [youTubeVideoUrls] list and prints the error message.
  void callApiForYoutubeVideoList() {
    RequestManager.postRequest(
        uri: EndPoints.youtubeUrls,
        hasBearer: true,
        isLoader: false,
        isFailedMessage: false,
        isSuccessMessage: false,
        body: {RequestParams.type: "walkthrough"},
        onSuccess: (responseBody, message, status) {
          youTubeVideoUrls.clear();
          youTubeVideoUrls = youTubeVideoUrlsFromJson(jsonEncode(responseBody));
          if (youTubeVideoUrls.isEmpty) {
            addEmptyData();
          }
          restorationId.value = getRandomString();
        },
        onFailure: (error) {
          addEmptyData();
          printMessage("error: $error");
        });
  }

  /// This method is used to add empty data to the [youTubeVideoUrls] list.
  ///
  /// It loops 5 times and adds an empty [YouTubeVideoUrls] object to the list.
  ///
  /// This method is used when the API call to get the YouTube video URLs is not successful.
  ///
  /// It sets the value of [restorationId] to a new random string after adding empty data to the list.
  void addEmptyData() {
    for (int i = 0; i < 5; i++) {
      youTubeVideoUrls.add(YouTubeVideoUrls(value: ""));
    }
  }

  /// Displays a dialog containing a YouTube player for the given [videoUrl].
  ///
  /// The dialog is non-dismissible and shows the YouTube video using the
  /// [YoutubePlayerController] with the extracted video ID. The player
  /// is set to autoplay and hide controls. The dialog includes a close
  /// button at the top-right corner which disposes the controller and
  /// closes the dialog when tapped.
  ///
  /// - Parameters:
  ///   - context: The build context in which the dialog is displayed.
  ///   - videoUrl: The URL of the YouTube video to be played in the dialog.

  Future<void> showYouTubePlayerDialog(
      BuildContext context, String videoUrl) async {
    printMessage("Video Url: $videoUrl ID: ${extractYouTubeVideoId(videoUrl)}");
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: extractYouTubeVideoId(videoUrl),
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        hideControls: true,
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingSmall),
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Stack(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    YoutubePlayer(
                      controller: youtubePlayerController,
                      showVideoProgressIndicator: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    youtubePlayerController.dispose();
                    Get.back();
                  },
                  child: SvgPicture.asset(IconPath.closeRoundedIcon),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Extracts the YouTube video ID from the given [videoUrl].
  ///
  /// The extracted video ID is returned as a string.
  ///
  /// - Parameters:
  ///   - videoUrl: The YouTube video URL to extract the ID from.
  ///
  /// Returns an empty string if the [videoUrl] does not match the regular expression pattern.
  String extractYouTubeVideoId(String videoUrl) {
    // Define a regular expression pattern to match YouTube video URLs
    RegExp regExp = RegExp(
      r'^https:\/\/www\.youtube\.com\/watch\?v=([A-Za-z0-9_-]+)',
      caseSensitive: false,
      multiLine: false,
    );

    // Use RegExp to match and extract the video ID
    Match? match = regExp.firstMatch(videoUrl);

    if (match != null && match.groupCount >= 1) {
      // Extracted video ID is in group 1
      String videoId = match.group(1)!;
      return videoId;
    } else {
      // Return an empty string if no match is found
      return '';
    }
  }
}
