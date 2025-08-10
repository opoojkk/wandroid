import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wandroid/network/service/collectService.dart';

import '../common/User.dart';
import '../model/EmptyModel.dart';
import '../model/articleList/ArticleItemModel.dart';

class CollectUtil {
  static updateCollectState(
    BuildContext context,
    ArticleItemModel model,
    Function callback,
  ) {
    if (!User().isLogin()) {
      callback(false, "收藏需要先登录哈");
    } else {
      if (model.collect) {
        _exeResponse(_unCollectArticle(model), callback);
      } else {
        if (model.link.contains("www.wanandroid.com")) {
          _exeResponse(_collectInnerArticle(model), callback);
        } else {
          _exeResponse(_collectOuterArticle(model), callback);
        }
      }
    }
  }

  static void _exeResponse(Future<Response> responseFuture, Function callback) {
    responseFuture.then((response) {
      var emptyModel = EmptyModel.fromJson(response.data);
      callback(emptyModel.errorCode == 0, emptyModel.errorMsg);
    });
  }

  static Future<Response> _collectInnerArticle(ArticleItemModel model) {
    return CollectService.collectInArticles(model.id);
  }

  static Future<Response> _collectOuterArticle(ArticleItemModel model) {
    return CollectService.collectOutArticles(
      model.title,
      model.author,
      model.link,
    );
  }

  static Future<Response> _unCollectArticle(ArticleItemModel model) {
    return CollectService.unCollectArticle(model.id);
  }
}
