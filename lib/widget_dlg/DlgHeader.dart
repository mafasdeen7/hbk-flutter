import 'package:flutter/material.dart';

class DlgHeader extends StatelessWidget {
  final String header;

  DlgHeader(this.header);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        header,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
    );
  }
}
