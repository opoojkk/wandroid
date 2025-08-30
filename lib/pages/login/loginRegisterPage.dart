import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:wandroid/common/event/event.dart';
import 'package:wandroid/common/event/eventbus.dart';

import '../../common/Router.dart' show Router;
import '../../common/Snack.dart';
import '../../common/User.dart';
import '../../widget/BackBtn.dart';
import '../../widget/loadingDialog.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRegisterPagePageState();
}

class _LoginRegisterPagePageState extends State<LoginRegisterPage> {
  OperateMode operateMode = OperateMode.login;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _psdController = TextEditingController();

  bool isObscure = false;

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
        if (userNameStr.isEmpty || psdStr.isEmpty) {
          "账号和密码不能为空".showSnack(context);
        } else {
          Loading.show(
            context,
            cancelable: true,
            negative: "取消",
            onNegative: () {
              Loading.hide();
            },
          );
          callback(bool loginOK, String? errorMsg) {
            Loading.hide();
            if (loginOK) {
              EventDriver.instance.eventBus.fire(LoginEvent(true));
              Router().back(context);
            } else {
              if (errorMsg != null && errorMsg.isNotEmpty) {
                errorMsg.showSnack(context);
              }
            }
          }

          login
              ? User.instance.login(
                  username: userNameStr,
                  password: psdStr,
                  callback: callback,
                )
              : User.instance.register(
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
      controller: _userNameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: '用户名',
      ),
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
    );
  }

  Widget _buildPsdInputForm() {
    return TextField(
      controller: _psdController,
      obscureText: isObscure,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
        border: OutlineInputBorder(),
        labelText: '密码',
      ),
      keyboardType: TextInputType.visiblePassword,
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
