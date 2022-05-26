import 'package:flutter/material.dart';
import 'package:hbk/models/ShippingSummary.dart';
import 'package:hbk/providers/ShippingSummaryProvider.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';

class ShowShippingSummaryScreen extends StatefulWidget {
  static const routeName = "/shipping-summary";

  @override
  _ShowShippingSummaryScreenState createState() =>
      _ShowShippingSummaryScreenState();
}

class _ShowShippingSummaryScreenState extends State<ShowShippingSummaryScreen> {
  ShippingSummary shippingSummary;
  TextEditingController _containerNumberCnt = TextEditingController();
  TextEditingController _statusCnt = TextEditingController();
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  _getContainerData() async {
    print('shipping summary');
    print(_containerNumberCnt.text);
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    _formKey.currentState.save();

    String token = Provider.of<UserProvider>(context, listen: false).token;
    shippingSummary =
        await Provider.of<ShippingSummaryProvider>(context, listen: false)
            .getData(_containerNumberCnt.text, token);

    // if (sendMail) {
    //   Navigator.pop(context);
    // }

    setState(() {
      _statusCnt.text = shippingSummary.status;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _containerNumberCnt.text = "";
    // _statusCnt.text = "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Summary'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: new Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MyMessage(
                          type: MessageType.Info,
                          msg:
                              'NOTE: Container number status are updated daily. If your supplier just sent out your item within 24 hours, it might not have been loaded yet. Check again later'
                              +'\n\nFor cargo tracking, please enter the container number where your cargo is supposedly loaded.'
                              +'\n\nAsk your supplier to inquire about this information from warehouse (if they indeed shipped your item to one of our warehouse). They have the contact name and number there so it is easy to aquire this information.'
                              +'\n\nFormat of container number is either A123 or B123. A is a container coming from Yiwu and B is from Guangzhou. The last 3 digits will be the container number.'
                              +'\n\nExample:\nA912 is a container coming from Yiwu.\nB295 is a container coming from Guangzhou.',
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        // MyMessage(
                        //   type: MessageType.Info,
                        //   msg:
                        //       'For cargo tracking, please enter the container number where your cargo is supposedly loaded.',
                        //   textAlign: TextAlign.left,
                        // ),
                        // SizedBox(
                        //   height: 3,
                        // ),
                        // MyMessage(
                        //   type: MessageType.Info,
                        //   msg:
                        //       'Ask your supplier to inquire about this information from warehouse (if they indeed shipped your item to one of our warehouse). They have the contact name and number there so it is easy to aquire this information.',
                        //   textAlign: TextAlign.left,
                        // ),
                        // SizedBox(
                        //   height: 3,
                        // ),
                        // MyMessage(
                        //   type: MessageType.Info,
                        //   msg:
                        //       'Format of container number is either A123 or B123. A is a container coming from Yiwu and B is from Guangzhou. The last 3 digits will be the container number.',
                        //   textAlign: TextAlign.left,
                        // ),
                        // SizedBox(
                        //   height: 3,
                        // ),
                        // MyMessage(
                        //   type: MessageType.Info,
                        //   msg:
                        //       'Example:\nA912 is a container coming from Yiwu.\nB295 is a container coming from Guangzhou.',
                        //   textAlign: TextAlign.left,
                        // ),
                        // SizedBox(
                        //   height: 3,
                        // ),
                        MyMessage(
                          type: MessageType.Info,
                          msg: '',
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputWidget(
                          labelText: 'Container Number',
                          isRequired: true,
                          controller: _containerNumberCnt,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: MyButton(
                            txt: 'Submit',
                            clicked: () {
                              _getContainerData();
                            },
                            loading: loading,
                            loadingText: 'Submitting',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputWidget(
                          labelText: 'Status',
                          controller: _statusCnt,
                          isReadOnly: true,
                          // isTextArea: true,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
