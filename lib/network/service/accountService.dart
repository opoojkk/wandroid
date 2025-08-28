import 'package:dio/dio.dart';
import 'package:wandroid/network/api/account.dart';

import '../const.dart';
import '../dioClient.dart';

class AccountService {
  static Future<Response> login(String? username, String? password) async {
    FormData formData = FormData.fromMap({
      "username": "$username",
      "password": "$password",
    });
    return await DioClient.getDio().post(Account.login, data: formData);
  }

  static Future<Response> register(String? username, String? password) async {
    FormData formData = FormData.fromMap({
      "username": "$username",
      "password": "$password",
      "repassword": "$password",
    });
    return await DioClient.getDio().post(Account.register, data: formData);
  }
}
