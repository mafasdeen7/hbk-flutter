import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatelessWidget {
  final String title;
  final String selectedUrl;
  final String content;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // body: WebView(
      //   initialUrl: selectedUrl,
      //   javascriptMode: JavascriptMode.unrestricted,
      //   onWebViewCreated: (WebViewController webViewController) {
      //     _controller.complete(webViewController);
      //   },
      // ),
      body: WebView(
        initialUrl:
            new Uri.dataFromString(content, mimeType: 'text/html').toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Share.share(selectedUrl, subject: 'News');
        },
        child: Icon(Icons.share),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
