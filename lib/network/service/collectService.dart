import 'package:dio/dio.dart';
import 'package:wandroid/network/api/collect.dart';

class CollectService {
 static Future<Response> getCollectListData(int page) async {
    return await Dio().get("${Collect.collectList}$page/json");
  }

 static  Future<Response> collectInArticles(int id) async {
    return await Dio().post("${Collect.collectInSite}$id/json");
  }

 static Future<Response> unCollectArticle(int id) async {
    return await Dio().post("${Collect.uncollect}$id/json");
  }

 static Future<Response> collectOutArticles(
    String title,
    String author,
    String link,
  ) async {
    FormData formData = FormData.fromMap({
      "title": title,
      "author": author,
      "link": link,
    });
    return await Dio().post(Collect.collectOutSite, data: formData);
  }
}
