import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:hbk/helpers/Utill.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class WebClient {
  static const baseUrl = "https://staging.hbkglobaltrading.com/";

  Future<dynamic> post(String url, dynamic data,
      {bool skipToken = false}) async {
    print('XXXX posting... XXXX ' + url);
    final connected = await isConnected();
    if (!connected) {
      Utill.showErrorToast('No Internet Connection');
      return;
    }

    // final token = await getToken();
    // print('token:' + token);
    try {
      final http.Response response = await http.Client().post(
        baseUrl + url,
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 400) {
        return {'error': 1, 'msg': json.decode(response.body)['error']};
      }

      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      print('xxxxxxx');
      print(exception.toString());
      print('yyyyyyyy');
      return {'error': 1, 'msg': 'Server error. Please try again'};
    }
  }

  Future<dynamic> get(String url) async {
    print('XXXX getting... XXXX ' + url);
    final connected = await isConnected();
    if (!connected) {
      Utill.showErrorToast('No internet connection');
      return;
    }

    try {
      final http.Response response = await http.Client().get(
        baseUrl + url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 400) {
        return {'error': 1, 'msg': json.decode(response.body)['error']};
      }

      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } catch (exception) {
      print('xxxxxxx');
      print(exception.toString());
      print('yyyyyyyy');
      return {'error': 1, 'msg': 'Server error. Please try again'};
    }
  }

  Future<String> getToken() async {
    // var recs = await DBHelper.getAll("user");
    // var token = recs[0]['token'];
    // return token == null ? "" : token;
    return "tokenxxx";
  }

  // check if we have internet connection
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)
      return false;
    else
      return true;
  }
}
