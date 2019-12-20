import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

// ignore: must_be_immutable
class BookShow extends StatefulWidget {
  String bookName;
  int total;

  BookShow({Key key, @required this.bookName, @required this.total});

  @override
  _BookShowState createState() => _BookShowState();
}

class _BookShowState extends State<BookShow> {
  WebViewController _controller;

  int page;
  String url;
  @override
  void initState() {
    super.initState();
    page = 0;
  }

  __loadHtmlFromAssets() async {
    String fileText = await rootBundle
        .loadString('assets/books/${widget.bookName}/$page.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  void nextPage() {
    if (page < widget.total) {
      setState(() {
        page++;
      });
      __loadHtmlFromAssets();
    }
  }

  void prevPage() {
    if (page > 1) {
      setState(() {
        page--;
      });
      __loadHtmlFromAssets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              initialUrl: 'about:blank',
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                __loadHtmlFromAssets();
              },
            ),
          ),
          Container(
            color: Colors.blueGrey[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    nextPage();
                  },
                ),
                FlatButton(
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    prevPage();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
