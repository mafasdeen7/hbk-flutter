import 'package:flutter/material.dart';
import 'package:hbk/widget_controllers/MyProgressIndicator.dart';
//

class MyProgressWithMsg extends StatelessWidget {
  final Color color;
  final String msg;

  MyProgressWithMsg({this.color = Colors.blue, this.msg = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyProgressIndicator(
          color: this.color,
        ),
        SizedBox(
          width: 10,
        ),
        Text(this.msg),
      ],
    );
  }
}
