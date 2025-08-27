import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:url_launcher/url_launcher.dart';
import 'package:wandroid/common/event/eventbus.dart';
import 'package:wandroid/network/api/avatar.dart';

import '../../common/Router.dart';
import '../../common/User.dart';
import '../../common/event/event.dart';
import '../about/aboutPage.dart';
import 'MineItem.dart';

class LoginNotifier extends ChangeNotifier {
  bool _isLogin = User.instance.isLogin();

  bool get isLogin => _isLogin;

  void updateLoginStatus() {
    _isLogin = User.instance.isLogin();
    notifyListeners();
  }
}

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  bool _isLogin = User.instance.isLogin();
  late StreamSubscription _loginSubscription;

  @override
  void initState() {
    super.initState();
    _loginSubscription = EventDriver.instance.eventBus.on<LoginEvent>().listen((
      event,
    ) {
      setState(() {
        _isLogin = event.isLogin;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loginSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final List<MineItem> items = [
      MineItem(
        title: '收藏文章',
        icon: Icons.favorite,
        onTap: (context) {
          Router().openFavorite(context);
        },
      ),
      // MineItem(
      //     title: '设置',
      //     icon: Icons.settings,
      //     onTap: (context) {
      //       _snackbarNotImplement(context);
      //     }),
      MineItem(
        title: '关于',
        icon: Icons.info,
        onTap: (context) {
          return Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return AboutPage();
              },
            ),
          );
        },
      ),
      MineItem(
        title: 'Github仓库',
        icon: Icons.coffee,
        onTap: (context) {
          launchUrl(
            Uri.parse("https://github.com/opoojkk/wandroid"),
            mode: LaunchMode.externalApplication,
          );
        },
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          _buildHead(context),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 10),
            // padding: const EdgeInsets.all(0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                MineItem item = items[index];
                return _buildListItem(context, items, index, item);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'have a nice day!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black.withValues(alpha: 0.4)),
        ),
      ),
    );
  }

  Material _buildListItem(
    BuildContext context,
    List<MineItem> items,
    int index,
    MineItem item,
  ) {
    return Material(
      child: InkWell(
        onTap: () {
          item.onTap?.call(context);
        },
        borderRadius: BorderRadius.circular(8), // 波纹圆角
        child: Container(
          height: 55,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20,
                color: Colors.black.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 16),
              Text(item.title, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHead(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isLogin) {
          _showLogout(context);
        } else {
          _toLogin(context);
        }
      },
      child: _buildAvatar(),
    );
  }

  void _toLogin(BuildContext context) async {
    await Router().openLogin(context);
  }

  Widget _buildAvatar() {
    return SafeArea(
      child: Column(
        spacing: 10,
        children: [SizedBox(height: 45), _buildUserInfo(), SizedBox(height: 0)],
      ),
    );
  }

  Widget _buildUserInfo() {
    if (_isLogin) {
      return _avatarTemplateLayout(
        User.currentUser()?.username ?? "",
        "${Avatar.avatarCoding}${getUserName().hashCode % 20 + 1}.png",
        '随便逛一逛吧~',
      );
    } else {
      return _avatarTemplateLayout(
        '未登录',
        "${Avatar.avatarCoding}${getUserName().hashCode % 20 + 1}.png",
        '登录之后更多精彩~',
      );
    }
  }

  Widget _avatarTemplateLayout(String name, String avatar, String description) {
    return Row(
      children: [
        SizedBox(width: 20),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0x00ffffff),
            image: DecorationImage(
              image: CachedNetworkImageProvider(avatar),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(new Radius.circular(30.0)),
          ),
        ),
        SizedBox(width: 16),
        Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<Null> _showLogout(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _buildLogout(context);
      },
    );
  }

  Widget _buildLogout(BuildContext context) {
    return AlertDialog(
      content: Text("确定退出登录？"),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
            User.instance.logout();
            EventDriver.instance.eventBus.fire(LoginEvent(false));
            Navigator.pop(context);
          },
          child: Text("确定"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          child: Text("点错了"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  String getUserName() {
    return User.currentUser()?.username ?? "";
  }
}
