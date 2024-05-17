import 'dart:convert';

import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html/parser.dart' as htmlparser;

import '../../../../master/general_utils/common_stuff.dart';
import '../../../../master/general_utils/label_key.dart';
import '../../../../master/networking/request_manager.dart';
import '../../../models/cms_data.dart';

class AboutUsController extends GetxController {
  var restorationId = ''.obs;
  //RxList<String> lstImageURL = <String>[].obs;
  int? selectedIndex;
  var requestType = ''.obs;
  var termscond = ''.obs;
  RxInt from = 0.obs;
  late dom.Document document;
  @override
  void onInit() {
    super.onInit();

    requestType.value = Get.arguments[0];
    from.value = Get.arguments[1];
    Future.delayed(const Duration(milliseconds: 100), () {
      getCMS();
    });
    /* lstImageURL.add(
        "https://images.unsplash.com/photo-1469474968028-56623f02e42e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1748&q=80");
    lstImageURL.add(
        "https://images.unsplash.com/photo-1433086966358-54859d0ed716?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=774&q=80");
    lstImageURL.add(
        "https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80");
  */
  }

  void getCMS() async {
    var body = {
      RequestParams.type: requestType.value == LabelKeys.termsAndCondition.tr
          ? LabelKeys.termsCondition.tr
          : requestType.value == LabelKeys.privacyPolicy.tr
              ? LabelKeys.privacyPolicy.tr
              : LabelKeys.aboutus.tr,
    };

    RequestManager.postRequest(
      uri: EndPoints.getCms,
      isLoader: true,
      isBtnLoader: false,
      isSuccessMessage: false,
      isFailedMessage: true,
      body: body,
      onSuccess: (response, message, status) {
        if (status) {
          var getCMSData = cmsDataFromJson(jsonEncode(response['cmsData']));
          var termsconds = parse(getCMSData.description.toString());
          termscond.value = termsconds.outerHtml;
          document = htmlparser.parse(termscond.value);
        }
      },
      onFailure: (error) {
        printMessage(error);
      },
    );
  }
}
