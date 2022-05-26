import 'package:flutter/material.dart';
import 'package:hbk/models/PushNotification.dart';
import 'package:hbk/providers/NotificationProvider.dart';
import 'package:hbk/screens/NotificationViewScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:provider/provider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = "/notification";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Widget> messageList = new List();
  bool _loadedInitData = false;
  bool _loading = false;
  
  showDetail(String id) {
      Navigator.pushNamed(context, NotificationViewScreen.routeName,
          arguments: {
            'id': id,
          });
    }
  
  @override
    void didChangeDependencies() async {
      super.didChangeDependencies();
      if (!_loadedInitData) {
        setState(() {
          _loading = true;
        });

        await Provider.of<NotificationProvider>(context).getAllPublicMessages();

        setState(() {
          _loading = false;
        });

        _loadedInitData = true;
      }
    }

    List<Widget> getList(List<PushNotification> list) {
      messageList.clear();
      list.forEach((f) {
        messageList.add(Card(
          elevation: 2,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 2,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 5.0, color: Theme.of(context).primaryColor),
              ),
            ),
            child: ListTile(
              title: Text(
                f.notiTitle,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(f.notiBody),
              // trailing: (f.is_user_read=="0")? Icon(Icons.fiber_new, color: Colors.red,):Icon(Icons.arrow_forward),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                showDetail(
                  f.id,
                );
              },
            ),
          ),
        ),
      );
        });
      return messageList;
    }

  @override
  Widget build(BuildContext context) {
    
    List<PushNotification> list = Provider.of<NotificationProvider>(context).notificationList;

    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications Inbox'),
        ),
        drawer: LightDrawerPage(),
        body: ListView(
        children: <Widget>[
          _loading
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: MyProgressWithMsg(
                    msg: 'Loading...',
                  ),
                )
              : (list.length == 0)
                  ? Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No Messages!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: getList(list),
                      ),
                    ),
        ],
      ),
      );
  }
}
