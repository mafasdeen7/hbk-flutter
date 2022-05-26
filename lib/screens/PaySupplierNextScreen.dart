import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hbk/models/PesoValue.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/PaySupplierProvider.dart';
import 'package:hbk/providers/PesoValueProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widget_dlg/DlgInfo.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:provider/provider.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';

class PaySupplierNextScreen extends StatefulWidget {
  static const routeName = "/pay-supplier_next";

  @override
  _PaySupplierNextScreenState createState() => _PaySupplierNextScreenState();
}

class _PaySupplierNextScreenState extends State<PaySupplierNextScreen> {
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
  String base64Image="";

  PesoValue _pesoValue;
  bool _loadedInitData = false;
  bool _loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;

  _sendPaySupplier() async {
    print('Dx : Pay Supplier');
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    _formKey.currentState.save();

    String token = Provider.of<UserProvider>(context, listen: false).token;
    bool sendData =
        await Provider.of<PaySupplierProvider>(context, listen: false).sendData(
            token,
            _amount.text,
            _beneficiaryName.text,
            _beneficiaryAddress.text,
            _bankName.text,
            _bankAddress.text,
            _accountNumber.text,
            _swiftCode.text,
            _country.text,
            _name.text,
            _email.text,
            _fileName,
            base64Image);

    String msg ='We have already received your request to pay for your supplier and the important information we need to send the payment to your supplier. Allow us 24-48 hours to process this request and then we will email you copy of bank receipt as proof that your supplier has been paid. However, should we need more information and/or if we have queries, we will get in touch with you directly';
    if (!sendData) {
      msg = 'Payment Details Sending Failed';
    }
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return DlgInfo(msg,'paySupplier');
      },
    );
    // if (sendData) {
    //   Navigator.pop(context);
    // }
    setState(() {
      loading = false;
    });
  }

  Widget getCalculator(int addition, double multiply) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MyMessage(
          type: MessageType.Info,
          msg:
              'Please use our online calculator to see how much you need to pay for your Supplier Payment Dollar Purchase',
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 10,
        ),
        _loading ?
          Container(
            padding: EdgeInsets.all(8.0),
            child: MyProgressWithMsg(
              msg: 'Loading...',
            ),
          )
        : TextFormField(
          onChanged: (text) {
            print("First text field: $text");
            double val = double.tryParse(text) ?? 0;
            double amount = (val * multiply) + addition;
            _needToPayCnt.text = "₱  " + amount.toStringAsFixed(2);
          },
          decoration: InputDecoration(
            labelText: 'Amount to pay in USD',
            hintText: 'Amount you need to pay your supplier in USD',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters:[FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
        ),
        SizedBox(
          height: 10,
        ),
        MyInputWidget(
          labelText: 'You may deposit this amount',
          isReadOnly: true,
          controller: _needToPayCnt,
        ),
        SizedBox(
          height: 10,
        ),
        MyMessage(
          type: MessageType.Info,
          msg:
              'You may deposit above amount to our BDO Saving Account: HBK Global Trading - 002070072653\n\nTotal is already inclusive of ₱1500 service fee',
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: 5,
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

  Widget sendSupplierPayments(){
    return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  child: 
                    Text(
                      'Send a payment to supplier',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        ),
                    ),
                ),
                      MyMessage(
                        type: MessageType.Info,
                        msg:
                            '- Please make sure that all information including their spelling is 100% correct. Any wrong data would definitely cause your payment to bounce back, causing delays and extra charges. Kindly review before submitting the form\n\n- We cannot send to personal accounts',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Amount in USD *',
                        isRequired: true,
                        isNumber: true,
                        controller: _amount,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Beneficiary Name *',
                        isRequired: true,
                        controller: _beneficiaryName,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Beneficiary Address *',
                        isRequired: true,
                        controller: _beneficiaryAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Bank Name *',
                        isRequired: true,
                        controller: _bankName,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Bank Address *',
                        isRequired: true,
                        controller: _bankAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Account Number *',
                        isRequired: true,
                        controller: _accountNumber,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Swift Code *',
                        isRequired: true,
                        controller: _swiftCode,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Country *',
                        isRequired: true,
                        controller: _country,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(' Send Us Copy of Your Deposit Slip'),
                          MyButton(
                            txt: 'Browse',
                            clicked: () {
                              _openFileExplorer();
                            },
                          ),
                        ],
                      ),
                      new Builder(
                        builder: (BuildContext context) => _loadingPath
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: const CircularProgressIndicator())
                            : _path != null || _paths != null
                                ? new Container(
                                    child: Text(_fileName),
                                  )
                                : new Container(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: MyButton(
                          txt: 'Submit',
                          clicked: () {
                            _sendPaySupplier();
                          },
                          loading: loading,
                          loadingText: 'Submitting',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      MyMessage(
                        type: MessageType.Info,
                        msg:
                            '- Be sure to send us copy of your deposit slip so we can start the process\n\n- Give us lead time of 48 – 72 hours upon receipt of your copy of deposit slip (Saturdays, Sundays, and holidays not included) before we send you proof of payment to your supplier.',
                        textAlign: TextAlign.left,
                      ),                
      ],
    );
  }


  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.custom;

//https://www.coderzheaven.com/2019/04/30/upload-image-in-flutter-using-php/
  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _paths = null;
      _path = await FilePicker.getFilePath(
          type: _pickingType,
          allowedExtensions: ['jpeg', 'jpg', 'png'],
          );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    try
    {
      print('Image start to convert : '+_path);
      File imageFile = new File(_path);
      List<int> imageBytes = imageFile.readAsBytesSync();
      base64Image = base64.encode(imageBytes);
      print('Image base64Image : '+base64Image);
    }
    catch (e) {
      print('Error on converting image : '+e.toString());
    }
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
      // _depositSlip.text = _path;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context, listen: false).loggedInUser;
    _name.text = user.displayName.toString();
    _email.text = user.email.toString();
    Provider.of<PaySupplierProvider>(context).isPaymentDetailSent(false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay for your supplier'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  sendSupplierPayments(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
