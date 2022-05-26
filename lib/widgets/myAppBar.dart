import 'package:flutter/material.dart';
//
import '../helpers/GlobalConstants.dart';
//
AppBar myAppBar() {
  return AppBar(
    centerTitle: true,
    title: Text(
      GlobalConstants.appTitle,
      style: TextStyle(color: Colors.grey.shade800),
    ),
    backgroundColor: Colors.grey.shade200,
    iconTheme: new IconThemeData(color: Colors.grey.shade800),
  );
}
