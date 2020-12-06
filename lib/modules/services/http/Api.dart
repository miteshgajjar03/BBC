import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:io';
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

enum RequestType { Get, Post, Delete }

class Api {
  // DELETE
  static Future<ResponseData> requestDelete(
    String api,
    Map<String, dynamic> query,
  ) {
    return _request(
      RequestType.Delete,
      _makeUrl(api, query),
      body: null,
    );
  }

  // POST
  static Future<ResponseData> requestPost(
    String api,
    Map<String, dynamic> query,
    Map<String, dynamic> body,
  ) {
    return _request(
      RequestType.Post,
      _makeUrl(api, query),
      body: body,
    );
  }

  // GET
  static Future<ResponseData> requestGet(
    String api, {
    Map<String, String> query,
  }) async {
    return await _request(
      RequestType.Get,
      _makeUrl(
        api,
        query,
      ),
    );
  }

  static Future<ResponseData> requestGetPaging(
      String api, PageQuery query) async {
    return await _request(
      RequestType.Get,
      _makeUrl(
        api,
        query != null ? query.toQuery() : null,
      ),
    );
  }

  static Future<ResponseData> requestPostUploadImage(
    String api,
    File imageFile,
    String imageFieldName,
    Map<String, dynamic> query,
  ) {
    return _uploadImage(
      _makeUrl(api, query),
      imageFile,
      imageFieldName,
    );
  }

  //
  // GET HEADER
  //
  static Map<String, String> _getHeader() {
    Map<String, String> headerDict = {};
    if (UserManager.shared.authToken.isNotEmpty) {
      headerDict['Authorization'] = UserManager.shared.authToken;
    }
    headerDict['Content-Type'] = 'application/json';
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
          body: json.encode(body),
          headers: _getHeader(),
        );
        break;
      case RequestType.Delete:
        response = await delete(
          url,
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
      return ResponseData(response.body, null);
    }
    return ResponseData(null, "Error while parsing data");
  }

  static Future<ResponseData> _uploadImage(
    String url,
    File imageFile,
    String imageFieldName,
  ) async {
    var postUri = Uri.parse(url);
    print('UPLOAD IMAGE URL :: $postUri');
    MultipartRequest request = MultipartRequest("POST", postUri);
    request.headers.addAll(_getHeader());

    // Map<String, String> map = {};
    // query.forEach((key, value) {
    //   map[key] = '$value';
    // });
    // print('MAP :: $map');
    // request.fields.addAll(map);

    // print('FILE NAME :: ${imageFile.path.split('/').last.split('-').last}');
    if (imageFile != null) {
      MultipartFile multipartFile = await MultipartFile.fromPath(
        imageFieldName,
        imageFile.path,
        filename: imageFile.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    StreamedResponse response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);

    int statusCode = response.statusCode;
    print('UPLOAD IMAGE API RESPONSE :: $responseString');
    if (statusCode == 200) {
      return ResponseData(responseString, null);
    } else if (statusCode == 401) {
      var msg = "ERROR";
      if (response.reasonPhrase is String) {
        var res = json.decode(responseString);
        msg = (res["message"] as String) ?? "ERROR";
      } else {
        print('Error while parsing data');
      }
      return ResponseData(null, msg);
    }
    return ResponseData(null, "Error while parsing data");
  }

  static String _makeUrl(String api, Map<String, dynamic> query) {
    List<dynamic> params = [];
    if (query != null) {
      query.forEach((key, value) {
        params.add(
          key + '=' + value.toString(),
        );
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
