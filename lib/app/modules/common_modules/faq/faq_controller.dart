import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:lesgo/app/models/faq_list_model.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class FaqController extends GetxController {
  //TODO: Implement FaqController

  RxList<FaqListModel> faqList = <FaqListModel>[].obs;
  RxList<FaqListModel> faqSearchList = <FaqListModel>[].obs;
  RxString restorationFaq = ''.obs;
  var isSelected = false.obs;
  TextEditingController txtFaqSearchController = TextEditingController();
  late dom.Document document;
  int selected = 0;

  @override
  void onInit() {
    super.onInit();
    getFAQ();
    /*for (int i = 0; i < 5; i++) {
      faqList.value.add(FAQList(
          isSelected: false,
          title: "How to login with Google Account?",
          desc:
              "Open your Google Account. You might need to sign in. Choose Security. Scroll down to \"Signing in to other sites\" and choose Signing in with Google."));
    }*/
  }

  void getFAQ() {
    RequestManager.getRequest(
      isSuccessMessage: false,
      isLoader: true,
      hasBearer: true,
      uri: EndPoints.faqList,
      onSuccess: (responseBody, message) {
        faqList.value = List<FaqListModel>.from(
            responseBody["faqData"].map((x) => FaqListModel.fromJson(x)));
        faqSearchList.value = faqList;
        restorationFaq.value = getRandomString();
      },
      onFailure: (error) {
        printMessage("error: $error");
      },
    );
  }
}
