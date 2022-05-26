import 'package:flutter/material.dart';
import 'package:hbk/models/PaySupplier.dart';
import 'package:hbk/providers/PaySupplierProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/ShowMySupplierPaymentsScreen.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:provider/provider.dart';

import 'ShowFullScreenImage.dart';

class ShowMySupplierPaymentDetailScreen extends StatefulWidget {
  static const routeName = "/my-supplier-payments-detail";

  @override
  _ShowMySupplierPaymentDetailScreenState createState() =>
      _ShowMySupplierPaymentDetailScreenState();
}

class _ShowMySupplierPaymentDetailScreenState
    extends State<ShowMySupplierPaymentDetailScreen> {
  PaySupplier selectedPaySupllier;
  bool _loadedInitData = false;
  bool _loading = false;
  int id;
  String nam = "dx";
  // String name;

  TextEditingController _needToPayCnt = TextEditingController();
  TextEditingController _amount = TextEditingController();
  TextEditingController _beneficiaryName = TextEditingController();
  TextEditingController _beneficiaryAddress = TextEditingController();
  TextEditingController _bankName = TextEditingController();
  TextEditingController _bankAddress = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();
  TextEditingController _swiftCode = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _depositSlip = TextEditingController();

  TextEditingController _status = TextEditingController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      //
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      id = args['id'];
      nam = args['name'];
      _name.text = args['name'];
      _amount.text = args['amount'];
      _beneficiaryName.text = args['beneficiary_name'];
      _beneficiaryAddress.text = args['beneficiary_address'];
      _bankName.text = args['bank_name'];
      _bankAddress.text = args['bank_address'];
      _accountNumber.text = args['account_number'];
      _swiftCode.text = args['swift_code'];
      _country.text = args['country'];
      _email.text = args['email'];
      _depositSlip.text = args['deposit_slip'];
      _status.text = args['payment_status'];

      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
  }

  deletePayment() async {
    print('delete');
    print(id.toString());

    String token = Provider.of<UserProvider>(context, listen: false).token;
    print(token);
    bool deleteData =
        await Provider.of<PaySupplierProvider>(context, listen: false)
            .deleteData(
      id.toString(),
      token,
    );

    if (deleteData) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var filePath = _depositSlip.text.split('/').last;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Supplier Payment'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              showAlertDialog(context, deletePayment);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  nam,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
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
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      MyMessage(
                        type: MessageType.Success,
                        msg: 'Supplier Payments Status',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Status',
                        controller: _status,
                        isReadOnly: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Requested Quotation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyInputWidget(
                        labelText: 'Amount in USD *',
                        isReadOnly: true,
                        controller: _amount,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Beneficiary Name *',
                        isReadOnly: true,
                        controller: _beneficiaryName,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Beneficiary Address *',
                        isReadOnly: true,
                        controller: _beneficiaryAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Bank Name *',
                        isReadOnly: true,
                        controller: _bankName,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Bank Address *',
                        isReadOnly: true,
                        controller: _bankAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Account Number *',
                        isReadOnly: true,
                        controller: _accountNumber,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Swift Code *',
                        isReadOnly: true,
                        controller: _swiftCode,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Country *',
                        isReadOnly: true,
                        controller: _country,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Image.network(
                                _depositSlip.text,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(filePath),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, ShowFullScreenImageScreen.routeName,
                              arguments: {
                                'fileUrl': _depositSlip.text,
                              });
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context, Function deletePayment) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Delete"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
      deletePayment();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Confirmation?"),
    content: Text("Would you like to delete the Item ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
