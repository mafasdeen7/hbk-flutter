import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:hbk/models/FAQ.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/FAQProvider.dart';

class FAQDetailScreen extends StatefulWidget {
  static const routeName = "/faq-detail";

  @override
  _FAQDetailScreenState createState() => _FAQDetailScreenState();
}

class _FAQDetailScreenState extends State<FAQDetailScreen> {
  FAQ selectedFAQ;
  bool _loadedInitData = false;
  bool _loading = false;
  String title;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      //
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      title = args['title'];
      //
      selectedFAQ =
          await Provider.of<FAQProvider>(context).getDetail(args['id']);

      print(selectedFAQ.content);
      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _loading
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: MyProgressWithMsg(
                    msg: 'Loading...',
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(10),
                  // child: Text(selectedFAQ.content),
                  child: Html(
                    data: selectedFAQ.content,
                    onLinkTap: (url) {
                      // print("Opening $url...");
                      _launchURL(url);
                    },
                    onImageTap: (src) {
                      // Display the image in large form.
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
