import 'package:flutter/material.dart';
import 'package:hbk/providers/ContactUsProvider.dart';
import 'package:hbk/screens/HomeScreen.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';


class ContactUsGuestScreen extends StatefulWidget {
  static const routeName = "/contact-us2";

  @override
  _ContactUsGuestScreenState createState() => _ContactUsGuestScreenState();
}

class _ContactUsGuestScreenState extends State<ContactUsGuestScreen> {

  TextEditingController _customerName = TextEditingController();
  TextEditingController _customerEmail = TextEditingController();
  TextEditingController _customerPhone = TextEditingController();
  TextEditingController _customerSubject = TextEditingController();
  TextEditingController _customerMessage = TextEditingController();
  TextEditingController _customerAttachement = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;
  // String token='';

  _sendContactUsMessage() async {
    print('Dx : Contact Us');

    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    _formKey.currentState.save();

    // String token = Provider.of<UserProvider>(context, listen: false).token;
    String token = "";
    bool sendData = await Provider.of<ContactUsProvider>(context, listen: false)
        .sendData(token, _customerName.text, _customerEmail.text,_customerPhone.text, _customerSubject.text, _customerMessage.text,'');
    
    if (sendData) {
      await Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body: ListView(
        children: <Widget>[
          PageTitleWidget('Contact Us Guest'),
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  MyInputWidget(
                    labelText: 'Name *',
                    isRequired: true,
                    controller: _customerName
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyInputWidget(
                    labelText: 'Email *',
                    isRequired: true,
                    isEmail: true,
                    controller: _customerEmail,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyInputWidget(
                    labelText: 'Phone *',
                    isRequired: true,
                    isNumberOnly: true,
                    controller: _customerPhone,
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
                    labelText: 'Subject *',
                    isRequired: true,
                    controller: _customerSubject,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyInputWidget(
                    labelText: 'Message *',
                    isTextArea: true,
                    isRequired: true,
                    controller: _customerMessage,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: MyButton(
                      txt: 'Submit',
                      clicked: _sendContactUsMessage,
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
