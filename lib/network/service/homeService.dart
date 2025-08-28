import 'package:dio/dio.dart';

import '../../model/homebanner/HomeBannerModel.dart';
import '../api/home.dart';
import '../const.dart';
import '../dioClient.dart';

class HomeService {
  static void getBanner(Function callback) async {
    DioClient.getDio().get(Home.homeBanner).then((response) {
      callback(HomeBannerModel.fromJson(response.data));
    });
  }

  static Future<Response> getArticleListData(int page) async {
    return await DioClient.getDio().get("${Home.homeList}$page/json");
  }
}
