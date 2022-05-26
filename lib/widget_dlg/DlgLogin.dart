import 'package:flutter/material.dart';
import 'package:hbk/providers/MessageProvider.dart';
import 'package:hbk/providers/RequestQuoteProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widget_dlg/DlgHeader.dart';
import 'package:hbk/widget_dlg/DlgInfo.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:provider/provider.dart';

enum DlgMode {
  Login,
  Register,
  ForgotPassword,
  ResettingPassword,
}

class DlgLogin extends StatefulWidget {
  @override
  _DlgLoginState createState() => _DlgLoginState();
}

class _DlgLoginState extends State<DlgLogin> {
  DlgMode dlgMode = DlgMode.Login;
  bool loading = false;
  //
  final GlobalKey<FormState> _formKey = GlobalKey();
  //
  // static String username = "admin_hbk";
  // static String password = "admin123";

  // static String username = "mafasdeen7@gmail.com";
  // static String password = "Mafas63337";

  var userNameCnt = TextEditingController();
  var passwordCnt = TextEditingController();

  var firstNameCnt = TextEditingController();
  var lastNameCnt = TextEditingController();
  var mobileCnt = TextEditingController();
  var emailCnt = TextEditingController();
  var addressCnt = TextEditingController();
  var rePasswordCnt = TextEditingController();
  var passwordResettingTokenCnt =
      TextEditingController();

  _login() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    _formKey.currentState.save();

    bool loggedIn = await Provider.of<UserProvider>(context, listen: false)
        .loginUser(userNameCnt.text, passwordCnt.text);

    if (loggedIn) {
      String token = Provider.of<UserProvider>(context, listen: false).token;
      Provider.of<MessageProvider>(context, listen: false).getUnReadMessageCount(token);
      Provider.of<RequestQuoteProvider>(context, listen: false).getUnreadQuateCount(token);
      Navigator.pop(context);
    }

    setState(() {
      loading = false;
    });
  }

  _register() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    _formKey.currentState.save();

    dynamic res =
        await Provider.of<UserProvider>(context, listen: false).signup(
      userNameCnt.text,
      firstNameCnt.text,
      lastNameCnt.text,
      emailCnt.text,
      passwordCnt.text,
      mobileCnt.text,
      addressCnt.text,
    );

    if (res['success']) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return DlgInfo(res['msg'],'');
        },
      );
    }

    setState(() {
      loading = false;
    });
  }

  _sendResettingToken() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    _formKey.currentState.save();

    bool sent = await Provider.of<UserProvider>(context, listen: false)
        .sendPasswordResettingToken(
      emailCnt.text,
    );

    if (sent) {
      setState(() {
        this.dlgMode = DlgMode.ResettingPassword;
      });
    }

    setState(() {
      loading = false;
    });
  }

  _resettingPassword() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    _formKey.currentState.save();

    bool changed = await Provider.of<UserProvider>(context, listen: false)
        .resettingPassword(
      emailCnt.text,
      passwordResettingTokenCnt.text,
      passwordCnt.text,
    );

    if (changed) {
      Navigator.pop(context);
    }

    setState(() {
      loading = false;
    });
  }

  passwordValidation() {
    if (passwordCnt.text.length <= 7) {
      return 'Must be atleast 8 charactors';
    }
    // if (passwordCnt.text.contains(new RegExp(r'[a-zA-Z0-9]'))) {
    //   return 'Must contain numbers(0-9) and charactors(A-Z)';
    // }
  }

  reEnterPasswordValidation() {
    if (passwordCnt.text != rePasswordCnt.text) {
      return 'Passwords do not match';
    }
  }

  List<Widget> loginWidgets() {
    return <Widget>[
      DlgHeader('Login'),
      Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              MyInputWidget(
                labelText: 'Username',
                isRequired: true,
                controller: userNameCnt,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Password',
                isRequired: true,
                isPassword: true,
                controller: passwordCnt,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: MyButton(
                  txt: 'Login',
                  clicked: _login,
                  loading: loading,
                  loadingText: 'Login...',
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Forgot Password?'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          this.dlgMode = DlgMode.ForgotPassword;
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('Create New Account'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          this.dlgMode = DlgMode.Register;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> registerWidgets() {
    return <Widget>[
      DlgHeader('Create Account'),
      Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              MyInputWidget(
                labelText: 'Username',
                isRequired: true,
                controller: userNameCnt,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Email',
                isRequired: true,
                isEmail: true,
                controller: emailCnt,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'First Name',
                isRequired: true,
                controller: firstNameCnt,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Last Name',
                isRequired: true,
                controller: lastNameCnt,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Password',
                isRequired: true,
                isPassword: true,
                controller: passwordCnt,
                additionalValidation: passwordValidation,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Re-enter password',
                isRequired: true,
                isPassword: true,
                controller: rePasswordCnt,
                additionalValidation: reEnterPasswordValidation,
              ),
              SizedBox(
                height: 5,
              ),
              MyMessage(
                    type: MessageType.Info,
                    msg:
                        '* Must be atleast 8 characters.',
                    textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Mobile',
                isRequired: true,
                controller: mobileCnt,
                isNumberOnly: true,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Address',
                isRequired: true,
                controller: addressCnt,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: MyButton(
                  txt: 'Register',
                  clicked: _register,
                  loading: loading,
                  loadingText: 'Registering...',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text('Forgot password ?'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        this.dlgMode = DlgMode.ForgotPassword;
                      });
                    },
                  ),
                  FlatButton(
                    child: Text('Login'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        this.dlgMode = DlgMode.Login;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> forgotPasswordWidgets() {
    return <Widget>[
      DlgHeader('Forgot password ?'),
      Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                  'We will send a password resetting token your email. Use this token to reset your password.'),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Email',
                hintText: 'Enter your email',
                isRequired: true,
                controller: emailCnt,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: MyButton(
                  txt: 'Send password resetting token',
                  clicked: _sendResettingToken,
                  loading: loading,
                  loadingText: 'Sending...',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Login'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        this.dlgMode = DlgMode.Login;
                      });
                    },
                  ),
                  FlatButton(
                    child: Text('Create Account'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        this.dlgMode = DlgMode.Register;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> resettingPasswordWidgets() {
    return <Widget>[
      DlgHeader('Resetting password'),
      Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              MyInputWidget(
                labelText: 'Password Resetting Token',
                isRequired: true,
                controller: passwordResettingTokenCnt,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'New Password',
                isRequired: true,
                isPassword: true,
                controller: passwordCnt,
                additionalValidation: passwordValidation,
              ),
              SizedBox(
                height: 10,
              ),
              MyInputWidget(
                labelText: 'Re-enter password',
                isRequired: true,
                isPassword: true,
                controller: rePasswordCnt,
                additionalValidation: reEnterPasswordValidation,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: MyButton(
                  txt: 'Reset password',
                  clicked: _resettingPassword,
                  loading: loading,
                  loadingText: 'Resetting...',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text('Login'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        this.dlgMode = DlgMode.Login;
                      });
                    },
                  ),
                  FlatButton(
                    child: Text('Create Account'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        this.dlgMode = DlgMode.Register;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> getWidgetList() {
    if (this.dlgMode == DlgMode.Login)
      return loginWidgets();
    else if (this.dlgMode == DlgMode.Register)
      return registerWidgets();
    else if (this.dlgMode == DlgMode.ForgotPassword)
      return forgotPasswordWidgets();
    else
      return resettingPasswordWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: getWidgetList(),
        ),
      ),
    );
  }
}
