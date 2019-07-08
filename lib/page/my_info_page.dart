import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/constant/constants.dart';
import 'package:wanandroid_flutter/event/login_event.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'package:wanandroid_flutter/page/login_page.dart';
import 'package:wanandroid_flutter/utils/DataUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'about_page.dart';
import 'collect_page.dart';

class MyInfoPage extends StatefulWidget {

  State<StatefulWidget> createState() {
    return MyInfoPageState();
  }
}

class MyInfoPageState extends State<MyInfoPage> {
  String userName;
  Image image;
  RaisedButton loginButton;
  Widget likeItem;
  Widget aboutItem;
  Widget loginOutItem;

  @override
  void initState() {
    super.initState();

    _getName();

    Constants.eventBus.on<LoginEvent>().listen((event) {
      _getName();
    });
  }

  void initView() {
    image = Image.asset(
      'images/ic_launcher_round.png',
      width: 100,
      height: 100,
    );

    loginButton = RaisedButton(
        child: Text(
          userName == null ? '请登录' : userName,
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          DataUtils.isLogin().then((isLogin) {
            if (!isLogin) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            }
          });
        });

    likeItem = ListTile(
      leading: Icon(Icons.favorite),
      title: const Text('喜欢的文章'),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return CollectPage();
        }));
      },
    );

    aboutItem = ListTile(
      leading: Icon(Icons.info),
      title: const Text('关于我们'),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return AboutPage();
        }));
      },
    );

    loginOutItem = ListTile(
      leading: Icon(Icons.call_missed_outgoing),
      title: const Text('退出登录'),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        HttpUtils.get(API.loginOut, (data, cookie) {
          DataUtils.loginOut();
          showToast('退出登录成功');
          setState(() {
            _getName();
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initView();

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      children: <Widget>[image, loginButton, likeItem, aboutItem, loginOutItem],
    );
  }

  void _getName() {
    DataUtils.getUserName().then((name) {
      setState(() {
        userName = name;
      });
    });
  }

  void showToast(String txt){
    Fluttertoast.showToast(msg: txt,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      fontSize: 16
    );
  }


}
