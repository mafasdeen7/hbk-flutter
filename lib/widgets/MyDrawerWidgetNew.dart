// import 'package:NewsReader/Profile.dart';
import 'package:flutter/material.dart';
import 'package:hbk/screens/NotificationScreen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:NewsReader/helpers/drawerAnimation/animation.dart';
import 'package:hbk/widgets/helpers/oval-right-clipper.dart';
import 'package:hbk/screens/ServicesScreen.dart';

import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/widget_dlg/DlgLogin.dart';
import 'package:hbk/screens/HomeScreen.dart';
import 'package:hbk/screens/MyAccount/InboxScreen.dart';
import 'package:hbk/screens/ContactUsScreen.dart';
import 'package:hbk/screens/ContactUsGuestScreen.dart';
import 'package:hbk/screens/FAQScreen.dart';
import 'package:hbk/screens/MyAccountScreen.dart';
import 'package:hbk/screens/NewsScreen.dart';
import 'package:hbk/screens/RequestAQuoteGuestScreen.dart';
import 'package:hbk/screens/RequestAQuoteScreen.dart';
import 'package:hbk/screens/TipsScreen.dart';
import 'package:hbk/providers/MessageProvider.dart';

class LightDrawerPage extends StatelessWidget {
  // static final String path = "lib/src/pages/navigation/drawer2.dart";
  // final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.grey.shade200; //Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  @override
  Widget build(BuildContext context) {
    final String image = 'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media';
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;

    
    


    Divider _buildDivider() {
      return Divider(
        color: divider,
      );
    }

    Widget _buildRow(IconData icon, String title, String routeName, bool loginRequired, {bool showBadge = false}) {
      final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
      int count=0;
      if(loggedInUser !=null) {
        String token = Provider.of<UserProvider>(context).token;
        Provider.of<MessageProvider>(context).getUnReadMessageCount(token);
        count = Provider.of<MessageProvider>(context).messageCount;
        if(count <= 0){
          showBadge = false;
        }
      }
      return InkWell(
        onTap: (){
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(children: [
            Icon(
              icon,
              color: active,
            ),
            SizedBox(width: 10.0),
            Text(
              title,
              style: tStyle,
            ),
            Spacer(),
            if (showBadge)
              Material(
                color: Colors.blue,
                elevation: 5.0,
                shadowColor: Colors.black,
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
          ]),
        ),
      );
    }

    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: active,
                      ),
                      onPressed: () {
                        if (loggedInUser != null){
                          Provider.of<UserProvider>(context, listen: false).logout();
                          Navigator.popAndPushNamed(context, HomeScreen.routeName);
                        }
                        else{
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return DlgLogin();
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.blue])),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/img/user.jpg'),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    (loggedInUser != null)? loggedInUser.firstName+' '+loggedInUser.lastName : "Guest User",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    (loggedInUser != null)? loggedInUser.email : "@guest",
                    style: TextStyle(color: active, fontSize: 16.0),
                  ),
                  SizedBox(height: 30.0),
                  _buildRow(Icons.home, "Home", HomeScreen.routeName, false),
                  _buildDivider(),
                  _buildRow(Icons.scatter_plot, "Services", ServicesScreen.routeName, false),
                  _buildDivider(),
                  if(loggedInUser != null)
                  _buildRow(Icons.blur_linear, "Request A Quote", RequestAQuoteScreen.routeName, true),
                  if(loggedInUser == null)
                  _buildRow(Icons.blur_linear, "Request A Quote", RequestAQuoteGuestScreen.routeName, false),
                  _buildDivider(),
                  if(loggedInUser != null)
                  _buildRow(Icons.message, "Messages", InboxScreen.routeName, false, showBadge: true),
                  if(loggedInUser != null)
                  _buildDivider(),
                  _buildRow(Icons.notifications, "Notifications", NotificationScreen.routeName, false),
                  _buildDivider(),
                  _buildRow(Icons.question_answer, "FAQs", FAQScreen.routeName, false),
                  _buildDivider(),
                  _buildRow(Icons.info_outline, "Guides / Tips", TipsScreen.routeName, false),
                  _buildDivider(),
                  _buildRow(Icons.wrap_text, "News", NewsScreen.routeName, false),
                  _buildDivider(),
                  if(loggedInUser != null)
                    _buildRow(Icons.email, "Contact us", ContactUsScreen.routeName, true),
                  if(loggedInUser == null)
                    _buildRow(Icons.email, "Contact us", ContactUsGuestScreen.routeName, false),
                    _buildDivider(),
                  if(loggedInUser == null)
                    _buildRow(Icons.exit_to_app, "Login / Register", "dlgLogin", false),
                  if(loggedInUser != null)
                    _buildRow(Icons.settings, "My Account", MyAccountScreen.routeName, false),
                    _buildDivider(),
                  if(loggedInUser != null)
                  _buildRow(Icons.power_settings_new, "Logout", 'logout', false),
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/img/logo.png',
                      fit: BoxFit.contain,
                    ),
                    padding: EdgeInsets.only(
                      left: 80,
                      right: 80,
                      top: 50,
                      bottom: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}