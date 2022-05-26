import 'package:flutter/material.dart';
import 'package:hbk/models/PaySupplier.dart';
import 'package:hbk/providers/PaySupplierProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/ShowMySupplierPaymentDetailScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyListItemWidget.dart';
import 'package:provider/provider.dart';

class ShowMySupplierPaymentsScreen extends StatefulWidget {
  static const routeName = "/my-supplier-payments";

  @override
  _ShowMySupplierPaymentsScreenState createState() =>
      _ShowMySupplierPaymentsScreenState();
}

class _ShowMySupplierPaymentsScreenState
    extends State<ShowMySupplierPaymentsScreen> {
  List<Widget> itemList = new List();
  bool _loadedInitData = false;
  bool _loading = false;

  showDetail(
    int id,
    String name,
    String amount,
    String beneficiary_name,
    String beneficiary_address,
    String bank_name,
    String bank_address,
    String account_number,
    String swift_code,
    String country,
    String email,
    String deposit_slip,
    String paymentStatus
  ) {
    Navigator.pushNamed(context, ShowMySupplierPaymentDetailScreen.routeName,
        arguments: {
          'id': id,
          'name': name,
          'amount': amount,
          'beneficiary_name': beneficiary_name,
          'beneficiary_address': beneficiary_address,
          'bank_name': bank_name,
          'bank_address': bank_address,
          'account_number': account_number,
          'swift_code': swift_code,
          'country': country,
          'email': email,
          'deposit_slip': deposit_slip,
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
     
      await Provider.of<PaySupplierProvider>(context).getAllData(token);

      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
  }

  List<Widget> getList(List<PaySupplier> list) {
    itemList.clear();
    list.forEach((f) {
        itemList.add(MyListItemWidget(
          title: f.id.toString() +
              ' | ' +
              f.name +
              ' | ' +
              f.amount +
              ' || = '+f.paymentStatus,
          onClick: () {
            showDetail(
              f.id,
              f.name,
              f.amount,
              f.beneficiary_name,
              f.beneficiary_address,
              f.bank_name,
              f.bank_address,
              f.account_number,
              f.swift_code,
              f.country,
              f.email,
              f.deposit_slip,
              f.paymentStatus,
            );
          },
        ));
      });
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    List<PaySupplier> list = Provider.of<PaySupplierProvider>(context).paySupplierList;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Supplier Payments'),
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
                        'No Payments Found.!',
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
