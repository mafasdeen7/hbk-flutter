import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  final Color color;

  MyProgressIndicator({this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(this.color),
      ),
      height: 20.0,
      width: 20.0,
    );
  }
}
