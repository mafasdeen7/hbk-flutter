import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/RequestQuoteProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/HomeScreen.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class RequestAQuoteScreen extends StatefulWidget {
  static const routeName = "/request-a-quote";

  @override
  _RequestAQuoteScreenState createState() => _RequestAQuoteScreenState();
}

class _RequestAQuoteScreenState extends State<RequestAQuoteScreen> {
  List<DropdownMenuItem<String>> countyList = [];
  List<DropdownMenuItem<String>> weightList = [];
  List<DropdownMenuItem<String>> lengthList = [];
  String _selectedCountry = "china";
  String _selectedWeight = "kg";
  String _selectedLength = "cm";

  TextEditingController _boxWeight = TextEditingController();
  TextEditingController _boxQty = TextEditingController();
  TextEditingController _itemDescription = TextEditingController();
  TextEditingController _length = TextEditingController();
  TextEditingController _width = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _contactNumber = TextEditingController();
  TextEditingController _message = TextEditingController(text: '');

final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;
  
  _sendRequestQuote() async{
    print('Dx : Request Quote');
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    _formKey.currentState.save();

    User user = Provider.of<UserProvider>(context, listen: false).loggedInUser;
    String name = user.displayName.toString();
    String email = user.email.toString();
    String token = Provider.of<UserProvider>(context, listen: false).token;
    bool sendData = await Provider.of<RequestQuoteProvider>(context, listen: false)
        .sendData(name, email, _selectedCountry, _boxWeight.text,_selectedWeight, _boxQty.text, _itemDescription.text, _length.text, _width.text, _height.text, _selectedLength, _contactNumber.text, _message.text, token);

    if (sendData) {
      await Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }

    setState(() {
      loading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    countyList.add(
      DropdownMenuItem<String>(
        child: Text('China'),
        value: 'china',
      ),
    );
    countyList.add(
      DropdownMenuItem<String>(
        child: Text('Taiwan'),
        value: 'taiwan',
      ),
    );
    weightList.add(
      DropdownMenuItem<String>(
        child: Text('Kg - Kilogram'),
        value: 'kg',
      ),
    );
    weightList.add(
      DropdownMenuItem<String>(
        child: Text('Lb - Pound'),
        value: 'lb',
      ),
    );
    lengthList.add(
      DropdownMenuItem<String>(
        child: Text('cm'),
        value: 'cm',
      ),
    );
    lengthList.add(
      DropdownMenuItem<String>(
        child: Text('in'),
        value: 'in',
      ),
    );
    lengthList.add(
      DropdownMenuItem<String>(
        child: Text('m'),
        value: 'm',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).loggedInUser;
    _contactNumber.text = user.contactNo;

    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body: ListView(
        children: <Widget>[
          PageTitleWidget('Request A Quote'),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
              child: Form(
              key: _formKey,
              child: Column(
              children: <Widget>[
                Text(
                  'Do you need an immediate quotation from us?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Kindly fill up the form below and we will immediately reply back to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                MyMessage(
                  type: MessageType.Info,
                  msg:
                      'All Quotes are based on the kind of item, weight and size of the cargo and won\'t cost a peso more (if your figures are 100% accurate, or it could be more/less if it is larger/smaller and/or heavier/lighter once we receive it. We always follow the actual weight and size). All quotes are inclusive of Customs fees, importation charges, duties, etc. In short, it is all set and ready for pickup in our warehouse here in Manilla. Shipping is usually 21-30 days average upon departure from China.',
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  hint: Text('Country of Origin'),
                  isDense: true,
                  items: countyList,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _selectedCountry,
                  onChanged: (String v) {
                    setState(() {
                      _selectedCountry = v;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                MyMessage(
                  type: MessageType.Info,
                  msg:
                      'If you have multiple boxes of different size and weight, kindly fill in "1" on Length, Width, and Height field. You may then enumerate all details in "Additional Message" field at the bottom of this page.',
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: MyInputWidget(
                        labelText: 'Per box weight *',
                        isNumber: true,
                        isRequired: true,
                        controller: _boxWeight,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: DropdownButton(
                        value: _selectedWeight,
                        onChanged: (v) {
                          setState(() {
                            _selectedWeight = v;
                          });
                        },
                        items: weightList,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MyInputWidget(
                  labelText: 'Quantity of boxes *',
                  isNumber: true,
                  isRequired: true,
                  controller: _boxQty,
                ),
                SizedBox(
                  height: 10,
                ),
                MyInputWidget(
                  labelText: 'Item Description *',
                  isRequired: true,
                  controller: _itemDescription,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: MyInputWidget(
                        labelText: 'Length *',
                        isNumber: true,
                        isRequired: true,
                        controller: _length,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: MyInputWidget(
                        labelText: 'Width *',
                        isNumber: true,
                        isRequired: true,
                        controller: _width,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: MyInputWidget(
                        labelText: 'Height *',
                        isNumber: true,
                        isRequired: true,
                        controller: _height,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: DropdownButton(
                        value: _selectedLength,
                        onChanged: (v) {
                          setState(() {
                            _selectedLength = v;
                          });
                        },
                        items: lengthList,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MyInputWidget(
                  labelText: 'Contact Number *',
                  isNumberOnly: true,
                  isRequired: true,
                  controller: _contactNumber,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Kindly enter valid number so we can identify you if you call us for further questions/concerns',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyInputWidget(
                  labelText: 'Additional Message (Optional)',
                  isTextArea: true,
                  controller: _message,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  child: MyButton(
                    txt: 'Submit',
                    clicked: (){ _sendRequestQuote(); },
                    loading: loading,
                    loadingText: 'Submitting',
                  ),
                ),
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
