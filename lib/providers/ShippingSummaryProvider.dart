import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/models/ShippingSummary.dart';
import 'package:hbk/providers/WebClient.dart';

class ShippingSummaryProvider with ChangeNotifier {
  static const url = "wp-json/wp/v2/m/shipping-summary";

  Future<ShippingSummary> getData(String container, String token) async {
    print('Dx : shipping summery provider');
    print(container);
    var data = {
      'container_no': container,
      'token': token,
    };

    final res = await WebClient().post(url, data);
    if (res['error'] == 0) {
      Utill.showSuccessToast(res['msg'][0]);
      return ShippingSummary(
        status: res['msg'][0],
        // status: res['data']['status'],
      );
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return ShippingSummary(
        status: '',
      );
    }
  }
}
