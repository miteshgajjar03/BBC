
import 'package:getgolo/modules/services/platform/lara/lara.dart';

import 'Base.dart';

class PlaceAmenity extends Base {
  String name;
  String iconUrl;


  PlaceAmenity(Map<String, dynamic> json) : super(json){
    name = json["name"];
    iconUrl = Lara.baseUrlImage + json["icon"];
  }
  

  factory PlaceAmenity.fromJson(Map<String, dynamic> json) {
    return PlaceAmenity(json);
  }
  
}