import 'package:flutter/material.dart';

import 'articleList/articleListPage.dart';

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('收藏')),
      body: ArticleListPage(request: widget.request),
    );
  }
}

class FavoritePage extends StatefulWidget {
  final RequestData request;

  const FavoritePage({super.key, required this.request});

  @override
  State<StatefulWidget> createState() {
    return _FavoritePageState();
  }
}
