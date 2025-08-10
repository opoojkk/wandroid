import 'package:flutter/material.dart';
import 'package:wandroid/network/service/searchService.dart';

import '../../widget/BackBtn.dart';
import '../../widget/ClearableInputField.dart';
import '../articleList/articleListPage.dart';

class SearchDetailPage extends StatefulWidget {
  SearchDetailPage();

  @override
  State<StatefulWidget> createState() => new _SearchDetailPageState();
}

class _SearchDetailPageState extends State<SearchDetailPage> {
  String _key = "";
  GlobalKey<ArticleListPageState> _itemListPage = new GlobalKey();
  final String loadingMsg = "Search whatever you want";
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: ArticleListPage(
        key: _itemListPage,
        emptyMsg: "It's empty.",
        request: (page) {
          return SearchService.getSearchListData(_key, page);
        },
      ),
    );
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      leading: BackBtn(),
      title: ClearableInputField(
        hintTxt: "搜索",
        controller: _controller,
        border: InputBorder.none,
        onchange: (str) {
          print("print:${str}");
          _key = str;
          _itemListPage.currentState?.handleRefresh();
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
