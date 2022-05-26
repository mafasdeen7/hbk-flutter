import 'package:flutter/material.dart';
import 'package:hbk/screens/PaySupplierScreen.dart';
import 'package:hbk/screens/ShipPackFromChinaScreen.dart';
import 'package:hbk/screens/ShipPackFromTaiwanScreen.dart';
import 'package:hbk/widget_dlg/DlgLogin.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = "/services";

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  showDetail(String routeName) {
    // check if the user is logged in
    // if not logged in show login page.
    bool isLoggedIn = Provider.of<UserProvider>(context, listen: false).isLoggedIn;
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

  Widget getServiceItem(String title, String subtitle, String routeName) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
      child: MyListItemWidget(
        title: title,
        subTitle: subtitle,
        onClick: () {
          showDetail(routeName);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body: ListView(
        children: <Widget>[
          PageTitleWidget('Services'),
          getServiceItem(
            'Ship a package from China',
            'Here we can add more information about this service',
            ShipPackFromChinaScreen.routeName,
          ),
          getServiceItem(
            'Ship a package from Taiwan',
            'Here we can add more information about this service',
            ShipPackFromTaiwanScreen.routeName,
          ),
          getServiceItem(
            'Pay for your supplier',
            'Having difficulty acquiring the dollars for supplier’s payment? Unable to send payment to a supplier?\n\nIf you need to purchase dollars for your supplier’s payment, or just need to send those funds via bank wire transfer, we can definitely assist you.',
            PaySupplierScreen.routeName,
          ),
          // getServiceItem(
          //   'Pay for your supplier with finance',
          //   'Need financing for an extra cash flow until your item gets here?\n\nWe offer in house financing for your shipment until they get here.',
          //   PaySupplierFinanceScreen.routeName,
          // ),
        ],
      ),
    );
  }
}
