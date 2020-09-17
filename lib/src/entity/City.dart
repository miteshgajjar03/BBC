import '../../modules/services/platform/lara/lara.dart';
import 'Base.dart';

class City extends Base {
  int count;
  String name;
  String description;
  // Get from other request
  String featuredImage; // media?slug=$slug
  String country;
  String intro;
  double lat;
  double lng;
  String address;
  String visitTime;
  String currency;
  String language;
  int status;

  City(Map<String, dynamic> json) : super(json) {
    count = json["places_count"];
    name = json["name"];
    description = json["description"];
    country = json["country"] != null ? json["country"]["name"] : "";
    intro = json["intro"];
    lat = json["lat"];
    lng = json["lng"];
    featuredImage = "${Lara.baseUrlImage}${json["thumb"] ?? ""}";
    status = json["status"];
    visitTime = json["best_time_to_visit"];
    currency = json["currency"];
    language = json["language"];
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(json);
  }
}
