import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utill {

  static isNullOrEmpty(String s) {
    if (s == null || s.trim() == "")
      return true;
    else
      return false;
  }

  static showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
    );
  }

  static showSuccessToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
    );
  }

  static showInfoToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
    );
  }
}
