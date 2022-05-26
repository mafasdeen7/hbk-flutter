import 'package:flutter/material.dart';
import 'package:hbk/models/PriceQuote.dart';
import 'package:hbk/providers/RequestQuoteProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/ShowMyPriceQuoteDetailScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:provider/provider.dart';

class ShowMyPriceQuoteScreen extends StatefulWidget {
  static const routeName = "/myqoute";

  @override
  _ShowMyPriceQuoteScreenState createState() => _ShowMyPriceQuoteScreenState();
}

class _ShowMyPriceQuoteScreenState extends State<ShowMyPriceQuoteScreen> {
  List<Widget> quoteList = new List();
  bool _loadedInitData = false;
  bool _loading = false;

  showDetail(
      int id,
      String name,
      String boxWeight,
      String country_of_origin,
      String item_description,
      String length,
      String width,
      String height,
      String dimension,
      String weight_type,
      String box_qty,
      String contact_number,
      String message,
      String paymentStatus) {
    Navigator.pushNamed(context, ShowMyPriceQuoteDetailScreen.routeName,
        arguments: {
          'id': id,
          'name': name,
          'boxWeight': boxWeight,
          'country_of_origin': country_of_origin,
          'item_description': item_description,
          'length': length,
          'width': width,
          'height': height,
          'dimension': dimension,
          'weight_type': weight_type,
          'box_qty': box_qty,
          'contact_number': contact_number,
          'message': message,
          'payment_status': paymentStatus,
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
      await Provider.of<RequestQuoteProvider>(context).getAllQuote(token);

      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
  }

  // List<Widget> getList(List<PriceQuote> list) {
  //   faqList.clear();
  //   list.forEach((f) {
  //       faqList.add(MyListItemWidget(
  //         title: f.id.toString() +
  //             ' | ' +
  //             f.country_of_origin +
  //             ' | ' +
  //             f.item_description +
  //             ' | ' +
  //             f.length +
  //             ' | ' +
  //             f.width +
  //             ' | ' +
  //             f.height +
  //             ' | ' +
  //             f.dimension +
  //             ' || = '+f.paymentStatus,
  //         onClick: () {
  //           showDetail(
  //               f.id,
  //               f.name,
  //               f.box_weight,
  //               f.country_of_origin,
  //               f.item_description,
  //               f.length,
  //               f.width,
  //               f.height,
  //               f.dimension,
  //               f.weight_type,
  //               f.box_qty,
  //               f.contact_number,
  //               f.message,
  //               f.paymentStatus);
  //         },
  //       ));
  //     });
  //   return faqList;
  // }

  List<Widget> getList(List<PriceQuote> list) {
      quoteList.clear();
      list.forEach((f) {
        quoteList.add(Card(
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
                f.id.toString() +
                ' | ' +
                f.country_of_origin +
                ' | ' +
                f.item_description +
                ' | ' +
                f.length +
                ' | ' +
                f.width +
                ' | ' +
                f.height +
                ' | ' +
                f.dimension,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              subtitle: Text('Quote Status : \$'+f.paymentStatus, 
                style: TextStyle(
                  fontSize: 18,
                )),
              trailing: (f.is_user_read=="0")? Icon(Icons.fiber_new, color: Colors.red,):Icon(Icons.arrow_forward),
              onTap: () {
                showDetail(
                  f.id,
                  f.name,
                  f.box_weight,
                  f.country_of_origin,
                  f.item_description,
                  f.length,
                  f.width,
                  f.height,
                  f.dimension,
                  f.weight_type,
                  f.box_qty,
                  f.contact_number,
                  f.message,
                  f.paymentStatus
                );
              },
            ),
          ),
        ),
      );
        });
      return quoteList;
    }

  @override
  Widget build(BuildContext context) {
    List<PriceQuote> list = Provider.of<RequestQuoteProvider>(context).quoteList;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Price Quotes'),
      ),
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
                        'No Quots Found.!',
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
