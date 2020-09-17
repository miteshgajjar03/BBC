import 'Base.dart';

class Category extends Base {
  String name;
  String description;
  // Get from other request
  int priority; // media?slug=$slug
  int isFeature;
  String featureTitle;
  String iconMapMarker;
  String colorCode;
  String type;
  int status;
  String seoTitle;
  String seoDescription;
  String createdAt;
  String updatedAt;

  Category(Map<String, dynamic> json) : super(json) {
    name = json["name"];
    description = json["description"];
    priority = json["priority"];
    isFeature = json["is_feature"];
    featureTitle = json["feature_title"];
    colorCode = json["color_code"] ?? "#19CDD8";
    iconMapMarker = json["icon_map_marker"] ?? "";
    type = json["type"];
    status = json["status"];
    seoTitle = json["seo_title"];
    seoDescription = json["seo_description"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(json);
  }
}
