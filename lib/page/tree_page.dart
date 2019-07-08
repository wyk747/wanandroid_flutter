import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';

import 'article_page.dart';

class TreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TreePageState();
  }
}

class TreePageState extends State<TreePage> {
  List listData;

  @override
  void initState() {
    super.initState();
    _getTree();
  }

  @override
  Widget build(BuildContext context) {
    if (null == listData) {
      return CircularProgressIndicator();
    } else {
      return ListView.builder(
          itemCount: listData.length,
          itemBuilder: (context, i) => buildItem(i));
    }
  }

  void _getTree() {
    HttpUtils.get(API.treeList, (data, cookie) {
      setState(() {
        listData = data;
      });
    });
  }

  Widget buildItem(int i) {
    var itemDate = listData[i];

    List children = itemDate['children'];
    StringBuffer sb = StringBuffer();
    for (Map<String, dynamic> map in children) {
      sb.write('${map['name']}    ');
    }

    Column item = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          itemDate['name'],
          softWrap: true,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.left,
        ),
        Container(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            sb.toString(),
            softWrap: true,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    return Card(
      child: InkWell(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.all(15),
              child: item,
            )),
            Icon(
              Icons.chevron_right,
              color: Colors.black,
            )
          ],
        ),
        onTap: () {
          _handOnItemClick(itemDate);
        },
      ),
    );
  }

  void _handOnItemClick(itemDate) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ArticlePage(itemDate);
    }));
  }
}
