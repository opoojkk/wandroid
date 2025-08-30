import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/application.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // 状态栏透明
      statusBarIconBrightness: Brightness.dark,
      // 状态栏图标深色（亮背景用）
      systemNavigationBarColor: Colors.transparent,
      // 底部导航栏透明
      systemNavigationBarIconBrightness: Brightness.dark,
      // 底部图标深色
      systemNavigationBarDividerColor: Colors.transparent, // 分割线透明
    ),
  );
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '玩安卓',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
        fontFamily: "noto",
      ),
      home: ApplicationPage(),
    );
  }
}
