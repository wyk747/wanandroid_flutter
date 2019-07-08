import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/constant/constants.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'package:wanandroid_flutter/item/article_item.dart';
import 'package:wanandroid_flutter/widget/end_line.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CollectPageState();
  }
}

class CollectPageState extends State<CollectPage> {
  List dataList = [];
  int currentPosition = 0;
  int total = 0;
  ScrollController _scrollController;

  CollectPageState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double now = _scrollController.position.pixels;
      double max = _scrollController.position.maxScrollExtent;
      if (now == max && dataList.length < total) {
        getCollectList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCollectList();
  }

  Widget getContent() {
    if (dataList.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return RefreshIndicator(
          child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, i) => buildItem(i)),
          onRefresh: () {
            refresh();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: getContent(),
    );
  }

  void getCollectList() {
    String url = '${API.conllect_list}$currentPosition/json';
    HttpUtils.get(url, (data, cookie) {
      setState(() {
        if (0 == currentPosition) {
          dataList.clear();
        }

        dataList.addAll(data['datas']);

        total = data['total'];
        currentPosition++;

        if (dataList.length >= total) {
          dataList.add(Constants.END_LINE_TAG);
        }
      });
    });
  }

  Widget buildItem(int i) {
    if (dataList[i] is String && dataList[i] == Constants.END_LINE_TAG) {
      return EndLine();
    } else {
      return ArticleItem(dataList[i]);
    }
  }

  Future refresh() {
    currentPosition = 0;
    total = 0;
    getCollectList();
    return null;
  }
}
