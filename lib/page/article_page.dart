import 'package:flutter/material.dart';

import 'Article_list_page.dart';

class ArticlePage extends StatefulWidget {
  var itemDate;

  ArticlePage(this.itemDate);

  @override
  State<StatefulWidget> createState() {
    return ArticlePageState();
  }
}

class ArticlePageState extends State<ArticlePage>
    with SingleTickerProviderStateMixin {
  List childrenList;
  List<Tab> tabs = [];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    childrenList = widget.itemDate['children'];

    for (var child in childrenList) {
      print('child: ${child.toString()}');
      tabs.add(Tab(
        text: child['name'],
      ));
    }

    _tabController = TabController(length: childrenList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemDate['name']),
      ),
      body: DefaultTabController(
          length: childrenList.length,
          child: Scaffold(
            appBar: TabBar(
                isScrollable: true,
                controller: _tabController,
                labelColor: Theme.of(context).accentColor,
                unselectedLabelColor: Colors.black,
                indicatorColor: Theme.of(context).accentColor,
                tabs: tabs),
            body: TabBarView(
                controller: _tabController,
                children: childrenList.map((dynamic itemData) {
                  return ArticleListPage(itemData['id'].toString());
                }).toList()),
          )),
    );
  }
}
