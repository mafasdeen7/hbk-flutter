import 'package:flutter/material.dart';
import 'package:hbk/models/PushNotification.dart';
import 'package:hbk/providers/NotificationProvider.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationViewScreen extends StatefulWidget {
  static const routeName = "/notification-view";

  @override
  _NotificationViewScreenState createState() => _NotificationViewScreenState();
}

class _NotificationViewScreenState extends State<NotificationViewScreen> {
  PushNotification selectedMessage;
  bool _loadedInitData = false;
  bool _loading = false;
  String id;

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
      id = args['id'];
      //
      selectedMessage =
          await Provider.of<NotificationProvider>(context).getDetail(args['id']);

      print(selectedMessage.dataBody);
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
        title: Text('Notifications Inbox'),
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
                  _loading? 'Loading..':selectedMessage.notiTitle,
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
                    data: selectedMessage.dataBody,
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
