import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/SendEmailProvider.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widget_dlg/DlgInfo.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:provider/provider.dart';
import '../providers/UserProvider.dart';

class ShipPackFromTaiwanScreen extends StatefulWidget {
  static const routeName = "/ship-pack-taiwan";

  @override
  _ShipPackFromTaiwanScreenState createState() =>
      _ShipPackFromTaiwanScreenState();
}

class _ShipPackFromTaiwanScreenState extends State<ShipPackFromTaiwanScreen> {
  TextEditingController _customerIDCnt = TextEditingController();
  TextEditingController _supplierLinkCnt = TextEditingController();

  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var supplierEmailCnt = TextEditingController();

  _submitSupplierEmail() async {
    print('Dxxx');
    print(supplierEmailCnt.text);
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    _formKey.currentState.save();

    String token = Provider.of<UserProvider>(context, listen: false).token;
    bool sendMail = await Provider.of<SendEmailProvider>(context, listen: false)
        .sendMail('taiwan', supplierEmailCnt.text, token);

    String msg ='We have already informed your supplier to ship your cargo using HBK. Once your supplier generates a shipping label as we instructed them to do, you will receive an email notification from our system. In the meantime, kindly sit back, relax, as we’ll advise you once the cargo is available. You can always track your cargo using the cargo tracking section of your app.';
    if (!sendMail) {
      // Navigator.pop(context);
      msg = 'Message Sending Failed';
    }
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return DlgInfo(msg,'');
      },
    );

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
    _customerIDCnt.text = loggedInUser.customerId.toString();
    _supplierLinkCnt.text = "http://taiwansupplier.hbkglobaltrading.com";

    return Scaffold(
      appBar: AppBar(
        title: Text('Ship a package from Taiwan'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      MyMessage(
                        type: MessageType.Info,
                        msg:
                            '- Enter the Email address of your supplier.\n- We will instruct them that you want to use our service for shipping.\n- No need to give your customer ID and link.We will tell them about it.',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Email of your supplier',
                        isEmail: true,
                        isRequired: true,
                        controller: supplierEmailCnt,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        child: MyButton(
                          txt: 'Submit',
                          clicked: _submitSupplierEmail,
                          loading: loading,
                          loadingText: 'Submitting',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text('OR'),
                ),
                MyMessage(
                  type: MessageType.Info,
                  msg:
                      'Give your customer ID and the following link to your supplier. So then can print out a shipping label for your cargo.',
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 10,
                ),
                MyInputWidget(
                  labelText: 'Customer ID',
                  controller: _customerIDCnt,
                  isReadOnly: true,
                ),
                SizedBox(
                  height: 10,
                ),
                MyInputWidget(
                  labelText: 'Supplier Link',
                  controller: _supplierLinkCnt,
                  isReadOnly: true,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  child: MyButton(
                    txt: 'Okay',
                    clicked: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
