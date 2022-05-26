import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String txt;
  final Function clicked;
  final bool loading;
  final String loadingText;

  MyButton({this.txt, this.clicked, this.loading = false, this.loadingText});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        loading ? loadingText : txt,
      ),
      onPressed: loading ? null : clicked,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context).primaryTextTheme.button.color,
      disabledTextColor: Colors.white,
      disabledColor: Colors.black54,
      disabledElevation: 1,
    );
  }
}
