import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/ContactUsProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/InboxScreen.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widgets/MyDrawerWidget.dart';
import 'package:hbk/widgets/PageTitleWidget.dart';
import 'package:hbk/widgets/myAppBar.dart';
import 'package:provider/provider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';


class ContactUsScreen extends StatefulWidget {
  static const routeName = "/contact-us";

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  TextEditingController _customerName = TextEditingController(text: "");
  TextEditingController _customerEmail = TextEditingController(text: "");
  TextEditingController _customerPhone = TextEditingController(text: "");
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

    String token = Provider.of<UserProvider>(context, listen: false).token;
    bool sendData = await Provider.of<ContactUsProvider>(context, listen: false)
        .sendData(token, _customerName.text, _customerEmail.text,_customerPhone.text, _customerSubject.text, _customerMessage.text,'');

    if (sendData) {
      await Navigator.pushReplacementNamed(context, InboxScreen.routeName);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).loggedInUser;
    _customerName.text = user.displayName.toString();
    _customerEmail.text = user.userName.toString();
    _customerPhone.text = user.contactNo.toString();

    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body: ListView(
        children: <Widget>[
          PageTitleWidget('Contact Us'),
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // MyInputWidget(
                  //   labelText: 'Name *',
                  //   isRequired: true,
                  //   controller: _customerName
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // MyInputWidget(
                  //   labelText: 'Email *',
                  //   isRequired: true,
                  //   isEmail: true,
                  //   controller: _customerEmail,
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // MyInputWidget(
                  //   labelText: 'Phone *',
                  //   isRequired: true,
                  //   isNumber: true,
                  //   controller: _customerPhone,
                  // ),
                  // SizedBox(
                  //   height: 3,
                  // ),
                  // Text(
                  //   'Kindly enter valid number so we can identify you if you call us for further questions/concerns',
                  //   style: TextStyle(
                  //     color: Colors.grey.shade600,
                  //     fontSize: 14,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
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
