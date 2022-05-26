import 'package:flutter/widgets.dart';
import 'package:hbk/models/FAQ.dart';
import 'package:hbk/providers/WebClient.dart';

class FAQProvider with ChangeNotifier {
  static const url_get_all = "wp-json/wp/v2/m/faqs";

  List<FAQ> _faqList = [];

  List<FAQ> get faqList {
    return [..._faqList];
  }

  Future<List<FAQ>> getAllFAQ() async {
    final res = await WebClient().get(url_get_all);
    final resData = res['data'];
    _faqList.clear();
    resData.forEach((d) {
      _faqList.add(FAQ(
        id: int.parse(d['id']),
        title: d['post_title'],
        url: d['guid'],
      ));
    });
    return _faqList;
  }

  Future<FAQ> getDetail(int id) async {
    final res = await WebClient().get(url_get_all + "/" + id.toString());
    //
    return FAQ(
      id: id,
      content: res['data'][0]['post_content'],
    );
  }
}
