import 'package:flutter/material.dart' hide Router;

import '../../common/Router.dart' show Router;
import '../../common/Snack.dart';
import '../../common/User.dart';
import '../../widget/BackBtn.dart';
import '../../widget/ClearableInputField.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRegisterPagePageState();
}

class _LoginRegisterPagePageState extends State<LoginRegisterPage> {
  bool isLogin = true;
  late ClearableInputField _userNameInputForm;
  late ClearableInputField _psdInputForm;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _psdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackBtn(),
        title: Text(isLogin ? "登录" : "注册"),
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
              // Container(
              //   child: _buildRegBtn(),
              //   alignment: Alignment.centerRight,
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return FilledButton(
      child: Text(isLogin ? "登录" : "注册并登录"),
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

          isLogin
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
    _userNameInputForm = ClearableInputField(
      controller: _userNameController,
      inputType: TextInputType.emailAddress,
      hintTxt: '用户名',
    );
    return _userNameInputForm;
  }

  Widget _buildPsdInputForm() {
    _psdInputForm = ClearableInputField(
      controller: _psdController,
      obscureText: true,
      hintTxt: '密码',
    );
    return _psdInputForm;
  }

  Widget _buildRegBtn() {
    return FilledButton(
      child: Text(isLogin ? '注册' : '登录'),
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
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
