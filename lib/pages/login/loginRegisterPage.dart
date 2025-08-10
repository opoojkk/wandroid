import 'package:flutter/material.dart' hide Router;

import '../../common/Router.dart' show Router;
import '../../common/Snack.dart';
import '../../common/User.dart';
import '../../widget/BackBtn.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRegisterPagePageState();
}

class _LoginRegisterPagePageState extends State<LoginRegisterPage> {
  OperateMode operateMode = OperateMode.login;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _psdController = TextEditingController();

  bool get login {
    return operateMode == OperateMode.login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackBtn(),
        title: Text(login ? "登录" : "注册"),
        actions: [_buildRegBtn()],
      ),
      body: Builder(
        builder: (ct) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 48.0),
              _buildUserNameInputForm(),
              SizedBox(height: 8.0),
              _buildPsdInputForm(),
              SizedBox(height: 24.0),
              _buildLoginBtn(ct),
              SizedBox(height: 10.0),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return FilledButton(
      child: Text(login ? "登录" : "注册并登录"),
      onPressed: () {
        var userNameStr = _userNameController.text;
        var psdStr = _psdController.text;
        if (userNameStr.length < 6 || psdStr.length < 6) {
          "账号和密码均需大于6位".showSnack(context);
        } else {
          callback(bool loginOK, String? errorMsg) {
            if (loginOK) {
              Router().back(context);
            } else {
              if (errorMsg != null && errorMsg.isNotEmpty) {
                errorMsg.showSnack(context);
              }
            }
          }

          login
              ? User().login(
                  username: userNameStr,
                  password: psdStr,
                  callback: callback,
                )
              : User().register(
                  username: userNameStr,
                  password: psdStr,
                  callback: callback,
                );
        }
      },
    );
  }

  Widget _buildUserNameInputForm() {
    return TextField(
      obscureText: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '用户名',
      ),
    );
  }

  Widget _buildPsdInputForm() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '密码',
      ),
    );
  }

  Widget _buildRegBtn() {
    return FilledButton(
      child: Text(login ? '注册' : '登录'),
      onPressed: () {
        setState(() {
          switch (operateMode) {
            case OperateMode.login:
              operateMode = OperateMode.register;
            case OperateMode.register:
              operateMode = OperateMode.login;
          }
          ;
        });
      },
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _psdController.dispose();
    super.dispose();
  }
}

enum OperateMode { login, register }
