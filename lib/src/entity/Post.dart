
import 'package:getgolo/src/entity/Base.dart';
import 'package:html/parser.dart';

import '../../modules/services/platform/lara/lara.dart';

class Post extends Base {
  int userId;
  String title;
  String content;
  String type;
  String commentStatus;
  List<String> categories;
  String featuredMediaUrl;
  
  Post(Map<String, dynamic> json) : super(json) {
    userId = json["user_id"];
    title = parse(json["title"] ?? "").documentElement.text;
    content = json["content"];
    type = json["type"];
    commentStatus = json["comment_status"];
    // categories
    categories = [];
    List<dynamic> cats = json["categories"];
    cats.forEach((value) {
      categories.add(value["name"]);
    });
    // featured_media_url
    featuredMediaUrl = Lara.baseUrlImage + json["thumb"];
  }
  
}