import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wandroid/common/Sp.dart';

class DioClient {
  Dio dio = Dio();
  static DioClient? _instance;

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  DioClient._internal() {
    _getCookies();
  }

  static Dio getDio() {
    return instance.dio;
  }

  void updateCookies(String userName, String password) {
    _updateCookies(userName, password);
    _saveCookies(userName, password);
  }

  void _updateCookies(String userName, String password) {
    dio.options.headers["Cookie"] =
        "loginUserName=$userName;loginUserPassword=$password";
  }

  void _saveCookies(String userName, String password) {
    Sp.put("loginUserName", userName);
    Sp.put("loginUserPassword", password);
  }

  void _getCookies() {
    Sp.getS("loginUserName", (value) {});
    Sp.getS("loginUserPassword", (value) {});
    SharedPreferences.getInstance().then((prefs) {
      String username = prefs.getString('loginUserName') ?? "";
      String password = prefs.getString('loginUserPassword') ?? "";
      if (username.isNotEmpty && password.isNotEmpty) {
        _updateCookies(username, password);
      }
    });
  }
}
