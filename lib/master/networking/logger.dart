import 'package:http/http.dart' as http;

import '../general_utils/common_stuff.dart';

class Log {
  Log.displayResponse({payload, var res, String requestType = 'GET'}) {
    // res as http.Response;
    if (payload != null) {
      String logData = payload.toString();
      if (logData.length > 1000) {
        printWarning("payload : ");
        int maxLogSize = 1000;
        for (int i = 0; i <= logData.length / maxLogSize; i++) {
          int start = i * maxLogSize;
          int end = (i + 1) * maxLogSize;
          end = end > logData.length ? logData.length : end;
          printWarning(logData.substring(start, end));
        }
      } else {
        printWarning("payload : $payload");
      }
    }
    if (res != null && res is http.Response) {
//      print('headers : '+ res.headers.toString());
      printWarning("url : ${res.request!.url}");
      printWarning("requestType : $requestType");
      printWarning("status code : ${res.statusCode}");
      String logData = res.body.toString();
      if (logData.length > 1000) {
        printWarning("response : ");
        int maxLogSize = 1000;
        for (int i = 0; i <= logData.length / maxLogSize; i++) {
          int start = i * maxLogSize;
          int end = (i + 1) * maxLogSize;
          end = end > logData.length ? logData.length : end;
          printWarning(logData.substring(start, end));
        }
      } else {
        printWarning("response : ${res.body}");
      }
    } else {
      printWarning("Log displayResponse is : $res");
    }
  }
}
