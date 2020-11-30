import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:getgolo/src/providers/request_services/response/ResponseListData.dart';
import 'package:getgolo/src/views/myPlaces/my_places_screen.dart';

class PlaceProvider {
  static Future<ResponseListData> getFeature(String cityId, {PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/cities/$cityId";
    return Api.requestGetPaging(url, query).then((data) {
      var placesJson = data.json != null ? json.decode(data.json) as Map : null;
      //var jsonData = placesJson["data"]["features"] as List;
      var jsonData = placesJson["features"] as List;
      return ResponseListData(jsonData, data.error);
    });
  }

  static Future<ResponseData> getPlaceDetail(String placeId,
      {PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/places/$placeId";
    return Api.requestGet(url).then((data) {
      var jsonData = data.json != null ? json.decode(data.json) : null;
      return ResponseData(jsonData, data.error);
    });
  }

  static Future<ResponseListData> getPlaceTypes({PageQuery query}) {
    var url = Platform().shared.baseUrl + "place-type";
    return Api.requestGetPaging(url, query).then((data) {
      var typesJson = data.json != null ? json.decode(data.json) : null;
      return ResponseListData(typesJson, data.error);
    });
  }

  static Future<List<Review>> getPlaceComments(int placeId, {PageQuery query}) {
    var url = Platform().shared.baseUrl + "comments?post=$placeId";
    return Api.requestGetPaging(url, query).then((response) {
      List<dynamic> items = json.decode(response.json);
      if (items != null && items.length > 0) {
        return List<Review>.generate(items.length, (i) => Review(items[i]));
      }
      return null;
    });
  }

  static Future<List<Place>> getPlace({
    @required PlaceListType listType,
  }) {
    String url = '';
    if (listType == PlaceListType.myPlace) {
      url = Platform().shared.baseUrl + "app/users/place";
    } else if (listType == PlaceListType.wishList) {
      url = Platform().shared.baseUrl + "app/users/getWishlist";
    }
    return Api.requestGetPaging(url, null).then(
      (response) {
        final res = json.decode(response.json) as Map<String, dynamic>;
        final dictData = res['data'] as Map<String, dynamic>;
        List<dynamic> items = dictData['data'];

        try {
          if (items != null && items.length > 0) {
            return List<Place>.generate(
              items.length,
              (i) => Place(items[i]),
            );
          }
        } catch (error) {
          print('ERROR WHILE FETCHING PLACE :: ${error.toString()}');
        }
        return null;
      },
    );
  }

  static Future<List<Place>> getPlaceByCategoryID({
    @required List<int> categoryIDs,
  }) async {
    if (categoryIDs == null) {
      return [];
    }
    final api = Platform().shared.baseUrl + "app/search-listing";
    Map<String, dynamic> dict = {
      'category': categoryIDs,
    };

    return Api.requestPost(api, null, dict).then(
      (response) {
        final res = json.decode(response.json) as Map<String, dynamic>;
        final dictData = res['data'] as Map<String, dynamic>;
        List<dynamic> items = dictData['data'];

        try {
          if (items != null && items.length > 0) {
            return List<Place>.generate(
              items.length,
              (i) => Place(items[i]),
            );
          }
        } catch (error) {
          print('ERROR WHILE FETCHING PLACE :: ${error.toString()}');
        }
        return null;
      },
    );
  }
}
