import 'package:flutter/material.dart';

class EndLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              height: 10,
            ),
            flex: 1,
          ),
          Text(
            '我是有底线的',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          Expanded(
            child: Divider(
              height: 10,
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
