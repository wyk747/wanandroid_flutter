import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('关于我们'),),
      body: Center(
        child: Text('关于关于关于关于关于关于'),
      ),
    );
  }

}
