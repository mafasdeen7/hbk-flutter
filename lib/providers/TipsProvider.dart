import 'package:flutter/widgets.dart';
import 'package:hbk/models/Tip.dart';
import 'package:hbk/providers/WebClient.dart';

class TipsProvider with ChangeNotifier {
  static const url_get_all = "wp-json/wp/v2/m/guides-tips";

  List<Tip> _tipsList = [];

  List<Tip> get tipsList {
    return [..._tipsList];
  }

  Future<List<Tip>> getAllTips() async {
    final res = await WebClient().get(url_get_all);
    final resData = res['data'];
    _tipsList.clear();
    resData.forEach((d) {
      _tipsList.add(Tip(
        id: int.parse(d['id']),
        title: d['post_title'],
      ));
    });
    return _tipsList;
  }

  Future<Tip> getDetail(int id) async {
    final res = await WebClient().get(url_get_all + "/" + id.toString());
    //
    return Tip(
      id: id,
      content: res['data'][0]['post_content'],
    );
  }
}
