import 'package:dio/dio.dart';

import '../../model/homebanner/HomeBannerModel.dart';
import '../api/home.dart';

class HomeService {
  static void getBanner(Function callback) async {
    Dio().get(Home.homeBanner).then((response) {
      callback(HomeBannerModel.fromJson(response.data));
    });
  }

  static Future<Response> getArticleListData(int page) async {
    return await Dio().get("${Home.homeList}$page/json");
  }
}
