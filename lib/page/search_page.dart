import 'package:flutter/material.dart';
import 'hot_page.dart';
import 'search_list_page.dart';

class SearchPage extends StatefulWidget {

  String searchText;

  SearchPage(this.searchText);

  @override
  State<StatefulWidget> createState() {
    return SearchPageState(searchText);
  }
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _searchController;
  SearchListPage _searchListPage;
  String _searchText;

  SearchPageState(this._searchText);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: _searchText);
    search();
  }

  void search() {
    setState(() {
      _searchListPage = SearchListPage(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextField searchField = TextField(
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: (string) {
        search();
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '搜索关键词',
          hintStyle: TextStyle(color: Colors.white)),
      controller: _searchController,
    );

    return Scaffold(
      appBar: AppBar(
        title: searchField,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                search();
              }),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
              })
        ],
      ),
      body: (_searchController.text == null || _searchController.text.isEmpty)
          ? Center(
              child: HotPage(),
            )
          : _searchListPage,
    );
  }
}
