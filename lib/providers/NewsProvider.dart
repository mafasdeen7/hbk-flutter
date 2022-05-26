import 'package:flutter/widgets.dart';
import 'package:hbk/models/News.dart';
import 'package:hbk/providers/WebClient.dart';

class NewsProvider with ChangeNotifier {
  static const url_get_all = "wp-json/wp/v2/m/news";

  List<News> _newsList = [];

  List<News> get newsList {
    return [..._newsList];
  }

  Future<List<News>> getAllNews() async {
    final res = await WebClient().get(url_get_all);
    final resData = res['data'];
    _newsList.clear();
    resData.forEach((d) {
      _newsList.add(News(
        id: int.parse(d['id']),
        title: d['post_title'],
        content60: d['post_content'],
      ));
    });
    return _newsList;
  }

  Future<News> getDetail(int id) async {
    final res = await WebClient().get(url_get_all + "/" + id.toString());
    //
    return News(
      id: id,
      content: res['data'][0]['post_content'],
    );
  }
}
