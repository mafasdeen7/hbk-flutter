import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/LocalStorage.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/WebClient.dart';

class UserProvider with ChangeNotifier {
  static const url_login = "wp-json/jwt-auth/v1/token";
  static const url_refresh_token = "wp-json/jwt-auth/v1/token/refresh";
  static const url_signup = "wp-json/wp/v2/m/user";
  static const url_password_resetting_token = "wp-json/wp/v2/m/password/forgot";
  static const url_password_resetting = "wp-json/wp/v2/m/password/reset";
  static const url_change_password = "wp-json/wp/v2/m/reset-password";

  User _user;
  bool _isLoggedIn = false;
  String _token;
  DateTime _tokenExpiryDate;
  DateTime _tokenGeneratedTime;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String firebaseToken="";

  Future<String> getFirebaseToken() async{
      _firebaseMessaging.subscribeToTopic('all');
      _firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        firebaseToken = token;
        print('firebase token:'+token);
      });
    return firebaseToken;
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  User get loggedInUser {
    return _user;
  }

  updateloggedInUser(String contact, String address) async {
    _user.contactNo = contact;
    _user.address = address;
    await LocalStorage.setUserInfo(_user);
  }

  String get token {
    return _token;
  }

  Future<bool> loginUser(String username, String password) async {
    String fbToken = await getFirebaseToken();
    var data = {
      'username': username,
      'password': password,
      'firebase_token':fbToken,
    };

    final res = await WebClient().post(url_login, data);
    if (res['error'] == 1) {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    } else {
      afterLoginSuccess(res['data']);
      return true;
    }
  }

  void afterLoginSuccess(dynamic data) async {
    _isLoggedIn = true;
    //
    _token = data['token'];
    _tokenGeneratedTime = DateTime.now();
    _tokenExpiryDate =
        new DateTime.fromMillisecondsSinceEpoch(data['expire_at'] * 1000);
    //
    var userDetail = data['user_details'];
    _user = User(
      customerId: userDetail['customer_id'].toString(),
      email: userDetail['email'],
      userName: userDetail['user_name'],
      nicName: userDetail['nick_name'],
      displayName: userDetail['display_name'],
      contactNo: userDetail['contact_number'],
      address: userDetail['address'],
      firstName: userDetail['first_name'],
      lastName: userDetail['last_name'],
    );
    //
    await LocalStorage.setUserInfo(_user);
    await LocalStorage.setValue(LocalStorage.token, _token);
    await LocalStorage.setValue(
        LocalStorage.tokenGeneratedTime, _tokenGeneratedTime.toIso8601String());
    await LocalStorage.setValue(
        LocalStorage.tokenExpiry, _tokenExpiryDate.toIso8601String());
    //
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    print('auto login');
    final expiryDate = await LocalStorage.getValue(LocalStorage.tokenExpiry);
    if (expiryDate == null) return false;
    //
    if (DateTime.parse(expiryDate).isBefore(DateTime.now())) {
      logout();
      return false;
    }
    //
    _isLoggedIn = true;
    _token = await LocalStorage.getValue(LocalStorage.token);
    _tokenGeneratedTime = DateTime.parse(
        await LocalStorage.getValue(LocalStorage.tokenGeneratedTime));
    //
    _user = await LocalStorage.getUserInfo();
    //
    notifyListeners();
    checkToken();
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = null;
    _token = null;
    _tokenExpiryDate = null;
    await LocalStorage.clearData();
    //
    notifyListeners();
  }

  Future<void> checkToken() async {
    var diffInDays = DateTime.now().difference(_tokenGeneratedTime).inDays;
    if (diffInDays >= 5) {
      _refreshToken();
    }
  }

  Future<void> _refreshToken() async {
    var data = {
      'email': loggedInUser.email,
      'token': _token,
    };
    //
    final res = await WebClient().post(url_refresh_token, data);
    //
    if (res['error'] == 0) {
      var data = res['data'];
      //
      _token = data['token'];
      _tokenGeneratedTime = DateTime.now();
      _tokenExpiryDate =
          new DateTime.fromMillisecondsSinceEpoch(data['expire_at'] * 1000);
      //
      await LocalStorage.setValue(LocalStorage.token, _token);
      await LocalStorage.setValue(LocalStorage.tokenGeneratedTime,
          _tokenGeneratedTime.toIso8601String());
      await LocalStorage.setValue(
          LocalStorage.tokenExpiry, _tokenExpiryDate.toIso8601String());
      //
      notifyListeners();
    }
  }

  Future<dynamic> signup(
    String username,
    String firstName,
    String lastName,
    String email,
    String password,
    String contactNo,
    String address,
  ) async {
    String fbToken = await getFirebaseToken();
    var data = {
      "user_name": username,
      "first_name": firstName,
      "last_name": lastName,
      "user_email": email,
      "password": password,
      "contact_number": contactNo,
      "address": address,
      "firebase_token": fbToken,
    };
    //
    String msg;
    bool success;
    //
    final res = await WebClient().post(url_signup, data);
    if (res['error'] == 1) {
      msg = Utill.showErrorToast(res['msg'][0]);
      success = false;
    } else {
      msg = res['msg'];
      success = true;
    }

    return {'msg': msg, 'success': success};
  }

  Future<bool> sendPasswordResettingToken(String email) async {
    var data = {
      "email": email,
    };
    //
    final res = await WebClient().post(url_password_resetting_token, data);
    if (res['error'] == 1) {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    } else {
      return true;
    }
  }

  Future<bool> resettingPassword(
      String email, String resettingToken, String newPassword) async {
    var data = {
      "email": email,
      "token": resettingToken,
      "new_password": newPassword,
    };
    //
    final res = await WebClient().post(url_password_resetting, data);
    print(res);
    if (res['error'] == 1) {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    } else {
      Utill.showSuccessToast('Password has been changed');
      return true;
    }
  }

  Future<bool> changePassword(
      String oldPass, String newPass, String token) async {
    print('Change Password');
    print(oldPass);
    var data = {
      'new_password': newPass,
      'old_password': oldPass,
      'token': token,
    };

    final res = await WebClient().post(url_change_password, data);
    if (res['error'] == 0) {
      Utill.showSuccessToast(res['msg'][0]);
      return true;
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    }
  }
}
