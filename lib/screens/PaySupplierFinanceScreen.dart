import 'package:flutter/material.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widgets/MyMessage.dart';

class PaySupplierFinanceScreen extends StatefulWidget {
  static const routeName = "/pay-supplier-finance";

  @override
  _PaySupplierFinanceScreenState createState() =>
      _PaySupplierFinanceScreenState();
}

class _PaySupplierFinanceScreenState extends State<PaySupplierFinanceScreen> {
  TextEditingController _needToPayCnt = TextEditingController();

  Widget getCalculator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MyMessage(
          type: MessageType.Info,
          msg:
              'Please use our online calculator to see how much you need to pay for your Financing',
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 10,
        ),
        MyInputWidget(
          labelText: 'Amount to pay in USD',
          hintText: 'Amount you need to pay your supplier in USD',
          isRequired: true,
        ),
        SizedBox(
          height: 10,
        ),
        Text('How many % of this total would you like for us to finance?'),
        Row(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'ewe',
                    groupValue: 'eewew',
                    onChanged: (String s) {},
                  ),
                  Text('werwe')
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'ewe',
                    groupValue: 'eewew',
                    onChanged: (String s) {},
                  ),
                  Text('werwe')
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 'ewe',
                    groupValue: 'eewew',
                    onChanged: (String s) {},
                  ),
                  Text('werwe')
                ],
              ),
            ),
          ],
        ),
        Text(
            'This is your share. We will take care of the remaining amount and then send the total to your supplier'),
        SizedBox(
          height: 10,
        ),
        MyInputWidget(
          labelText: 'This is your share',
          isReadOnly: true,
          controller: _needToPayCnt,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
            'Your Total in Peso. You may deposit this amount to our BDO Savings Account: HBK Global Trading - 002070072653'),
        SizedBox(
          height: 10,
        ),
        MyInputWidget(
          labelText: 'Your Total in Peso',
          isReadOnly: true,
          controller: _needToPayCnt,
        ),
        SizedBox(
          height: 3,
        ),
        Text('Total is already inclusive of ₱1500 service fee'),
        SizedBox(
          height: 10,
        ),
        MyMessage(
          type: MessageType.Error,
          msg:
              'Note that the displayed amount is valid only until 2PM of current date',
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget getInfo() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'So how does it work ?',
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(
              '- We can finance up to 50% of the total amount which needs to be paid to your supplier either in China, Taiwan, or Thailand.  Example: Total amount that needs to be paid is \$10,000 , we can finance up to 50% which is \$5,000.'),
        ),
        ListTile(
          title: Text(
            'How do we pay the supplier ?',
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Column(
            children: <Widget>[
              Text(
                  '- As mentioned, we can finance up to 50% so all you have to do is deposit in our Peso BDO account your part of the 50%.'),
              Text(
                  '- Once we have your 50%, we can now proceed in sending your supplier the payment.'),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _needToPayCnt.text = "₱ 1500";
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay for your supplier with finance'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: getCalculator(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                getInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
