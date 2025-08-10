import 'package:flutter/material.dart';
import 'package:wandroid/network/service/searchService.dart';

import '../../widget/BackBtn.dart';
import '../articleList/articleListPage.dart';

class SearchDetailPage extends StatefulWidget {
  const SearchDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _SearchDetailPageState();
}

class _SearchDetailPageState extends State<SearchDetailPage> {
  String _key = "";
  final GlobalKey<ArticleListPageState> _itemListPage = GlobalKey();
  final String loadingMsg = "Search whatever you want";
  final _controller = TextEditingController();

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
      title: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '搜索',
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () {
              _controller.clear();
            },
            child: Icon(Icons.close),
          ),
        ),
        onChanged: (content) {
          _key = content;
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
