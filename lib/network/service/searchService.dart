import 'package:dio/dio.dart';

import '../api/search.dart';

class SearchService {
  static Future<Response> getSearchListData(String key, int page) async {
    FormData formData = FormData.fromMap({"k": key});
    return await Dio().post("${Search.searchList}$page/json", data: formData);
  }
}
