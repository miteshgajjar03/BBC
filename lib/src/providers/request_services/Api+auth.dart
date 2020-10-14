import 'package:flutter/material.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuth {
  //
  // Login user
  // email, password
  //
  static Future<bool> loginUsing(
      {Map<String, String> query, @required BuildContext context}) async {
    var url = Platform().shared.baseUrl + "app/users/login";
    final response = await Api.requestPost(url, null, query);
    if (response.error != null) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  //
  // Register user
  // full name, email, password, confirm password
  //
  static Future<bool> registerUsing(
      {Map<String, String> query, @required BuildContext context}) async {
    var url = Platform().shared.baseUrl + "app/users/register";
    final response = await Api.requestPost(url, null, query);
    if (response.error != null) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  //
  // Store User Data
  //
  Future<bool> _storeUserInPreference({String token}) async {
    final pref = await SharedPreferences.getInstance();
    final isSuccess = pref.setString('token', token);
    return isSuccess;
  }
}
