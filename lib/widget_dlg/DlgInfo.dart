import 'package:flutter/material.dart';
import 'package:hbk/providers/PaySupplierProvider.dart';
import 'package:hbk/widget_controllers/MyButton.dart';
import 'package:hbk/widget_dlg/DlgHeader.dart';
import 'package:provider/provider.dart';

class DlgInfo extends StatefulWidget {
  final String msg;
  final String screen;

  DlgInfo(this.msg, this.screen);

  @override
  _DlgInfoState createState() => _DlgInfoState();
}

class _DlgInfoState extends State<DlgInfo> {
  _okay() {
    if(widget.screen =='paySupplier'){
      var nav = Navigator.of(context);
      nav.pop();
      nav.pop();
      nav.pop();
    }
    else{
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DlgHeader('Info'),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  widget.msg,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                MyButton(
                  txt: 'Okay',
                  clicked: _okay,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
