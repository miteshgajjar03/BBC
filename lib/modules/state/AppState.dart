import 'package:getgolo/src/entity/Category.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/PlaceAmenity.dart';
import 'package:getgolo/src/entity/PlaceType.dart';
import 'package:getgolo/src/entity/Post.dart';

class AppState {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }
  // Cities
  List<City> cities = [];
  // Popular cities (Home screen)
  List<City> popularCities = [];
  // Categories | Amenities
  List<Category> categories = [];
  List<PlaceAmenity> amenities = [];
  // Posts
  List<Post> posts = [];
  // Place of current city
  // City currentCity;
  // List<Place> places = [];
  List<PlaceType> placeTypes = [];

  AppState._internal();
  // void clearCurrentCity() {
  // currentCity = null;
  // places.clear();
  // }

}
