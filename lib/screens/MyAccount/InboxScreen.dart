import 'package:flutter/material.dart';
import 'package:hbk/models/Message.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/MessageProvider.dart';
import 'package:hbk/screens/ContactUsScreen.dart';
import 'package:hbk/screens/MyAccount/InboxDetailScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = "/inbox";

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  TextEditingController _customerIDCnt = TextEditingController();
  List<Widget> messageList = new List();
  bool _loadedInitData = false;
  bool _loading = false;

  Widget showMessages(String title, String routeName, bool isNew) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text('Sample Sort Message in subtitle...\n'),
            trailing: isNew
                ? IconButton(
                    icon: Icon(
                      Icons.fiber_new,
                      color: Colors.red,
                    ),
                    onPressed: null)
                : IconButton(icon: Icon(Icons.navigate_next), onPressed: null),
            onTap: () {
              // showDetail(routeName);
            },
          ),
        ],
      ),
    );
  }
  
  showDetail(int id, String subject, String message) {
      Navigator.pushNamed(context, InboxDetailScreen.routeName,
          arguments: {
            'id': id,
            'subject': subject,
            'message': message,
          });
    }
  
  @override
    void didChangeDependencies() async {
      super.didChangeDependencies();
      if (!_loadedInitData) {
        setState(() {
          _loading = true;
        });

        String token = Provider.of<UserProvider>(context).token;
        await Provider.of<MessageProvider>(context).getAllMessages(token);

        setState(() {
          _loading = false;
        });

        _loadedInitData = true;
      }
    }

    List<Widget> getList(List<Message> list) {
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
                f.subject,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text(f.message),
              trailing: (f.is_user_read=="0")? Icon(Icons.fiber_new, color: Colors.red,):Icon(Icons.arrow_forward),
              onTap: () {
                showDetail(
                  f.id,
                  f.subject,
                  f.message,
                );
              },
            ),
          ),
        ),
      );
        });
      return messageList;
    }
    // List<Widget> getList(List<Message> list) {
    //   messageList.clear();
    //   list.forEach((f) {
    //       messageList.add(MyListItemWidget(
    //         title: f.subject,
    //         subTitle: f.message,
    //         onClick: () {
    //           showDetail(
    //               f.id,
    //               f.subject,
    //               f.message,
    //               );
    //         },
    //       ));
    //     });
    //   return messageList;
    // }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
    _customerIDCnt.text = loggedInUser.customerId.toString();
    List<Message> list = Provider.of<MessageProvider>(context).messageList;

    return Scaffold(
        appBar: AppBar(
          title: Text('Inbox'),
          actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
            onPressed: () {
                Navigator.pushNamed(context, ContactUsScreen.routeName);
            },
          )
        ],
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
