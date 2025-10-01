import 'dart:convert';
import 'package:day5/data/models/user_models.dart';
import 'package:day5/data/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authServices = AuthService();

  UserModel? userModel;
  bool isLoading = false;

  UserProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("userData");
    if (data != null) {
      final decoded = jsonDecode(data);
      userModel = UserModel.fromJson(decoded);
    } else {
      userModel = null;
    }
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    if (userModel != null) {
      userModel!.username = newUsername;
      notifyListeners();
    }
  }

  /// login function that returns true if success, false if fail
  Future<bool> login() async {
    isLoading = true;
    notifyListeners();

    try {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      final user = await authServices.login(username, password);
      if (user != null) {
        userModel = user;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userData", jsonEncode(user.toJson()));

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userData");
    userModel = null;
    notifyListeners();
  }
}
