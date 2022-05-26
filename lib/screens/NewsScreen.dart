import 'package:flutter/material.dart';
import 'package:hbk/models/News.dart';
import 'package:hbk/providers/NewsProvider.dart'; 
import 'package:hbk/screens/NewsDetailScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class NewsScreen extends StatefulWidget {
  static const routeName = "/news";

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<Widget> tipList = new List();
  bool _loadedInitData = false;
  bool _loading = false;

  showDetail(int id, String title) {
    Navigator.pushNamed(context, NewsDetailScreen.routeName,
        arguments: {'id': id, 'title': title});
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      List<News> list = await Provider.of<NewsProvider>(context).getAllNews();

      list.forEach((f) {
        tipList.add(MyListItemWidget(
          title: f.title,
          onClick: () {
            showDetail(f.id, f.title);
          },
        ));
      });

      // list.forEach((f) {
      //   tipList.add(
      //   Card(
      //         margin: EdgeInsets.symmetric(
      //           vertical: 3,
      //           horizontal: 3,
      //         ),
      //         child: Column(
      //           children: <Widget>[
      //             ListTile(
      //               contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      //               leading: new Icon(Icons.dashboard),
      //               title: Text(f.title),
      //               subtitle: Padding( child: 
      //                             Text(f.content60+'...', 
      //                               style: TextStyle(fontSize: 13),
      //                             ),
      //                             padding: EdgeInsets.only(top: 5),)
      //             ),
      //             ButtonBar(
      //               children: <Widget>[
      //                 FlatButton(
      //                   child: Text('READ MORE'),
      //                   onPressed: () { showDetail(f.id, f.title); },
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //     )
      //   );
      // });

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
          PageTitleWidget('News'),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: Text(
          //     'Please take time to browse through our News..!!',
          //     textAlign: TextAlign.center,
          //   ),
          // ),
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
