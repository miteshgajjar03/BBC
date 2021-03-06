import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/src/entity/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResponseHandler {
  bool isSuccess;
  String message;

  AuthResponseHandler({
    this.isSuccess,
    this.message,
  });
}

class ApiAuth {
  //
  // Login user
  // email, password
  //
  static Future<AuthResponseHandler> loginUsing({
    @required Map<String, String> query,
  }) async {
    var url = Platform().shared.baseUrl + "app/users/login";
    final response = await Api.requestPost(url, null, query);
    if (response.error != null) {
      return AuthResponseHandler(
        isSuccess: false,
        message: response.error,
      );
    } else {
      final res = json.decode(response.json) as Map<String, dynamic>;
      final token = res['token'];
      final tokenType = res['token_type'];
      if (token != null) {
        final isSuccess = await _storeTokenInPreference(
          token: token,
          tokenType: tokenType,
        );
        return AuthResponseHandler(
          isSuccess: isSuccess,
          message: '',
        );
      } else {
        return AuthResponseHandler(
          isSuccess: false,
          message: res['message'] ?? 'Unauthorized',
        );
      }
    }
  }

  //
  // Register user
  // full name, email, password, confirm password
  //
  static Future<AuthResponseHandler> registerUsing({
    @required Map<String, String> query,
  }) async {
    var url = Platform().shared.baseUrl + "app/users/register";
    final response = await Api.requestPost(url, null, query);
    if (response.error != null) {
      return AuthResponseHandler(
        isSuccess: false,
        message: response.error,
      );
    } else {
      return AuthResponseHandler(
        isSuccess: true,
        message: 'Signed up Successfully! Please Login to your account!',
      );
    }
  }

  //
  // Logout
  //
  static Future<AuthResponseHandler> logout() async {
    var url = Platform().shared.baseUrl + "app/users/logout";
    final response = await Api.requestGet(url);

    try {
      final res = json.decode(response.json) as Map<String, dynamic>;
      await _clearAuthToken();
      return AuthResponseHandler(
        isSuccess: (true),
        message: res['message'] as String,
      );
      /*if (res['responseCode'] is int) {
        final responseCode = res['responseCode'] as int;
        if (responseCode == 53) {}
        return AuthResponseHandler(
          isSuccess: (responseCode == 53),
          message: res['message'] as String,
        );
      }
      return AuthResponseHandler(
        isSuccess: false,
        message: res['message'] as String,
      );*/
    } catch (error) {
      await _clearAuthToken();
      return AuthResponseHandler(
        isSuccess: false,
        message: error.toString(),
      );
    }
  }

  //
  // GetUserProfile
  //
  static Future<User> getProfile() async {
    final api = Platform().shared.baseUrl + "app/users";
    final response = await Api.requestGet(api);
    try {
      final userDict = json.decode(response.json) as Map<String, dynamic>;
      final user = User.fromJson(userDict['data']);
      return user;
    } catch (error) {
      print('ERROR WHILE GET USER DATA :: ${error.toString()}');
      return null;
    }
  }

  //
  // Update User Pofile
  //
  static Future<AuthResponseHandler> updateProfile({
    @required Map<String, dynamic> dict,
    @required File imageFile,
    @required String imageFieldName,
  }) async {
    final api = Platform().shared.baseUrl + "app/users/updateProfile";
    final response = await Api.requestPostUploadImage(
      api,
      imageFile,
      imageFieldName,
      dict,
    );

    try {
      final res = json.decode(response.json) as Map<String, dynamic>;
      return AuthResponseHandler(
        isSuccess: true,
        message: res['message'] ?? 'Profile updated Successfully!',
      );
    } catch (error) {
      return AuthResponseHandler(
        isSuccess: true,
        message: error.toString(),
      );
    }
  }

  //
  // Change Password
  //
  static Future<AuthResponseHandler> changePassword({
    @required Map<String, dynamic> dict,
  }) async {
    final api = Platform().shared.baseUrl + "app/users/updatePassword";
    final response = await Api.requestPost(api, null, dict);
    try {
      final res = json.decode(response.json) as Map<String, dynamic>;
      var isSuccess = res['responseCode'] as int == 200;
      return AuthResponseHandler(
        isSuccess: isSuccess,
        message: res['message'] as String ?? '',
      );
    } catch (error) {
      return AuthResponseHandler(
        isSuccess: false,
        message: error.toString(),
      );
    }
  }

  //
  // Store User Data
  //
  static Future<bool> _storeTokenInPreference({
    @required String token,
    @required String tokenType,
  }) async {
    if (token != null) {
      final pref = await SharedPreferences.getInstance();
      final authToken = '$tokenType $token';
      final isSuccess = pref.setString('token', authToken);
      UserManager.shared.authToken = authToken;
      return isSuccess;
    }
    return false;
  }

  static Future<String> getAthToken() async {
    final pref = await SharedPreferences.getInstance();
    final authToken = pref.getString('token');
    printWrapped('\nAUTH TOKEN :: $authToken\n');

    UserManager.shared.authToken = (authToken == null) ? '' : authToken;
    return authToken;
  }

  static Future<bool> _clearAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    final isSuccess = await pref.clear();
    if (isSuccess) {
      UserManager.shared.authToken = '';
    }
    return isSuccess;
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
