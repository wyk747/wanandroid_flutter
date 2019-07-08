import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String url;

  ArticleDetailPage(this.title, this.url);

  @override
  State<StatefulWidget> createState() {
    return ArticleDetailState();
  }
}

class ArticleDetailState extends State<ArticleDetailPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onDestroy.listen((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      withJavascript: true,
      withZoom: true,
      withLocalStorage: true,
    );
  }
}
