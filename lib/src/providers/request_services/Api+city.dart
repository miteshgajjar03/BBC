import 'dart:convert';

import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:getgolo/src/providers/request_services/response/ResponseListData.dart';



class ApiCity {
  static Future<ResponseListData> fetchCities({PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/cities";
    return Api.requestGetPaging(url, query).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"] as List;      
      return ResponseListData(jsonData, data.error);
    });
  }

  static Future<ResponseListData> fetchCitiesPopular({PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/cities/popular";
    return Api.requestGetPaging(url, query).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"] as List;      
      return ResponseListData(jsonData, data.error);
    });
  }

  static Future<ResponseData> fetchCity(String id) {
    var url = Platform().shared.baseUrl + "cities/$id";
    
    return Api.requestGet(url);
  }

  // Category
  static Future<ResponseListData> fetchCategories() {
    var url = Platform().shared.baseUrl + "categories";
    return Api.requestGet(url).then((data) {
      return ResponseListData(json.decode(data.json), data.error);
    });
  }

  // Amenities
  static Future<ResponseListData> fetchAmenities({PageQuery query}) {
    var url = Platform().shared.baseUrl + "place-amenities";
    return Api.requestGetPaging(url, query).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"] as List;      
      return ResponseListData(jsonData, data.error);
    });
  }
  
}
