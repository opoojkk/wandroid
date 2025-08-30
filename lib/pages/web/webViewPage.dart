import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
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
  State<WebViewPage> createState() => _WebViewPageState();

  String getUrl() => url ?? articleBean?.link ?? "";

  String getTitle() => title ?? articleBean?.title ?? "";
}

class _WebViewPageState extends State<WebViewPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  WebViewController? _controller;
  String? toastMsg;

  // AppBar 显隐控制
  bool _isAppBarVisible = true;
  late AnimationController _appBarAnimCtrl;
  late Animation<Offset> _appBarOffset;

  // 滚动相关
  double _lastY = 0.0;
  DateTime _lastToggleTs = DateTime.fromMillisecondsSinceEpoch(0);
  static const double _toggleThreshold = 24.0; // 触发显隐的最小位移
  static const int _toggleCooldownMs = 180; // 冷却时间(ms)

  @override
  void initState() {
    super.initState();
    _appBarAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _appBarOffset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1))
        .animate(
          CurvedAnimation(parent: _appBarAnimCtrl, curve: Curves.easeInOut),
        );

    _initWebView();
  }

  @override
  void dispose() {
    _appBarAnimCtrl.dispose();
    super.dispose();
  }

  void _toggleAppBar(bool show) {
    final now = DateTime.now();
    if (now.difference(_lastToggleTs).inMilliseconds < _toggleCooldownMs) {
      return;
    }
    _lastToggleTs = now;

    if (show && !_isAppBarVisible) {
      _isAppBarVisible = true;
      _appBarAnimCtrl.reverse();
    } else if (!show && _isAppBarVisible) {
      _isAppBarVisible = false;
      _appBarAnimCtrl.forward();
    }
  }

  void _onJsScrollMessage(JavaScriptMessage message) {
    double y;
    int dir = 0;
    try {
      final dynamic data = jsonDecode(message.message);
      y = (data['y'] as num).toDouble();
      dir = (data['dir'] as num).toInt();
    } catch (_) {
      y = double.tryParse(message.message) ?? 0.0;
    }

    final dy = y - _lastY;
    _lastY = y;

    if (y <= 16) {
      _toggleAppBar(true);
      return;
    }

    if (dy > _toggleThreshold) {
      _toggleAppBar(false);
    } else if (dy < -_toggleThreshold) {
      _toggleAppBar(true);
    }
  }

  Future<void> _injectScrollBridge() async {
    const js = r"""
      (function() {
        if (window.__FLUTTER_SCROLL_BRIDGE__) return;
        window.__FLUTTER_SCROLL_BRIDGE__ = true;

        function report(y, dir) {
          try { ScrollBridge.postMessage(JSON.stringify({ y: y, dir: dir })); } catch (e) {}
        }

        function getY() {
          try {
            return (window.scrollY !== undefined ? window.scrollY : 0)
              || (document.documentElement && document.documentElement.scrollTop) || 0
              || (document.body && document.body.scrollTop) || 0;
          } catch (e) { return 0; }
        }

        var lastY = getY();
        var ticking = false;

        function onScroll() {
          if (ticking) return;
          ticking = true;
          requestAnimationFrame(function() {
            ticking = false;
            var y = getY();
            var dir = y > lastY ? 1 : (y < lastY ? -1 : 0);
            lastY = y;
            report(y, dir);
          });
        }

        window.addEventListener('scroll', onScroll, { passive: true });

        setInterval(function() {
          var y = getY();
          if (Math.abs(y - lastY) > 2) {
            var dir = y > lastY ? 1 : -1;
            lastY = y;
            report(y, dir);
          }
        }, 200);

        report(lastY, 0);
      })();
    """;

    try {
      await _controller?.runJavaScript(js);
    } catch (_) {}
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setOverScrollMode(WebViewOverScrollMode.never)
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/78.0.3904.62 XWEB/2693 MMWEBSDK/201201 Mobile Safari/537.36 MMWEBID/6170 MicroMessenger/7.0.22.1820(0x27001636)",
      )
      ..addJavaScriptChannel(
        'ScrollBridge',
        onMessageReceived: _onJsScrollMessage,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            _lastY = 0;
            _toggleAppBar(true);
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (_) async {
            await _injectScrollBridge();
            setState(() {
              _isLoading = false;
            });
          },
          onUrlChange: (_) async {
            await _injectScrollBridge();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.getUrl()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // WebView，加载完成前不显示
          if (_controller != null)
            AnimatedOpacity(
              opacity: _isLoading ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: WebViewWidget(controller: _controller!),
            ),

          // Flutter 层 Material 风格加载动画
          if (_isLoading) const Center(child: CircularProgressIndicator()),

          // 顶部自定义 AppBar
          SlideTransition(
            position: _appBarOffset,
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      BackBtn(),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          toastMsg ?? widget.getTitle(),
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStared(context),
                      _buildOpenWithBrowser(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStared(BuildContext context) {
    if (widget.articleBean?.collect == null){
      return const SizedBox.shrink();
    }
    final isCollect = widget.articleBean!.collect ?? false;
    return IconButton.filledTonal(
      isSelected: isCollect,
      selectedIcon: const Icon(Icons.favorite),
      icon: const Icon(Icons.favorite_border),
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
            Timer(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  toastMsg = null;
                });
              }
            });
          }
        });
      },
    );
  }

  Widget _buildOpenWithBrowser(BuildContext from) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem(value: 'open_browser', child: Text('在浏览器中打开')),
          PopupMenuItem(value: 'share', child: Text('分享')),
          PopupMenuItem(value: 'copy_link', child: Text('复制链接')),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case 'open_browser':
            launchUrl(
              Uri.parse(widget.getUrl()),
              mode: LaunchMode.externalApplication,
            );
            break;
          case 'share':
            SharePlus.instance.share(
              ShareParams(title: widget.title, text: widget.getUrl()),
            );
            break;
          case 'copy_link':
            Clipboard.setData(ClipboardData(text: widget.getUrl()));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:Text('链接已复制到剪贴板'),
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
              ),
            );
            break;
        }
      },
    );
  }
}
