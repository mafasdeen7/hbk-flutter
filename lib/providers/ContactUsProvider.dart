import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/providers/WebClient.dart';

class ContactUsProvider with ChangeNotifier {
  static const url_sendData = "wp-json/wp/v2/m/contactus";

  Future<bool> sendData(String token, String name, String email, String phone, String subject, String message, String attachment) async {
    print('Dx : I');
    print(email);
    print(token);
    var data = {
      'token':token,
      'name': name,
      'email': email,
      'phone_number': phone,
      'subject': subject,
      'message': message,
      'attachment_url': attachment,
    };

    final res = await WebClient().post(url_sendData, data);
    print(res['msg'][0]);
    if (res['error'] == 0) {
      Utill.showSuccessToast(res['msg'][0]);
      return true;
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    }
  }

}