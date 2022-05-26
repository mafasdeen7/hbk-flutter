import 'package:flutter/widgets.dart';
import 'package:hbk/models/PesoValue.dart';
import 'package:hbk/providers/WebClient.dart';

class PesoValueProvider with ChangeNotifier {
  static const url_get_all = "wp-json/wp/v2/m/peso-value";

  Future<PesoValue> getPesoValue() async {
    final res = await WebClient().get(url_get_all);
    print('peso');
    print(res['data']['multiply']);
    print(res['data']['addition']);
    return PesoValue(
      multiply: res['data']['multiply'],
      addition: res['data']['addition'],
    );
  }
}
