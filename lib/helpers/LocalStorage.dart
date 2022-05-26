import 'package:flutter/cupertino.dart';
import 'package:hbk/models/PushNotification.dart';
import 'package:hbk/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static String userDetail = 'user_detail';
  static String token = 'token';
  static String tokenExpiry = 'token_expiry';
  static String tokenGeneratedTime = 'token_gen_time';
  static String notiDetail = 'noti_detail';

  static setValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    print('set local storage : ' + key + " : " + value);
  }

  static getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(key)) {
      return null;
    }
    return prefs.getString(key);
  }

  static setUserInfo(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'id': user.customerId,
      'email': user.email,
      'user_name': user.userName,
      'nick_name': user.nicName,
      'display_name': user.displayName,
      'contact_number': user.contactNo,
      'address': user.address,
      'firstName': user.firstName,
      'lastName': user.lastName,
    });
    prefs.setString(userDetail, userData);
  }

  static getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(userDetail)) {
      return null;
    }
    dynamic userData =
        json.decode(prefs.getString(userDetail)) as Map<String, Object>;
    //
    return User(
      customerId: userData['id'],
      email: userData['email'],
      userName: userData['user_name'],
      nicName: userData['nick_name'],
      displayName: userData['display_name'],
      contactNo: userData['contact_number'],
      address: userData['address'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
    );
  }

  static clearData() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
