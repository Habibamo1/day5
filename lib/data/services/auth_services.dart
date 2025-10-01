import 'dart:convert';
import 'package:day5/data/api/api_client.dart';
import 'package:day5/data/models/user_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<UserModel?> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      Response response = await _apiClient.postData(
        '/auth/login',
        body: {"username": username, "password": password},
      );

      if (response.statusCode == 200 && response.data != null) {
        UserModel user = UserModel.fromJson(response.data);
        await prefs.setBool("isLogin", true);
        await prefs.setString("userData", jsonEncode(user.toJson()));
        return user;
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return null;
  }
}
