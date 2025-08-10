import 'package:dio/dio.dart';
import 'package:wandroid/network/api/account.dart';

class AccountService {
  static Future<Response> login(String? username, String? password) async {
    FormData formData = FormData.fromMap({
      "username": "$username",
      "password": "$password",
    });
    return await Dio().post(Account.login, data: formData);
  }

  static Future<Response> register(String? username, String? password) async {
    FormData formData = FormData.fromMap({
      "username": "$username",
      "password": "$password",
      "repassword": "$password",
    });
    return await Dio().post(Account.register, data: formData);
  }
}
