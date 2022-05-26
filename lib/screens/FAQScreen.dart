import 'package:flutter/material.dart';
import 'package:hbk/models/FAQ.dart';
import 'package:hbk/providers/FAQProvider.dart';
import 'package:hbk/screens/FAQDetailScreen.dart';
import 'package:hbk/screens/MyWebView.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class FAQScreen extends StatefulWidget {
  static const routeName = "/faq";

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<Widget> faqList = new List();
  bool _loadedInitData = false;
  bool _loading = false;

  showDetail(int id, String title, String url) {
    Navigator.pushNamed(context, FAQDetailScreen.routeName,
        arguments: {'id': id, 'title': title});
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) => MyWebView(
    //           title: title,
    //           selectedUrl: url,
    //           content: "",
    //         )));
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      faqList.clear();
      List<FAQ> list = await Provider.of<FAQProvider>(context).getAllFAQ();

      list.forEach((f) {
        faqList.add(MyListItemWidget(
          title: f.title,
          onClick: () {
            showDetail(
                f.id, f.title, "https://www.hbkglobaltrading.com/?p=1346");
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
    return faqList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body: ListView(
        children: <Widget>[
          PageTitleWidget('Frequently Asked Questions'),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Please take time to browse through our FAQs, you just might find an answer to some of your questions',
              textAlign: TextAlign.center,
            ),
          ),
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
