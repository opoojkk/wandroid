import 'package:flutter/material.dart';
import 'package:wandroid/network/service/homeService.dart';

import '../model/articleList/ArticleItemModel.dart';
import '../pages/favoritePage.dart';
import '../pages/login/loginRegisterPage.dart';
import '../pages/search/SearchDetailPage.dart';
import '../pages/web/webViewPage.dart';

class Router {
  // Router._privateConstructor();
  //
  // static final Router _instance = Router._privateConstructor();
  //
  // static Router get instance => _instance;

  openWeb(BuildContext context, String url, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return WebViewPage(url: url, title: title);
        },
      ),
    );
  }

  openArticle(BuildContext context, ArticleItemModel item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return WebViewPage(articleBean: item);
        },
      ),
    );
  }

  openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SearchDetailPage();
        },
      ),
    );
  }

  Future openLogin(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginRegisterPage();
        },
      ),
    );
  }

  Future openFavorite(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FavoritePage(
            request: (page) {
              return HomeService.getArticleListData(0);
            },
          );
        },
      ),
    );
  }

  back(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: child,
      ),
    );
  }
}
