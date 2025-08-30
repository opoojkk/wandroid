import 'dart:async';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/articleList/ArticleItemModel.dart';
import '../../model/articleList/ArticleListModel.dart';
import '../../widget/QuickTopFloatBtn.dart';
import '../../widget/bototmLoading.dart';
import 'articleItemPage.dart';

typedef RequestData = Future<Response> Function(int page);
typedef ShowQuickTop = void Function(bool show);

class ArticleListPage extends StatefulWidget {
  final Widget? header;
  final RequestData request;
  final String? emptyMsg;
  final bool? keepAlive;
  final ShowQuickTop? showQuickTop;
  final bool? selfControl;

  const ArticleListPage({
    super.key,
    this.header,
    required this.request,
    this.emptyMsg,
    this.selfControl = true,
    this.showQuickTop,
    this.keepAlive = false,
  });

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  final List<ArticleItemModel> _listData = [];
  final List<int> _listDataId = [];
  final GlobalKey<QuickTopFloatBtnState> _quickTopFloatBtnKey = new GlobalKey();
  int _listDataPage = -1;
  var _haveMoreData = true;
  double _screenHeight = 0;
  late ListView listView;

  @override
  bool get wantKeepAlive => widget.keepAlive ?? false;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  void handleScroll(double offset, {ScrollController? controller}) {
    ((null == controller) ? _controller : controller)?.animateTo(
      offset,
      duration: Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var itemCount =
        _listData.length +
        (null == widget.header ? 0 : 1) +
        (_haveMoreData ? 1 : 0);
    if (itemCount <= 0) {
      return BottomLoadingIndicator();
    }
    listView = ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      controller: getControllerForListView(),
      itemBuilder: (context, index) {
        if (index == 0 && null != widget.header) {
          return widget.header;
        } else if (index - (null == widget.header ? 0 : 1) >=
            _listData.length) {
          return _buildLoadMoreItem();
        } else {
          return _buildListViewItemLayout(
            context,
            index - (null == widget.header ? 0 : 1),
          );
        }
      },
    );

    var body = NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: RefreshIndicator(onRefresh: handleRefresh, child: listView),
    );
    return (null == widget.showQuickTop)
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            body: body,
            floatingActionButton: QuickTopFloatBtn(
              key: _quickTopFloatBtnKey,
              onPressed: () {
                handleScroll(0.0);
              },
            ),
          )
        : body;
  }

  bool onScrollNotification(ScrollNotification scrollNotification) {
    if (scrollNotification.metrics.pixels >=
        scrollNotification.metrics.maxScrollExtent) {
      _loadNextPage();
    }
    if (_screenHeight <= 0) {
      _screenHeight = MediaQueryData.fromView(ui.window).size.height;
    }
    if (scrollNotification.metrics.axisDirection == AxisDirection.down &&
        _screenHeight >= 10 &&
        scrollNotification.metrics.pixels >= _screenHeight) {
      if (null != widget.showQuickTop) {
        widget.showQuickTop?.call(true);
      } else {
        _quickTopFloatBtnKey.currentState?.refreshVisible.call(true);
      }
    } else {
      if (null != widget.showQuickTop) {
        widget.showQuickTop?.call(false);
      } else {
        _quickTopFloatBtnKey.currentState?.refreshVisible(false);
      }
    }
    return false;
  }

  Widget _buildListViewItemLayout(BuildContext context, int index) {
    if (_listData.isEmpty || index < 0 || index >= _listData.length) {
      return Container();
    }
    return ArticleItemPage(_listData[index]);
  }

  Widget _buildLoadMoreItem() {
    return BottomLoadingIndicator();
  }

  Future<Null> handleRefresh() async {
    _listDataPage = -1;
    _listData.clear();
    _listDataId.clear();
    await _loadNextPage();
  }

  bool isLoading = false;

  Future<Null> _loadNextPage() async {
    if (isLoading || !mounted) {
      return null;
    }
    isLoading = true;
    _listDataPage++;
    var result = await _loadListData(_listDataPage);
    if (mounted) setState(() {});
    isLoading = false;
    return result;
  }

  ScrollController? _controller;

  ScrollController? getControllerForListView() {
    if (widget.selfControl ?? false) {
      _controller ??= ScrollController();
      return _controller;
    } else {
      return null;
    }
  }

  Future<Null> _loadListData(int page) {
    _haveMoreData = true;
    return widget.request(page).then((response) {
      var newList = ArticleListModel.fromJson(response.data).data.datas;
      var originListLength = _listData.length;
      if (newList.isNotEmpty) {
        //防止添加进重复数据
        for (var item in newList) {
          if (!_listDataId.contains(item.id)) {
            _listData.add(item);
            _listDataId.add(item.id);
          }
        }
      }
      _haveMoreData = originListLength != _listData.length;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _listData.clear();
    _listDataId.clear();
    super.dispose();
  }
}
