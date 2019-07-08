import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'dart:async';

import 'package:wanandroid_flutter/http/http_utils.dart';

class DataUtils {
  static const String IS_LOGIN = 'isLogin';
  static const String USERNAME = 'userName';

  static Future saveLoginInfo(String userName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(USERNAME, userName);
    sp.setBool(IS_LOGIN, true);
  }

  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(IS_LOGIN) == true;
  }

  static Future<String> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String userName = sp.getString(USERNAME);
    return userName;
  }

  static Future loginOut() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(USERNAME, null);
    sp.setBool(IS_LOGIN, false);
    sp.setString(HttpUtils.COOKIE, '');
  }
}
