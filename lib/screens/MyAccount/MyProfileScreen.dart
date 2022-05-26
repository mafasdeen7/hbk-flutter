import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/UpdateContactsProvider.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';

class MyProfileScreen extends StatefulWidget {
  static const routeName = "/my-profile";

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  TextEditingController _customerIDCnt = TextEditingController();
  TextEditingController _customerContactNumber = TextEditingController();
  TextEditingController _customerAddress = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;

  _updateUserData() async {
    print('Dx : Update Contact');
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    _formKey.currentState.save();

    Provider.of<UserProvider>(context, listen: false)
        .updateloggedInUser(_customerContactNumber.text, _customerAddress.text);

    String token = Provider.of<UserProvider>(context, listen: false).token;
    bool sendData = await Provider.of<UpdateContactsProvider>(context,
            listen: false)
        .sendData(_customerContactNumber.text, _customerAddress.text, token);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
    _customerIDCnt.text = loggedInUser.customerId.toString();
    _customerAddress.text = loggedInUser.address.toString();
    _customerContactNumber.text = loggedInUser.contactNo.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Center(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        width: 160.0,
                        height: 160.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/img/user.jpg'),
                            ))),
                    new Text(loggedInUser.firstName+' '+loggedInUser.lastName, textScaleFactor: 1.5),
                    new Text(loggedInUser.email, textScaleFactor: 1.5)
                  ],
                )),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      MyInputWidget(
                        labelText: 'Contact Number',
                        controller: _customerContactNumber,
                        isNumber: true,
                        // isReadOnly: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Address',
                        controller: _customerAddress,
                        isTextArea: true,
                        textAreaLine: 3,
                        // isReadOnly: true,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        child: MyButton(
                          txt: 'Update',
                          clicked: () {
                            _updateUserData();
                          },
                          loading: loading,
                          loadingText: 'Submitting',
                        ),
                      ),
                    ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
