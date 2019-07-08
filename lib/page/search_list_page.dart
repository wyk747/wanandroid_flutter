import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/constant/constants.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'package:wanandroid_flutter/item/article_item.dart';
import 'package:wanandroid_flutter/widget/end_line.dart';

class SearchListPage extends StatefulWidget {
  String searchText;

  SearchListPage(this.searchText);

  @override
  State<StatefulWidget> createState() {
    return SearchListPageState();
  }
}

class SearchListPageState extends State<SearchListPage> {
  int currentPosition = 0;
  List listData = [];
  int total = 0;
  ScrollController _scrollController;

  SearchListPageState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double nowPosiotn = _scrollController.position.pixels;
      double maxPosition = _scrollController.position.maxScrollExtent;
      if (nowPosiotn == maxPosition && listData.length < total) {
        searchText();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    searchText();
  }

  @override
  Widget build(BuildContext context) {
    Widget listView = ListView.builder(
        itemCount: listData.length,
        controller: _scrollController,
        itemBuilder: (context, i) => buildItem(i));

    if (listData.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return listView;
    }
  }

  void searchText() {
    String url = '${API.search}/$currentPosition/json';
    Map<String, String> params = {'k': widget.searchText};

    HttpUtils.post(url, (data, cookie) {
      setState(() {
        if (currentPosition == 0) {
          listData.clear();
        }

        total = data['total'];
        List datas = data['datas'];
        listData.addAll(datas);

        if (listData.length >= total) {
          listData.add(Constants.END_LINE_TAG);
        }

        currentPosition++;
      });
    }, params: params);
  }

  Widget buildItem(int i) {
    var itemData = listData[i];
    if (itemData is String && itemData == Constants.END_LINE_TAG) {
      return EndLine();
    } else {
      return ArticleItem(itemData);
    }
  }
}
