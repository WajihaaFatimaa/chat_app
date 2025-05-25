import 'dart:convert';

import 'package:chat_app/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Storage._internal();
  static final Storage _instance = Storage._internal();

  factory Storage() => _instance;

  late SharedPreferences _pref;

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<void> saveUser(User user) async {
    String savedUser = jsonEncode(user.toJson());
    _pref.setString(
      "loggedInUser",
      savedUser,
    );
  }

  User? getUser() {
    String? myUser = _pref.getString("loggedInUser");
    if (myUser != null) {
      return User.fromJson(jsonDecode(myUser));
    } else {
      return null;
    }
  }

  Future<bool> logout() async {
    await _pref.remove("loggedInUser");
    return true;
  }
}
