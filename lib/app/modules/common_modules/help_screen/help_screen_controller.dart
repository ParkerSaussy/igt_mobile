import 'dart:convert';

import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:lesgo/app/models/cms_data.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class HelpScreenController extends GetxController {
  //TODO: Implement HelpScreenController

  var termscond = ''.obs;
  late dom.Document document;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCMS();
  }

  /// Fetches CMS data for the help section from the server.
  ///
  /// This function sends a POST request to the CMS endpoint with the 'Help' type
  /// specified in the request body. Upon a successful response, it parses the
  /// CMS data to extract the description and updates the `termscond` observable
  /// with the HTML content. The HTML document is also parsed and stored in the
  /// `document` variable. If the request fails, an error message is printed.

  void getCMS() async {
    var body = {
      RequestParams.type: "Help",
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
