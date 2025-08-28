import 'package:dio/dio.dart';

import '../api/search.dart';
import '../const.dart';
import '../dioClient.dart';

class SearchService {
  static Future<Response> getSearchListData(String key, int page) async {
    FormData formData = FormData.fromMap({"k": key});
    return await DioClient.getDio().post("${Search.searchList}$page/json", data: formData);
  }
}
