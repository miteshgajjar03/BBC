
import 'package:getgolo/modules/services/platform/lara/lara.dart';
import 'package:getgolo/src/entity/Base.dart';

class User extends Base {
  String name;
  String email;
  String avatarUrl;
  String phoneNumber;
  String facebook;
  String instagram;
  int isAdmin;
  int status;

  User(Map<String, dynamic> json) : super(json){
    name = json["name"];
    email = json["email"];
    avatarUrl = Lara.baseUrlImage + json["avatar"];
    phoneNumber = json["phone_number"];
    facebook = json["facebook"];
    instagram = json["instagram"];
    isAdmin = json["is_admin"];
    status = json["status"];
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(json);
  }
}