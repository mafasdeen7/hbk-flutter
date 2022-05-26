import 'package:flutter/material.dart';
import 'package:hbk/providers/ShippingSummaryProvider.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:provider/provider.dart';
import '../../providers/UserProvider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = "/change-password";

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _currentPasswordCnt = TextEditingController();
  TextEditingController _newPasswordCnt = TextEditingController();
  TextEditingController _confirmPasswordCnt = TextEditingController();
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  _changePassword() async {
    print('change password');

    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    _formKey.currentState.save();

    String token = Provider.of<UserProvider>(context, listen: false).token;
    bool isChanged = await Provider.of<UserProvider>(context, listen: false)
        .changePassword(_currentPasswordCnt.text, _newPasswordCnt.text, token);

    if (isChanged) {
      Navigator.pop(context);
    }

    setState(() {
      loading = false;
    });
  }

  passwordValidation() {
    if (_newPasswordCnt.text.length <= 8) {
      return 'Must be atleast 8 charactors';
    }
  }

  reEnterPasswordValidation() {
    if (_newPasswordCnt.text != _confirmPasswordCnt.text) {
      return 'Passwords do not match';
    }
  }

  @override
  Widget build(BuildContext context) {
    // _containerNumberCnt.text = "";
    // _statusCnt.text = "";

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
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
                        MyInputWidget(
                          labelText: 'Current Password',
                          isRequired: true,
                          controller: _currentPasswordCnt,
                          isPassword: true,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputWidget(
                          labelText: 'New Password',
                          isRequired: true,
                          controller: _newPasswordCnt,
                          isPassword: true,
                          additionalValidation: passwordValidation,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MyInputWidget(
                          labelText: 'Confirm Password',
                          isRequired: true,
                          controller: _confirmPasswordCnt,
                          isPassword: true,
                          additionalValidation: reEnterPasswordValidation,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        MyMessage(
                              type: MessageType.Info,
                              msg:
                                  '* Must be atleast 8 charactors.',
                              textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: MyButton(
                            txt: 'Change',
                            clicked: () {
                              _changePassword();
                            },
                            loading: loading,
                            loadingText: 'Submitting',
                          ),
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
