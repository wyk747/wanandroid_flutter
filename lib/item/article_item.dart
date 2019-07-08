import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'package:wanandroid_flutter/page/article_detail_page.dart';

class ArticleItem extends StatefulWidget {
  var itemData;

  ArticleItem(this.itemData);

  @override
  State<StatefulWidget> createState() {
    return ArticleItemState(itemData);
  }
}

class ArticleItemState extends State<ArticleItem> {
  var itemData;

  ArticleItemState(this.itemData);

  @override
  Widget build(BuildContext context) {
    bool isCollect = itemData['collect'];

    Row author = Row(
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            Text('作者:  '),
            Text(
              itemData['author'],
              style: TextStyle(color: Theme.of(context).accentColor),
            )
          ],
        )),
        Text(
          itemData['niceDate'],
          style: TextStyle(color: Theme.of(context).accentColor),
        )
      ],
    );

    Container title = Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Text(
        itemData['title'],
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );

    Row chapterName = Row(
      children: <Widget>[
        Expanded(
            child: Text(
          itemData['chapterName'],
          style: TextStyle(color: Theme.of(context).accentColor),
        )),
        Offstage(
          child: IconButton(
            icon: Icon((isCollect != null && isCollect) ? Icons.favorite : Icons.favorite_border,
                color: (isCollect != null && isCollect) ? Colors.red : null),
            onPressed: () {
              deal_collect(itemData);
            },
          ),
          offstage: isCollect == null,
        ),
      ],
    );

    Column item = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: author,
        ),
        title,
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: chapterName,
        )
      ],
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        child: item,
        onTap: () => _itemClick(itemData),
      ),
    );
  }

  void _itemClick(itemData) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(itemData['title'], itemData['link']);
    }));
  }

  void deal_collect(itemData) {
    bool isCollect = itemData['collect'];
    if (!isCollect) {
      collect(itemData);
    } else {
      unCollect(itemData);
    }
  }

  void collect(itemData) {
    int id = itemData['id'];
    String url = '${API.collect}$id/json';
    HttpUtils.post(url, (data, cookie) {
      setState(() {
        itemData['collect'] = true;
      });
    }, errorCallback: (errorMsg) {
      print(errorMsg);
    });
  }

  void unCollect(itemData) {
    int id = itemData['id'];
    String url = '${API.uncollect_originId}$id/json';
    HttpUtils.post(url, (data, cookie) {
      setState(() {
        itemData['collect'] = false;
      });
    }, errorCallback: (errorMsg) {
      print(errorMsg);
    });
  }
}
