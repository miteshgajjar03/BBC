import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:getgolo/src/entity/User.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:http/http.dart';

class ResponseData {
  dynamic json;
  String error;
  ResponseData(
    this.json,
    this.error,
  );
}

enum RequestType { Get, Post }

class Api {
  // POST
  static Future<ResponseData> requestPost(
      String api, Map<String, String> query, Map<String, dynamic> body) {
    return _request(RequestType.Post, _makeUrl(api, query), body: body);
  }

  // GET
  static Future<ResponseData> requestGet(String api,
      {Map<String, String> query}) async {
    return await _request(RequestType.Get, _makeUrl(api, query));
  }

  static Future<ResponseData> requestGetPaging(
      String api, PageQuery query) async {
    return await _request(
        RequestType.Get, _makeUrl(api, query != null ? query.toQuery() : null));
  }

  //
  // GET HEADER
  //
  static Map<String, String> _getHeader() {
    Map<String, String> headerDict = {};
    if (UserManager.shared.authToken.isNotEmpty) {
      headerDict['Authorization'] = UserManager.shared.authToken;
    }
    return headerDict;
  }

  // REQUEST
  static Future<ResponseData> _request(RequestType type, String url,
      {Map<String, dynamic> body}) async {
    // make request
    Response response;
    switch (type) {
      case RequestType.Get:
        response = await get(
          url,
          headers: _getHeader(),
        );
        break;
      case RequestType.Post:
        response = await post(
          url,
          body: body,
          headers: _getHeader(),
        );
        break;
    }
    // sample info available in response
    print(
      "RESPONSE:--> \n URL:-- $url \n parameters:-- $body \n Body:-- ${response.body}\n StatusCode:-- ${response.statusCode}",
    );
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return ResponseData(response.body, null);
    } else if (statusCode == 401) {
      var msg = "ERROR";
      if (response.body is String) {
        var res = json.decode(response.body);
        msg = (res["message"] as String) ?? "ERROR";
      } else {
        print('Error while parsing data');
      }
      return ResponseData(null, msg);
    }
    return ResponseData(null, "Error while parsing data");
  }

  static String _makeUrl(String api, Map<String, String> query) {
    var params = [];
    if (query != null) {
      query.forEach((key, value) {
        params.add(key + "=" + value);
      });
    } else {
      return api;
    }
    if (api.contains("?")) {
      if (api.endsWith("?")) {
        return api + params.join("&");
      }
      return api + "&" + params.join("&");
    }
    return api + "?" + params.join("&");
  }
}
