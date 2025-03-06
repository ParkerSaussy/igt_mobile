import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/trip_memories_model.dart';

import '../../../../master/general_utils/common_stuff.dart';

class PreviewTripMemoriesController extends GetxController {
  //TODO: Implement PreviewTripMemoriesController
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  RxList<TripMemoriesModel> lstTripMemoriesImage = <TripMemoriesModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    lstTripMemoriesImage.value = Get.arguments[0];
    currentIndex.value = Get.arguments[1];
    pageController = PageController(initialPage: currentIndex.value);
  }

  /// Navigates to the next page of trip memories.
  ///
  /// If the current page is the last page, it resets the `currentIndex` to 0 and jumps to the first page.
  /// Otherwise, it increments the `currentIndex` and jumps to the next page.
  /// Prints the updated `currentIndex` to the console.

  void onNext() {
    if (lstTripMemoriesImage.length - 1 == currentIndex.value) {
      currentIndex.value = 0;
      pageController.jumpTo(0);
      printMessage("currentIndexif${currentIndex.value}");
    } else {
      currentIndex.value++;
      pageController.jumpToPage(currentIndex.value);
      printMessage("currentIndexelse${currentIndex.value}");
      /* pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);*/
    }
  }

  /// Navigates to the previous page of trip memories.
  ///
  /// If the current page is the first page, it sets the `currentIndex` to the last page
  /// and jumps to that page. Otherwise, it decrements the `currentIndex` and jumps to
  /// the previous page. Prints the current `currentIndex` to the console.

  void onPrevious() {
    printMessage("current page: ${currentIndex.value}");
    if (currentIndex.value == 0) {
      currentIndex.value = lstTripMemoriesImage.length - 1;
      pageController.jumpToPage(currentIndex.value);
    } else {
      currentIndex.value--;
      pageController.jumpToPage(currentIndex.value);
    }
    /*if (currentIndex.value != 0) {
      */ /*currentIndex.value = 0;
      pageController.jumpTo(0);*/ /*


    } */ /*else {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }*/
  }
}
