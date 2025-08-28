import 'dart:convert';

import 'package:wandroid/common/event/eventbus.dart';
import 'package:wandroid/network/service/accountService.dart';

import '../common/Sp.dart';
import '../model/login/UserDetailModel.dart';
import '../model/login/UserModel.dart';
import '../network/dioClient.dart';
import 'event/event.dart';

class User {
  static const String savedUserKeyZero = "player";

  UserDetailModel? userModel;

  static User? _singleton;

  static User get instance {
    _singleton ??= User._internal();
    return _singleton!;
  }

  static UserDetailModel? currentUser() {
    return _singleton?.userModel;
  }

  User._internal() {
    Sp.getS(savedUserKeyZero, (value) {
      if (value != null && value.isNotEmpty) {
        try {
          final userMap = jsonDecode(value);
          userModel = UserDetailModel.fromJson(userMap);
          EventDriver.instance.eventBus.fire(LoginEvent(true));
        } catch (e) {
          userModel = null;
        }
      }
    });
  }

  bool isLogin() {
    return (_singleton?.userModel != null) ? true : false;
  }

  void logout() {
    if (_singleton == null) {
      return;
    }
    _singleton = null;
    Sp.put(savedUserKeyZero, "");
    DioClient.instance.updateCookies("", "");
  }

  void login({
    required String username,
    required String password,
    Function? callback,
  }) {
    AccountService.login(username, password).then((response) {
      final userModel = UserModel.fromJson(response.data);
      if (userModel.errorCode == 0) {
        _singleton?.userModel = userModel.data;
        Sp.put(savedUserKeyZero, jsonEncode(userModel.data.toJson()));
        DioClient.instance.updateCookies(username, password);
        callback?.call(true, "");
      } else {
        callback?.call(false, userModel.errorMsg);
      }
    });
  }

  void register({
    required String username,
    required String password,
    Function? callback,
  }) {
    AccountService.register(username, password).then((response) {
      final userModel = UserModel.fromJson(response.data);
      if (userModel.errorCode == 0) {
        _singleton?.userModel = userModel.data;
        Sp.put(savedUserKeyZero, jsonEncode(userModel.data.toJson()));
        callback?.call(true, "");
      } else {
        callback?.call(false, userModel.errorMsg);
      }
    });
  }
}
