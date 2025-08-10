import 'dart:async';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/articleList/ArticleItemModel.dart';
import '../../model/articleList/ArticleListModel.dart';
import '../../widget/EmptyHolder.dart';
import '../../widget/QuickTopFloatBtn.dart';
import 'articleItemPage.dart';

typedef Future<Response> RequestData(int page);
typedef ShowQuickTop = void Function(bool show);

class ArticleListPage extends StatefulWidget {
  final Widget? header;
  final RequestData request;
  final String? emptyMsg;
  final bool? keepAlive;
  final ShowQuickTop? showQuickTop;
  final bool? selfControl;

  const ArticleListPage({
    Key? key,
    this.header,
    required this.request,
    this.emptyMsg,
    this.selfControl = true,
    this.showQuickTop,
    this.keepAlive = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage>
    with AutomaticKeepAliveClientMixin {
  List<ArticleItemModel> _listData = [];
  final List<int> _listDataId = [];
  GlobalKey<QuickTopFloatBtnState> _quickTopFloatBtnKey = new GlobalKey();
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
      return EmptyHolder(
        msg: (widget.emptyMsg == null)
            ? (_haveMoreData ? "Loading" : "not found")
            : widget.emptyMsg,
      );
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
      child: RefreshIndicator(
        child: listView,
        // color: GlobalConfig.colorPrimary,
        onRefresh: handleRefresh,
      ),
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
    if (_listData.length <= 0 || index < 0 || index >= _listData.length) {
      return Container();
    }
    return ArticleItemPage(_listData[index]);
  }

  Widget _buildLoadMoreItem() {
    return Center(
      child: Padding(padding: EdgeInsets.all(10.0), child: Text("Loading ...")),
    );
  }

  Future<Null> handleRefresh() async {
    _listDataPage = -1;
    _listData.clear();
    _listDataId.clear();
    await _loadNextPage();
  }

  bool isLoading = false;

  Future<Null> _loadNextPage() async {
    if (isLoading || !this.mounted) {
      return null;
    }
    isLoading = true;
    _listDataPage++;
    var result = await _loadListData(_listDataPage);
    //至少加载8个，如果初始化加载不足，则加载下一页,如果使用递归的话需要考虑中止操作
    // if (_listData.length < 8) {
    //   _listDataPage++;
    //   result = await _loadListData(_listDataPage);
    // }
    if (this.mounted) setState(() {});
    isLoading = false;
    return result;
  }

  ScrollController? _controller;

  ScrollController? getControllerForListView() {
    if (widget.selfControl ?? false) {
      if (null == _controller) _controller = ScrollController();
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
      if (newList.length > 0) {
        //        _listData.addAll(newList);
        //防止添加进重复数据
        newList.forEach((item) {
          if (!_listDataId.contains(item.id)) {
            _listData.add(item);
            _listDataId.add(item.id);
          }
        });
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
