import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/ChangePasswordScreen.dart';
import 'package:hbk/screens/MyAccount/InboxScreen.dart';
import 'package:hbk/screens/MyAccount/ShowMyPriceQuoteScreen.dart';
import 'package:hbk/widget_dlg/DlgLogin.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myDrawerWidget.dart';
import 'package:provider/provider.dart';
import 'package:hbk/screens/MyAccount/MyProfileScreen.dart';
import '../widgets/myAppBar.dart';
import 'MyAccount/ShowShippingSummaryScreen.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = "/admin";

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;

    return Scaffold(
      appBar: myAppBar(),
      drawer: MyDrawerWidget(),
      body: loggedInUser == null
          ? Container()
          : ListView(
              children: <Widget>[
                PageTitleWidget('Admin Account'),
                getMyAccountItem2(
                    'Quote Requests', MyProfileScreen.routeName, true),
                getMyAccountItem2(
                    'Contact Us Messages', InboxScreen.routeName, false),
                getMyAccountItem2('Supplier Payments', '', false),
                getMyAccountItem2(
                    'Message to All', ShowMyPriceQuoteScreen.routeName, false),
              ],
            ),
    );
  }
}
