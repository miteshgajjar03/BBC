import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/src/entity/Amenity.dart';

class PlaceInitialData {
  List<Country> arrCountries = [];
  List<City> arrCity = [];
  List<Amenity> arrAmenity = [];

  Future<bool> getInitialAPIData() async {
    try {
      await Future.wait([
        //_getCountryCityList(),
        _getAmenities(),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  //
  //  GET AMENITY
  //
  Future<bool> _getAmenities() async {
    print('FETCH AMENITY');
    final api = Platform().shared.baseUrl + "app/amenities";
    final response = await Api.requestGet(api);
    try {
      final res = json.decode(response.json) as Map<String, dynamic>;
      final dictData = res['data'] as Map<String, dynamic>;
      final arrData = dictData['data'] as List<dynamic>;

      arrData.forEach((element) {
        final objAmenity = Amenity.fromJSON(json: element);
        arrAmenity.add(objAmenity);
      });

      return true;
    } catch (error) {
      print('ERROR WHILE GETTING COUNTRY LIST :: ${error.toString()}');
      return false;
    }
  }

  //
  // GET COUNTRY LIST
  //
  Future<bool> getCountryCityList() async {
    print('FETCH COUNTRY CITY');
    final api = Platform().shared.baseUrl + "app/country-city";
    final response = await Api.requestGet(api);

    try {
      final res = json.decode(response.json) as Map<String, dynamic>;
      final dataDict = res['data'] as Map<String, dynamic>;
      final countries = dataDict['countries'] as List<dynamic>;
      final city = dataDict['cities'] as List<dynamic>;

      countries.forEach((element) {
        final objCountry = Country.fromJSON(json: element);
        arrCountries.add(objCountry);
      });

      city.forEach((element) {
        final objCity = City.fromJSON(json: element);
        arrCity.add(objCity);
      });
      return true;
    } catch (error) {
      print('ERROR WHILE GETTING COUNTRY LIST :: ${error.toString()}');
      return false;
    }
  }

  //
  // GET CITY GROM COUNTRY ID
  //
  List<City> getCitiesFrom({
    @required int countryID,
  }) {
    final filteredCity = arrCity
        .where(
          (element) => element.countryID == countryID,
        )
        .toList();
    return filteredCity;
  }
}

//
// GET CATEGORY
//

class Country {
  int id = 0;
  String name = '';
  bool isSelected = false;

  Country(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
  }

  //Country({this.id, this.name});

  factory Country.fromJSON({
    @required Map<String, dynamic> json,
  }) {
    return Country(json);
    /*return Country(
      id: json['id'],
      name: json['name'],
    );*/
  }

  /*"id": 21,
  "name": "Canada",
  "slug": "canada",
  "priority": 0,
  "status": 1,
  "seo_title": null,
  "seo_description": null,
  "seo_cover_image": null,
  "created_at": "2020-08-06 13:36:26",
  "updated_at": "2020-08-06 13:36:26"*/

}

class City {
  int id = 0;
  int countryID = 0;
  String name = '';
  double latitude = 0;
  double longitude = 0;
  bool isSelected = false;

  /*City({
    this.id,
    this.name,
    this.countryID,
    this.latitude,
    this.longitude,
  });*/

  City(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    countryID = json['country_id'] ?? 0;
    name = json['name'] ?? '';
    latitude = json['lat'] ?? 0;
    longitude = json['lng'] ?? 0;
  }

  factory City.fromJSON({
    @required Map<String, dynamic> json,
  }) {
    /*return City(
      id: json['id'] ?? 0,
      countryID: json['country_id'] ?? 0,
      name: json['name'] ?? '',
      latitude: json['lat'] ?? 0,
      longitude: json['lng'] ?? 0,
    );*/
    return City(json);
  }

  /*
  "id": 67,
  "country_id": 13,
  "name": "St. Catherine",
  "slug": "st-catherine",
  "intro": null,
  "description": "St Catherine is a parish in the south east of Jamaica. It is located in the county of Middlesex, and is one of the island's largest and most economically valued parishes because of its many resources.",
  "thumb": "5f3165e4a0fe4_1597072868.png",
  "banner": "5f452a03538f2_1598368259.jpg",
  "best_time_to_visit": null,
  "currency": "JMD",
  "language": "English",
  "lat": 18.0364134,
  "lng": -77.0564464,
  "priority": 0,
  "status": 1,
  "seo_title": "St. Catherine Jamaica",
  "seo_description": "St Catherine is a parish in the south east of Jamaica. It is located in the county of Middlesex, and is one of the island's largest and most economically valued parishes because of its many resources.",
  "created_at": "2020-08-07 11:13:21",
  "updated_at": "2020-08-25 15:10:59",
    "translations": [
      {
        "id": 46,
        "city_id": 67,
        "locale": "en",
        "name": "St. Catherine",
        "intro": null,
        "description": "St Catherine is a parish in the south east of Jamaica. It is located in the county of Middlesex, and is one of the island's largest and most economically valued parishes because of its many resources."
      }
    ]
  */
}
