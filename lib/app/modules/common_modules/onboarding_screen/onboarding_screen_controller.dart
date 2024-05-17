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
  void onInit() {
    super.onInit();
    fromDashboard.value = Get.arguments;
    callApiForYoutubeVideoList();
    refreshMethod();
  }

  void refreshMethod() {
    //refreshController.loadComplete();
    //refreshController.refreshCompleted();
    //refreshKey.value = getRandomString();
  }

  void onSkip() {
    if (fromDashboard.value) {
      Get.back();
    } else {
      Preference.setIsSkipOnBoarding(true);
      Get.offAllNamed(Routes.LOGIN);
    }
  }

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

  void addEmptyData() {
    for (int i = 0; i < 5; i++) {
      youTubeVideoUrls.add(YouTubeVideoUrls(value: ""));
    }
  }

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
