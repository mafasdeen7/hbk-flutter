import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/providers/WebClient.dart';

class SendEmailProvider with ChangeNotifier {
  static const url_sendMail = "wp-json/wp/v2/m/ship-package";

  Future<bool> sendMail(String country, String email, String token) async {
    print('Dx : I');
    print(email);
    var data = {
      'country': country,
      'email': email,
      'token': token,
    };

    final res = await WebClient().post(url_sendMail, data);
    if (res['error'] == 0) {
      Utill.showSuccessToast(res['msg'][0]);
      return true;
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    }
  }
}
