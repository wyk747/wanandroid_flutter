import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/constant/constants.dart';
import 'package:wanandroid_flutter/event/login_event.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'package:wanandroid_flutter/utils/DataUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> scaffoldKey;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _pswController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('登录')),
      body: initView(),
    );
  }

  Widget initView() {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
      child: Column(
        children: <Widget>[
          Center(
            child: Icon(
              Icons.account_circle,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: '用户名'),
              controller: _nameController,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: '密码'),
              obscureText: true,
              controller: _pswController,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    child: Text(
                      '登录',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).accentColor,
                    disabledColor: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _login),
                RaisedButton(
                    child: Text(
                      '注册',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).accentColor,
                    disabledColor: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      regist();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _login() {
    print('login====================');

    String name = _nameController.text;
    String password = _pswController.text;

    if (name.trim() == '') {
      _showMessage('请输入用户名');
      return;
    }

    if (password.trim() == '') {
      _showMessage('请输入密码');
      return;
    }

    Map<String, String> params = Map<String, String>();
    params['username'] = name;
    params['password'] = password;

    HttpUtils.post(API.login, (data, cookie) async {
      _saveCookie(cookie);
      _showMessage('登录成功');
      DataUtils.saveLoginInfo(name).then((r) {
        Constants.eventBus.fire(LoginEvent());
        Navigator.of(context).pop();
      });
    }, params: params, errorCallback: _errorCallback);
  }

  void _errorCallback(String message) {
    _showMessage(message);
  }

  void _showMessage(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void _saveCookie(cookie) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(HttpUtils.COOKIE, cookie);
  }

  void regist() {
    String name = _nameController.text;
    String password = _pswController.text;

    if (name.trim() == '') {
      _showMessage('请输入用户名');
      return;
    }

    if (password.trim() == '') {
      _showMessage('请输入密码');
      return;
    }

    Map<String, String> params = Map<String, String>();
    params['username'] = name;
    params['password'] = password;
    params['repassword'] = password;

    HttpUtils.post(
        API.regist,
        (data, cookie) {
          _showMessage('注册成功');
        },
        params: params,
        errorCallback: (errorMsg) {
          _errorCallback(errorMsg);
        });
  }
}
