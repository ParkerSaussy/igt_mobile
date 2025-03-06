import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/models/expense_resolutions.dart';
import 'package:lesgo/app/models/trip_details_model.dart';

import '../../../../../master/general_utils/common_stuff.dart';
import '../../../../../master/networking/request_manager.dart';

class ExpanseResolutionsController extends GetxController {
  //TODO: Implement ExpanseResolutionsController

  final TextEditingController unequalController = TextEditingController();
  List<ExpenseResolutions> expenseResolutionList = [];
  RxString restorationId = "".obs;
  TripDetailsModel? tripDetailsModel;
  RxBool isResolutionsFound = false.obs;
  RxBool isDataLoading = true.obs;
  void onIndexChange(TripDetailsModel tripDetailsModel) async {
    this.tripDetailsModel = tripDetailsModel;
    printMessage("Role tripDetailsModel.role");
    /*if (tripDetailsModel.role == Role.host) {
      isHost.value = true;
    } else {
      isHost.value = false;
    }*/
    expenseResolutionList.clear();
    restorationId.value = getRandomString();
    isDataLoading.value = true;
    getExpenseResolutions();
  }

  /// Gets expense resolutions from API.
  ///
  /// This method is used to get expense resolutions from API.
  /// It takes trip id as parameter and returns expense resolutions.
  /// If request is successfull, it assigns response to [expenseResolutionList] and
  /// sets [isResolutionsFound] to true.
  /// If request is failed, it shows easy loading and sets [isResolutionsFound] to false.
  ///
  void getExpenseResolutions() {
    RequestManager.postRequest(
      uri: EndPoints.getResolutions,
      hasBearer: true,
      isLoader: true,
      body: {RequestParams.trip_id: tripDetailsModel?.id.toString()},
      isSuccessMessage: false,
      onSuccess: (responseBody, message, status) {
        expenseResolutionList =
            expenseResolutionsFromJson(jsonEncode(responseBody));
        printMessage(
            "expenseResolutionList length: ${expenseResolutionList.length}");
        if (expenseResolutionList.isNotEmpty) {
          isResolutionsFound.value = true;
        } else {
          isResolutionsFound.value = false;
        }
        isDataLoading.value = false;
        restorationId.value = getRandomString();
      },
      onFailure: (error) {
        isDataLoading.value = false;
        printMessage(error);
      },
    );
  }
}
