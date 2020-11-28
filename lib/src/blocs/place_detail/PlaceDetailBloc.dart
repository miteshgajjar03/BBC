import 'dart:async';

import 'package:getgolo/src/blocs/Bloc.dart';
import 'package:getgolo/src/entity/PlaceCategory.dart';
import 'package:getgolo/src/entity/PlaceType.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/src/entity/Place.dart';
import 'package:getgolo/src/entity/PlaceAmenity.dart';
import 'package:getgolo/src/providers/request_services/PlaceProvider.dart';

class PlaceDetailBloc implements Bloc {
  // Data
  List<PlaceAmenity> amenities = [];
  List<Review> reviews = [];
  List<Place> similarPlaces = [];
  List<PlaceCategory> categories = [];
  List<PlaceType> placeTypes = [];
  Place _place;
  // Stream
  final _placeController = StreamController<Place>.broadcast();
  Stream<Place> get placeController => _placeController.stream;

  PlaceDetailBloc(Place place) : super() {
    _place = place;
  }

  int get placeId {
    return _place.id;
  }

  void fetchData(int placeId) async {
    final response = await PlaceProvider.getPlaceDetail("$placeId");
    print("Fetched places of city $placeId");
    if (response.error == null && response.json["data"] != null) {
      // place
      if (response.json["data"]["place"] != null) {
        _place = Place.fromJson(response.json["data"]["place"]);
        if (response.json["data"]["review_score_avg"] != null) {
          var r = response.json["data"]["review_score_avg"].toString();
          _place.setRate(r);
        }
      }

      // amenities
      amenities = [];
      if (response.json["data"]["amenities"].length > 0) {
        for (var json in response.json["data"]["amenities"]) {
          amenities.add(PlaceAmenity.fromJson(json));
        }
      }
      // Reviews
      if (response.json["data"]["reviews"].length > 0) {
        for (var json in response.json["data"]["reviews"]) {
          reviews.add(Review.fromJson(json));
        }
        _place.reviewCount = reviews.length;
      }
      // similarPlaces
      if (response.json["data"]["similar_places"].length > 0) {
        for (var json in response.json["data"]["similar_places"]) {
          similarPlaces.add(Place.fromJson(json));
        }
      }
      if (response.json["data"]["categories"].length > 0) {
        for (var json in response.json["data"]["categories"]) {
          categories.add(PlaceCategory.fromJson(json));
        }
      }
      if (response.json["data"]["place_types"].length > 0) {
        for (var json in response.json["data"]["place_types"]) {
          placeTypes.add(PlaceType.fromJson(json));
        }
      }
      if (!_placeController.isClosed) {
        _placeController.sink.add(_place);
      }
    }
  }

  @override
  void dispose() {
    _placeController.close();
  }
}
