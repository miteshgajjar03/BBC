import 'dart:convert';

import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';

class ApiSearch {
  static Future<ResponseData> searchPlaces(String text) {
    var url = Platform().shared.baseUrl + "app/places/search?keyword=$text";
    return Api.requestGet(url).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"]["places"];
      return ResponseData(jsonData, data.error);
    });
  }
}
