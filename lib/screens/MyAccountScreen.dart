import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/MessageProvider.dart';
import 'package:hbk/providers/RequestQuoteProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/ChangePasswordScreen.dart';
import 'package:hbk/screens/MyAccount/InboxScreen.dart';
import 'package:hbk/screens/MyAccount/ShowMyPriceQuoteScreen.dart';
import 'package:hbk/screens/MyAccount/ShowMySupplierPaymentsScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widget_dlg/DlgLogin.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myDrawerWidget.dart';
import 'package:provider/provider.dart';
import 'package:hbk/screens/MyAccount/MyProfileScreen.dart';
import '../widgets/myAppBar.dart';
import 'MyAccount/ShowShippingSummaryScreen.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class MyAccountScreen extends StatefulWidget {
  static const routeName = "/my-account";

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  bool _loadedInitData = false;
  bool _loading = false;

  showDetail(String routeName) {
    print(routeName);
    // check if the user is logged in
    // if not logged in show login page.
    bool isLoggedIn =
        Provider.of<UserProvider>(context, listen: false).isLoggedIn;
    if (isLoggedIn) {
      Navigator.pushNamed(context, routeName);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return DlgLogin();
        },
      );
    }
  }

  Widget getMyAccountItem(String title, String routeName) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
      child: MyListItemWidget(
        title: title,
        // subTitle: '\u{2795}',
        onClick: () {
          showDetail(routeName);
        },
      ),
    );
  }

  Widget getMyAccountItem2(String title, String routeName, bool isNew) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(title),
            // subtitle: Text('djlhjd'),
            trailing: isNew
                ? IconButton(
                    icon: Icon(
                      Icons.fiber_new,
                      color: Colors.red,
                    ),
                    onPressed: null)
                : IconButton(icon: Icon(Icons.navigate_next), onPressed: null),
            onTap: () {
              showDetail(routeName);
            },
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });
      User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
      if(loggedInUser !=null) {
        String token = Provider.of<UserProvider>(context).token;
        await Provider.of<MessageProvider>(context, listen: false).getUnReadMessageCount(token);
        await Provider.of<RequestQuoteProvider>(context, listen: false).getUnreadQuateCount(token);
      }
      setState(() {
        _loading = false;
      });
      _loadedInitData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
    bool showBadgeMsg = false;
    bool showBadgeQuate = false;
    int count = 0;
    count = Provider.of<MessageProvider>(context).messageCount;
    if(count > 0){
      showBadgeMsg = true;
    }
    int qCount = 0;
    qCount = Provider.of<RequestQuoteProvider>(context).unreadQuateCount;
    if(qCount > 0){
      showBadgeQuate = true;
    }

    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body:  _loading ?
          Container(
            padding: EdgeInsets.all(8.0),
            child: MyProgressWithMsg(
              msg: 'Loading...',
            ),
          )
        : ListView(
              children: <Widget>[
                PageTitleWidget('My Account'),
                getMyAccountItem2(
                    'My Profile', MyProfileScreen.routeName, false),
                getMyAccountItem2('Inbox ('+count.toString()+')',InboxScreen.routeName, showBadgeMsg),
                getMyAccountItem2('My Supplier Payment',
                    ShowMySupplierPaymentsScreen.routeName, false),
                getMyAccountItem2(
                    'My Price Quotes', ShowMyPriceQuoteScreen.routeName, showBadgeQuate),
                getMyAccountItem2('My Shipping Summary',
                    ShowShippingSummaryScreen.routeName, false),
                getMyAccountItem2(
                    'Change Password', ChangePasswordScreen.routeName, false),
              ],
            ),
    );
  }
}
