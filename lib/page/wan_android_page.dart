import 'package:flutter/material.dart';
import 'package:wanandroid_flutter/constant/colors.dart';
import 'package:wanandroid_flutter/page/home_list_page.dart';
import 'package:wanandroid_flutter/page/my_info_page.dart';
import 'package:wanandroid_flutter/page/search_page.dart';
import 'package:wanandroid_flutter/page/tree_page.dart';

class WanAndroidApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WanAndroidAppState();
  }
}

class _WanAndroidAppState extends State<WanAndroidApp>
    with TickerProviderStateMixin {
  int _tabIndex = 0;
  var appBarTitles = ['首页', '发现', '我的'];
  var _body;
  List<BottomNavigationBarItem> _navigationViews;
  final navigatorKey = GlobalKey<NavigatorState>();

  void initData() {
    _body = IndexedStack(
      children: <Widget>[HomeListPage(), TreePage(), MyInfoPage()],
      index: _tabIndex,
    );
  }

  @override
  void initState() {
    super.initState();
    _navigationViews = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          title: Text(appBarTitles[0]),
          backgroundColor: Colors.blue),
      BottomNavigationBarItem(
          icon: const Icon(Icons.widgets),
          title: Text(appBarTitles[1]),
          backgroundColor: Colors.blue),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          title: Text(appBarTitles[2]),
          backgroundColor: Colors.blue),
    ];
  }

  @override
  Widget build(BuildContext context) {

    initData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
          primaryColor: AppColors.colorPrimary, accentColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitles[_tabIndex],
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  navigatorKey.currentState
                      .push(MaterialPageRoute(builder: (context) {
                        return SearchPage(null);
                  }));
                })
          ],
        ),
        body: _body,
        bottomNavigationBar: BottomNavigationBar(
          items: _navigationViews,
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
