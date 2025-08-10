import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wandroid/network/service/accountService.dart';

import '../common/Sp.dart';
import '../model/login/UserDetailModel.dart';
import '../model/login/UserModel.dart';
import '../utils/DateUtil.dart';

class User {
  UserDetailModel? userModel;

  static User? _singleton;

  static UserDetailModel? currentUser() {
    return _singleton?.userModel;
  }

  bool isLogin() {
    return (_singleton?.userModel?.token.isNotEmpty) ?? false;
  }

  void logout() {
    if (_singleton == null) {
      return;
    }
    _singleton = null;
  }

  void login({
    required String username,
    required String password,
    Function? callback,
  }) {

    AccountService.login(username, password).then((response) {
      final userModel = UserModel.fromJson(response.data);
      if (userModel.errorCode == 0) {}
    });
  }

  void register({
    required String username,
    required String password,
    Function? callback,
  }) {
    AccountService.register(username, password).then((response) {
      final userModel = UserModel.fromJson(response.data);
      if (userModel.errorCode == 0) {}
    });
  }

  void _saveUserInfo(
    Future<Response> responseF,
    String userName,
    String password, {
    Function? callback,
  }) {
    responseF.then((response) {
      var userModel = UserModel.fromJson(response.data);
      if (userModel.errorCode == 0) {
        Sp.putUserName(userName);
        Sp.putPassword(password);
        String cookie = "";
        DateTime expires = DateTime.now();
        response.headers.forEach((String name, List<String> values) {
          if (name == "set-cookie") {
            cookie = json
                .encode(values)
                .replaceAll("\[\"", "")
                .replaceAll("\"\]", "")
                .replaceAll("\",\"", "; ");
            try {
              expires = DateUtil.formatExpiresTime(cookie) ?? DateTime.now();
            } catch (e) {}
          }
        });
        Sp.putCookie(cookie);
        Sp.putCookieExpires(expires.toIso8601String());
        callback?.call(true, "");
      } else {
        callback?.call(false, userModel.errorMsg);
      }
    });
  }
}
