import 'package:getgolo/src/entity/User.dart';
import 'Base.dart';

class Review extends Base {
  int userId;
  int placeId;
  int score;
  String comment;
  int status;
  User user;
  String createdAt;
  String updatedAt;
  Review(Map<String, dynamic> json) : super(json) {
    userId = json["user_id"];
    placeId = json["place_id"];
    score = json["score"];
    comment = json["comment"];
    status = json["status"];
    user = User.fromJson(json["user"]);
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(json);
  }
}
