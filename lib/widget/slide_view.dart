import 'package:flutter/material.dart';

class SlideView extends StatefulWidget {

  List data;

  SlideView(this.data);

  @override
  State<StatefulWidget> createState() {
    return SlideViewState(data);
  }
}

class SlideViewState extends State<SlideView>
    with SingleTickerProviderStateMixin {
  List data;
  TabController tabController;

  SlideViewState(this.data);

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: data == null ? 0 : data.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (data != null && data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        var item = data[i];
        var imgUrl = item['imagePath'];
        var title = item['title'];
        item['link'] = item['url'];
        items.add(GestureDetector(
          onTap: () {},
          child: AspectRatio(
            aspectRatio: 2.0 / 1.0,
            child: Stack(
              children: <Widget>[
                Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  width: 1000.0,
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: 1000,
                    color: const Color(0x50000000),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      }
    }

    return TabBarView(
      children: items,
      controller: tabController,
    );
  }

  void _handOnItemClick(itemData) {}
}
