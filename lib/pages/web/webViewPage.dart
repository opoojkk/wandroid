import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../model/articleList/ArticleItemModel.dart';
import '../../utils/CollectUtil.dart';
import '../../widget/BackBtn.dart';

class WebViewPage extends StatefulWidget {
  final String? url;
  final String? title;
  final ArticleItemModel? articleBean;

  const WebViewPage({super.key, this.url, this.title, this.articleBean});

  @override
  State<StatefulWidget> createState() => _WebViewState();

  String getUrl() {
    return url ?? articleBean?.link ?? "";
  }

  String getTitle() {
    //    return ""; //在标题栏不展示文章title，更加简介
    return title ?? articleBean?.title ?? "";
  }
}

class _WebViewState extends State<WebViewPage> {
  String? toastMsg;
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    _controller ??= WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setOverScrollMode(WebViewOverScrollMode.never)
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2693 MMWEBSDK/201201 Mobile Safari/537.36 MMWEBID/6170 MicroMessenger/7.0.22.1820(0x27001636)",
      )
      ..loadRequest(
        Uri.parse(widget.url ?? widget.articleBean?.link ?? "about:blank"),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          toastMsg ?? widget.getTitle(),
          textAlign: null != toastMsg ? TextAlign.center : TextAlign.start,
          style: null != toastMsg
              ? TextStyle(
                  fontSize: 15.0,
                  // color: Colors.yellow,
                )
              : null,
        ),
        leading: BackBtn(),
        actions: <Widget>[_buildStared(context), _buildOpenWithBrowser()],
      ),
      body: WebViewWidget(controller: _controller!),
      // floatingActionButton: favoriteButton(),
    );
  }

  Widget _buildStared(BuildContext context) {
    if (null == widget.articleBean || null == widget.articleBean?.collect) {
      return Text("");
    } else {
      return IconButton(
        icon: Icon(
          (widget.articleBean?.collect ?? false)
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.white,
        ),
        onPressed: () {
          CollectUtil.updateCollectState(context, widget.articleBean!, (
            bool isOK,
            String errorMsg,
          ) {
            if (isOK) {
              setState(() {
                widget.articleBean!.collect = !widget.articleBean!.collect;
              });
            } else {
              setState(() {
                toastMsg = errorMsg;
              });
              Timer(Duration(seconds: 2), () {
                setState(() {
                  toastMsg = null;
                });
              });
            }
          });
        },
      );
    }
  }

  Widget _buildOpenWithBrowser() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(value: 'open_browser', child: Text('在浏览器中打开')),
          PopupMenuItem(value: 'share', child: Text('分享')),
          PopupMenuItem(value: 'copy_link', child: Text('复制链接')),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'open_browser':
            // 使用url_launcher打开浏览器
            launchUrl(
              Uri.parse(widget.getUrl()),
              mode: LaunchMode.externalApplication,
            );
            break;
          case 'share':
            // Share.share(widget.getUrl(), subject: widget.getTitle());
            break;
          case 'copy_link':
            Clipboard.setData(ClipboardData(text: widget.getUrl()));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('链接已复制到剪贴板')));
            break;
        }
      },
    );
  }
}
