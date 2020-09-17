import 'package:html/parser.dart';

import 'Base.dart';
import 'Place.dart';

class PlaceCategory extends Base {
  String name;
  int priority;
  int isFeature;
  String featureTitle;
  String iconMapMarker; // .svg
  String type;
  int status;
  List<Place> places;

  PlaceCategory(Map<String, dynamic> json) : super(json) {
    id = json["category_id"];
    name = parse(json["category_name"] ?? "").documentElement.text;
    priority = json["priority"];
    isFeature = json["is_feature"];
    featureTitle = json["feature_title"];
    iconMapMarker = json["icon_map_marker"];
    type = json["type"];
    status = json["status"];
    if (json["places"] != null && json["places"].length > 0) {
      places = [];
      for (json in json["places"]) {
        places.add(Place.fromJson(json));
      }
    } else
      places = [];
  }

  factory PlaceCategory.fromJson(Map<String, dynamic> json) {
    return PlaceCategory(json);
  }
}
