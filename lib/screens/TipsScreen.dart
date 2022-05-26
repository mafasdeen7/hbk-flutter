import 'package:flutter/material.dart';
import 'package:hbk/models/Tip.dart';
import 'package:hbk/screens/TipsDetailScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import '../providers/TipsProvider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class TipsScreen extends StatefulWidget {
  static const routeName = "/tips";

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  List<Widget> tipList = new List();
  bool _loadedInitData = false;
  bool _loading = false;

  showDetail(int id, String title) {
    Navigator.pushNamed(context, TipsDetailScreen.routeName,
        arguments: {'id': id, 'title': title});
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      List<Tip> list = await Provider.of<TipsProvider>(context).getAllTips();

      list.forEach((f) {
        tipList.add(MyListItemWidget(
          title: f.title,
          onClick: () {
            showDetail(f.id, f.title);
          },
        ));
      });

      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
  }

  List<Widget> getList() {
    return tipList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body: ListView(
        children: <Widget>[
          PageTitleWidget('Guides / Tips'),
          _loading
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: MyProgressWithMsg(
                    msg: 'Loading...',
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: getList(),
                  ),
                ),
        ],
      ),
    );
  }
}
