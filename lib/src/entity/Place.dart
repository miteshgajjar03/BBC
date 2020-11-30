import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getgolo/GeneralMethods/general_method.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/modules/services/platform/lara/lara.dart';
import 'package:html/parser.dart';

import 'Base.dart';
import 'PlaceCategory.dart';
import 'PlaceType.dart';

class Place extends Base {
  int status;
  String type;
  String imgUrl;
  String featuredMediaUrl;
  List<String> gallery;
  int menuOrder;
  int author;
  String commentStatus;
  String pingStatus;
  String template;
  List<int> types; // Place types id
  // categories
  List<String> category;
  List<PlaceCategory> categories = [];
  List<String> amenities;
  int cityId;
  String description;
  String name;
  String excerpt;
  // Location
  double lat;
  double lng;
  String address;
  // Manual get
  String cityName;
  List<Review> _reviews = [];
  int reviewCount;
  // Rate
  String _rate;
  String get rate {
    return hasRate ? _rate : "(No review)";
  }

  double get doubleRate {
    return hasRate ? double.parse(_rate) : 0;
  }

  bool get hasRate {
    return _rate != null && _rate.isNotEmpty;
  }

  // Price range
  String priceRange;
  // Phone - email - site - facebook - instagram
  String phone;
  String email;
  String facebook;
  String instagram;
  String website;
  // Booking
  String booking;
  String bookingSite;
  int bookingType;
  String bookingBannerId;
  String bookingBannerImageUrl;
  String bookingBannerUrl;
  String bookingForm;
  // Opening time
  Map<String, String> openingTime = {};
  //PLace types
  List<PlaceType> placeTypes;

  //City
  City city;

  Place(Map<String, dynamic> json) : super(json) {
    status = json["status"];
    type = json["type"];
    final thumb = json['thumb'] ?? '';
    featuredMediaUrl = "${Lara.baseUrlImage}$thumb";
    gallery = json["gallery"] != null ? json["gallery"].cast<String>() : [];
    menuOrder = json["menu_order"];
    author = json["author"];
    pingStatus = json["ping_status"];
    template = json["template"];
    description = parse(json["description"] ?? "").documentElement.text;
    name = parse(json["name"]).documentElement.text;
    // place type
    types = json["place-type"] != null ? json["place-type"].cast<int>() : [];
    // cateogries
    category = json["category"] != null ? json["category"].cast<String>() : [];
    // amenities
    amenities =
        json["amenities"] != null ? json["amenities"].cast<String>() : [];
    // cities
    cityId = json["city_id"];
    lat = json["lat"];
    lng = json["lng"];
    address = json["address"];
    // Price range
    var value = json["price_range"];
    if (value == null || value == "None") {
      priceRange = "";
    } else if (value == "Free") {
      priceRange = "Free";
    } else {
      var count = value;
      priceRange = List<String>.generate(count, (int i) => r"$").join();
    }
    // other
    phone = json["phone_number"];
    email = json["email"];
    facebook = json["golo-place_facebook"];
    instagram = json["golo-place_instagram"];
    website = json["website"];
    // booking
    booking = json["golo-place_booking"];
    bookingSite = json["link_bookingcom"];
    bookingType = json["booking_type"];
    // if (bookingType == "banner") {
    //   bookingBannerId = json["golo-place_booking_banner"]["id"];
    //   bookingBannerImageUrl = json["golo-place_booking_banner"]["url"];
    // }
    bookingBannerUrl = json["golo-place_booking_banner_url"];
    bookingForm = json["golo-place_booking_form"];

    // Opening time
    /*
    "golo-opening_monday": "Monday",
  "golo-opening_monday_time": "11:00 AM–9:00 PM",
  "golo-opening_tuesday": "Tuesday",
  "golo-opening_tuesday_time": "11:00 AM–9:00 PM",
  "golo-opening_wednesday": "Wednesday",
  "golo-opening_wednesday_time": "11:00 AM–9:00 PM",
  "golo-opening_thursday": "Thursday",
  "golo-opening_thursday_time": "11:00 AM–9:00 PM",
  "golo-opening_friday": "Friday",
  "golo-opening_friday_time": "11:00 AM–9:00 PM",
  "golo-opening_saturday": "Saturday",
  "golo-opening_saturday_time": "11:00 AM–9:00 PM",
  "golo-opening_sunday": "Sunday",
  "golo-opening_sunday_time": "11:00 AM–9:00 PM",
    */
    // var arr = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
    // openingTime = {};

    // for (int i = 0; i < arr.length; i++) {
    //   var name = json["golo-opening_${arr[i]}"].toString();
    //   var time = json["golo-opening_${arr[i]}_time"].toString();
    //   if (name != null && name.isNotEmpty && time != null && time.isNotEmpty) {
    //     openingTime[name] = time;
    //   }
    // }

    if (json["opening_hour"] != null && json["opening_hour"].length > 0) {
      for (var json in json["opening_hour"]) {
        openingTime[json["title"]] = json["value"];
      }
    }

    // Review count
    reviewCount = json["reviews_count"];
    // rate
    if (json["review_score_avg"] != null) {
      _rate = json["review_score_avg"].toString();
    } else if (json["avg_review"] != null && json["avg_review"].length > 0) {
      for (var j in json["avg_review"]) {
        if (j["place_id"] == id) {
          _rate = j["aggregate"].toString();
        }
      }
    }

    // if (json["categories"].length > 0) {
    //   categories = List<PlaceCategory>();
    //   for (var jsonCat in json["categories"]) {
    //     categories.add(PlaceCategory.fromJson(jsonCat));
    //   }
    // }
    //Place types
    if (json["place_types"] != null && json["place_types"].length > 0) {
      placeTypes = List<PlaceType>();
      for (var json in json["place_types"]) {
        placeTypes.add(PlaceType.fromJson(json));
      }
    }

    if (json["city"] != null) {
      city = City.fromJson(json["city"]);
    }
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(json);
  }

  List<Review> get comments => _reviews;
  void setComments(List<Review> list) {
    _reviews = list ?? [];
  }

  void setRate(String r) {
    _rate = r;
  }

  void setReviewCount(int count) {
    reviewCount = count;
  }

  //
  // ADD/REMOVE TO WISH LIST
  //
  addToWishList({
    @required BuildContext context,
    @required Function(String) onAdded,
  }) async {
    final progress = getProgressIndicator(
      context: context,
    );
    await progress.show();
    Map<String, dynamic> dict = {};
    dict['place_id'] = this.id.toString();
    final api = Platform().shared.baseUrl + "app/users/wishlist";
    final response = await Api.requestPost(api, null, dict);

    await progress.hide();
    String messageString = '';
    try {
      final res = json.decode(response.json) as Map<String, dynamic>;
      if (res['responseCode'] as int == 200) {
        messageString = 'Place added to wishlist successfully!';
      } else {
        messageString = res['message'] as String ?? '';
      }
    } catch (error) {
      messageString = error.toString();
    }
    onAdded(messageString);
  }

  removeFromWishList({@required Function(String, bool) onRemove}) async {
    Map<String, dynamic> dict = {};
    dict['place_id'] = this.id.toString();
    final api = Platform().shared.baseUrl + "app/users/wishlist";
    final response = await Api.requestDelete(api, dict);

    String messageString = '';
    bool isSuccess = true;
    try {
      final res = json.decode(response.json) as Map<String, dynamic>;
      messageString = res['message'] as String ?? '';
    } catch (error) {
      messageString = error.toString();
      isSuccess = false;
    }
    return onRemove(
      messageString,
      isSuccess,
    );
  }
}
