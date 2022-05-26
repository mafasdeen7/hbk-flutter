import 'package:flutter/material.dart';
import 'package:hbk/screens/PaySupplierFinanceScreen.dart';
import 'package:hbk/screens/PaySupplierScreen.dart';
import 'package:hbk/screens/ShipPackFromChinaScreen.dart';
import 'package:hbk/screens/ShipPackFromTaiwanScreen.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = "/services";

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  Widget getServiceItem(String title, String subtitle, String routeName) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.grey.shade300),
        ),
        height: 70,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 6.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0)),
                color: Theme.of(context).primaryColor,
              ),
            ),
            Flexible(
              child: ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pushNamed(context, routeName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      drawer: MyDrawerWidget(),
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
            'Here we can add more information about this service',
            PaySupplierScreen.routeName,
          ),
          getServiceItem(
            'Pay for your supplier with finance',
            'Here we can add more information about this service',
            PaySupplierFinanceScreen.routeName,
          ),
        ],
      ),
    );
  }
}
