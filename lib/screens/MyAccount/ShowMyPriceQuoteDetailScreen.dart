import 'package:flutter/material.dart';
import 'package:hbk/models/PriceQuote.dart';
import 'package:hbk/providers/RequestQuoteProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/widget_controllers/MyInputWidget.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:hbk/widgets/MyMessage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowMyPriceQuoteDetailScreen extends StatefulWidget {
  static const routeName = "/myqoute-detail";

  @override
  _ShowMyPriceQuoteDetailScreenState createState() =>
      _ShowMyPriceQuoteDetailScreenState();
}

class _ShowMyPriceQuoteDetailScreenState
    extends State<ShowMyPriceQuoteDetailScreen> {
  PriceQuote selectedPriceQuote;
  bool _loadedInitData = false;
  bool _loading = false;
  int id;
  String name;

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
  TextEditingController _status = TextEditingController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      //
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      id = args['id'];
      name = args['name'];
      _boxWeight.text = args['boxWeight'];
      _itemDescription.text = args['item_description'];
      _length.text = args['length'];
      _width.text = args['width'];
      _height.text = args['height'];
      _selectedCountry = (args['country_of_origin'] == 'china' ||
              args['country_of_origin'] == 'taiwan')
          ? args['country_of_origin']
          : 'china';
      _selectedLength = (args['dimension'] == 'cm' ||
              args['dimension'] == 'in' ||
              args['dimension'] == 'm')
          ? args['dimension']
          : 'cm';
      _selectedWeight =
          (args['weight_type'] == 'kg' || args['weight_type'] == 'lb')
              ? args['weight_type']
              : 'kg';
      _boxQty.text = args['box_qty'];
      _contactNumber.text = args['contact_number'];
      _message.text = args['message'];
      _status.text = args['payment_status'];
      
      String token = Provider.of<UserProvider>(context).token;
      await Provider.of<RequestQuoteProvider>(context).getDetail(args['id'], token);
      Provider.of<RequestQuoteProvider>(context, listen: false).markedAsRead(args['id']);

      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
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

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  deleteQuote() async {
    print('mafas');
    print(id.toString());
    String token = Provider.of<UserProvider>(context, listen: false).token;
    print(token);
    bool deleteData =
        await Provider.of<RequestQuoteProvider>(context, listen: false)
            .deleteData(
      id.toString(),
      token,
    );

    if (deleteData) {
       Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Price Quote'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              showAlertDialog(context, deleteQuote);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  id.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _loading
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: MyProgressWithMsg(
                    msg: 'Loading...',
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      MyMessage(
                        type: MessageType.Success,
                        msg: 'Quote Status',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Quote',
                        controller: _status,
                        isReadOnly: true,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Requested Quotation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                        ),
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   'Kindly fill up the form below and we will immediately reply back to you.',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 13,
                      //     color: Colors.grey.shade600,
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
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
                              isReadOnly: true,
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
                        isReadOnly: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyInputWidget(
                        labelText: 'Item Description *',
                        isRequired: true,
                        controller: _itemDescription,
                        isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                              isReadOnly: true,
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
                        isNumber: true,
                        isRequired: true,
                        controller: _contactNumber,
                        isReadOnly: true,
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
                        isReadOnly: true,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context, Function deleteQuote) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Delete"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
      deleteQuote();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Confirmation?"),
    content: Text("Would you like to delete the Item "),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
