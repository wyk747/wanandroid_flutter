import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/constant/constants.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http_utils.dart';
import 'package:wanandroid_flutter/item/article_item.dart';
import 'package:wanandroid_flutter/widget/end_line.dart';
import 'package:wanandroid_flutter/widget/slide_view.dart';

class HomeListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeListState();
  }
}

class HomeListState extends State<HomeListPage> {
  SlideView _bannerView;
  int listTotalSize = 0;
  List listData = [];
  int _currentPage = 0;
  ScrollController _controller = ScrollController();

  HomeListState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        print('=========================下滑刷新');
        getHomeArticleList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBanner();
    getHomeArticleList();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (null == listData) {
      return CircularProgressIndicator();
    } else {
      Widget listView = ListView.builder(
        itemCount: listData.length + 1,
        itemBuilder: (context, i) => buildItem(i),
        controller: _controller,
      );

      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Future _pullToRefresh() async {
    _currentPage = 0;
    getBanner();
    getHomeArticleList();
    return null;
  }

  void getBanner() {
    String bannerUrl = API.banner;
    HttpUtils.get(bannerUrl, (data, cookie) {
      if (null != data) {
        setState(() {
          _bannerView = SlideView(data);
        });
      }
    });
  }

  Widget buildItem(int i) {
    if (i == 0) {
      return Container(
        height: 180,
        child: _bannerView,
      );
    } else {
      i = i - 1;
      var itemData = listData[i];
      if (itemData is String && itemData == Constants.END_LINE_TAG) {
        return EndLine();
      } else {
        return ArticleItem(itemData);
      }
    }
  }

  void getHomeArticleList() {
    String url = API.articleList;
    url += '$_currentPage/json';
    HttpUtils.get(url, (data, cookie) {
      if (data != null) {
        List list = data['datas'];
        print('list size: ${list.length}');
        print('list: ${list.toString()}');
        listTotalSize = data['total'];
        setState(() {
          if (0 == _currentPage) {
            listData.clear();
          }

          _currentPage++;

          listData.addAll(list);
          if (listData.length >= listTotalSize) {
            listData.add(Constants.END_LINE_TAG);
          }
        });
      }
    });
  }
}
