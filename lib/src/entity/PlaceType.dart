import 'Base.dart';

class PlaceType extends Base{
    int categoryId;
    String description;    
    String name;    
  PlaceType(Map<String, dynamic> json) : super(json) {
    categoryId = json["category_id"];
    description = json["description"];
    name = json["name"];
  }
  factory PlaceType.fromJson(Map<String, dynamic> json) {
    return PlaceType(json);
  }
}