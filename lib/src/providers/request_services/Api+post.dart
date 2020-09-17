

import 'dart:convert';

import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:getgolo/src/providers/request_services/response/ResponseListData.dart';

class ApiPost {
  static Future<ResponseListData> fetchPosts({PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/posts/inspiration";
    return Api.requestGetPaging(url, query).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"] as List;      
      return ResponseListData(jsonData, data.error);
    });
  }

  

  
}