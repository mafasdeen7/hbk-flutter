import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/screens/AdminScreen.dart';
import 'package:hbk/screens/ContactUsScreen.dart';
import 'package:hbk/screens/ContactUsGuestScreen.dart';
import 'package:hbk/screens/FAQScreen.dart';
import 'package:hbk/screens/HomeScreen.dart';
import 'package:hbk/screens/MyAccountScreen.dart';
import 'package:hbk/screens/NewsScreen.dart';
import 'package:hbk/screens/RequestAQuoteGuestScreen.dart';
import 'package:hbk/screens/RequestAQuoteScreen.dart';
import 'package:hbk/screens/ServicesScreen.dart';
import 'package:hbk/screens/TipsScreen.dart';
import 'package:hbk/widget_dlg/DlgLogin.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';

class MyDrawerWidget extends StatefulWidget {
  @override
  _MyDrawerWidgetState createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  Widget myListTile(String name, String routeName, bool loginRequired) {
    return ListTile(
      leading: Icon(
        Icons.chevron_right,
        color: Colors.white,
        size: 30,
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
      onTap: () {
        if (loginRequired) {
          bool isLoggedIn =
              Provider.of<UserProvider>(context, listen: false).isLoggedIn;
          if (!isLoggedIn) {
            routeName = 'dlgLogin';
          }
        }
        if (routeName == 'dlgLogin') {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return DlgLogin();
            },
          );
        } else if (routeName == 'logout') {
          Provider.of<UserProvider>(context, listen: false).logout();
          Navigator.popAndPushNamed(context, HomeScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;

    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/img/logo.png',
                  fit: BoxFit.contain,
                ),
                padding: EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 60,
                  bottom: 20,
                ),
              ),
              myListTile('Home', HomeScreen.routeName, false),
              myListTile('Services', ServicesScreen.routeName, false),
              if(loggedInUser != null)
                myListTile('Request A Quote', RequestAQuoteScreen.routeName, true),
              if(loggedInUser == null)
                myListTile('Request A Quote - Guest', RequestAQuoteGuestScreen.routeName, false),
              if(loggedInUser != null)
                myListTile('Contact Us', ContactUsScreen.routeName, true),
              if(loggedInUser == null)
                myListTile('Contact Us - Guest', ContactUsGuestScreen.routeName, false),
              myListTile('FAQs', FAQScreen.routeName, false),
              myListTile('Guides / Tips', TipsScreen.routeName, false),
              myListTile('News', NewsScreen.routeName, false),
              if (loggedInUser == null)
                myListTile('Login / Register', 'dlgLogin', false),
              if (loggedInUser != null)
                myListTile('My Account', MyAccountScreen.routeName, false),
              // if (loggedInUser != null)
              //   if (loggedInUser.email == 'mafasdeen7@gmail.com')
              //     myListTile('Admin', AdminScreen.routeName, false),
              if (loggedInUser != null)
                myListTile('Logout', 'logout', false),
            ],
          ),
        ),
      ),
    );
  }
}
