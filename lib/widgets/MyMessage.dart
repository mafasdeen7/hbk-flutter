import 'package:flutter/material.dart';

enum MessageType { Error, Success, Warning, Info }

class MyMessage extends StatelessWidget {
  final msg;
  final MessageType type;
  final textAlign;

  Color get _borderColor {
    if (type == MessageType.Error)
      return Colors.red.shade700;
    else if (type == MessageType.Info)
      return Colors.blue.shade700;
    else if (type == MessageType.Success)
      return Colors.green.shade700;
    else
      return Colors.orange.shade700;
  }

  Color get _boxColor {
    if (type == MessageType.Error)
      return Colors.red.shade400;
    else if (type == MessageType.Info)
      return Colors.blue.shade400;
    else if (type == MessageType.Success)
      return Colors.green.shade400;
    else
      return Colors.orange.shade400;
  }

  MyMessage({this.type, this.msg, this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return msg == ""
        ? Container()
        : Container(
            width: double.infinity,
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
              textAlign: this.textAlign,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 5.0, color: _borderColor),
              ),
              color: _boxColor,
            ),
          );
  }
}
