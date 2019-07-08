import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'article_detail_page.dart';
import 'search_page.dart';

class HotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HotPageState();
  }
}

class HotPageState extends State<HotPage> {
  List<Widget> hotKeyWidget = List();
  List<Widget> friendWidget = List();

  @override
  void initState() {
    super.initState();
    _getFriend();
    _getHotKey();
  }

  @override
  Widget build(BuildContext context) {
    if (hotKeyWidget.length == 0 && friendWidget.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              '大家都在搜',
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 20.0),
            ),
          ),
          Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: hotKeyWidget,
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              '常用网站',
              style: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 20.0),
            ),
          ),
          Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            children: friendWidget,
          )
        ],
      );
    }
  }

  void _getFriend() {
    HttpUtils.get(API.friend, (data, cookie) {
      setState(() {
        var datas = data;
        friendWidget.clear();
        for (var itemData in datas) {
          Widget actionChip = ActionChip(
              backgroundColor: Theme.of(context).accentColor,
              label: Text(
                itemData['name'],
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ArticleDetailPage(itemData['name'], itemData['link']);
                }));
              });
          friendWidget.add(actionChip);
        }
      });
    });
  }

  void _getHotKey() {
    setState(() {
      HttpUtils.get(API.hotkey, (data, cookie) {
        var datas = data;
        hotKeyWidget.clear();
        for (var itemData in datas) {
          Widget actionChip = ActionChip(
              backgroundColor: Theme.of(context).accentColor,
              label: Text(
                itemData['name'],
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                      return SearchPage(itemData['name']);
                }));
              });
          hotKeyWidget.add(actionChip);
        }
      });
    });
  }
}
