import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/constant/constants.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'package:wanandroid_flutter/item/article_item.dart';
import 'package:wanandroid_flutter/widget/end_line.dart';

class ArticleListPage extends StatefulWidget {
  String id;

  ArticleListPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return ArticleListPageState();
  }
}

class ArticleListPageState extends State<ArticleListPage> {
  int currentPage = 0;
  List listData = [];
  int total;
  int lastPage = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      double max = _scrollController.position.maxScrollExtent;
      double position = _scrollController.position.pixels;
      if (position == max &&
          listData.length < total &&
          lastPage != currentPage) {
        lastPage = currentPage;
        print(
            '=========================下滑刷新 length: ${listData.length} ---total: $total');
        _getListData();
      }
    });

    _getListData();
  }

  @override
  Widget build(BuildContext context) {
    if (null == listData || listData.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      ListView listView = ListView.builder(
          controller: _scrollController,
          itemCount: listData.length,
          itemBuilder: (context, i) => _buildItem(i));

      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  void _getListData() {
    String url = API.articleList;
    url += '$currentPage/json?cid=${widget.id}';

    HttpUtils.get(url, (data, cookie) {
      if (null != data) {
        setState(() {
          if (0 == currentPage) {
            listData.clear();
          }

          total = data['total'];
          List list = data['datas'];
          listData.addAll(list);
          currentPage++;

          if (listData.length >= total) {
            listData.add(Constants.END_LINE_TAG);
          }
        });
      }
    });
  }

  Widget _buildItem(int i) {
    var itemData = listData[i];
    if (itemData is String && itemData == Constants.END_LINE_TAG) {
      return EndLine();
    } else {
      return ArticleItem(itemData);
    }
  }

  Future _pullToRefresh() async {
    lastPage = 0;
    currentPage = 0;
    _getListData();
    return null;
  }
}
