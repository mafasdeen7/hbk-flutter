import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/providers/WebClient.dart';

class UpdateContactsProvider with ChangeNotifier {
  static const url_sendMail = "wp-json/wp/v2/m/cupdate";

  Future<bool> sendData(String contact, String address, String token) async {
    var data = {
      'contact_number': contact,
      'address': address,
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
