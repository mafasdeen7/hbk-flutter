import 'package:flutter/widgets.dart';
import 'package:hbk/models/PushNotification.dart';
import 'package:hbk/providers/WebClient.dart';

class NotificationProvider with ChangeNotifier {
  static const url_get_all = "wp-json/wp/v2/m/get-public-message";
  // static const url_deleteData = "wp-json/wp/v2/m/delete-public-messages";
  static const url_getCount = "wp-json/wp/v2/m/get-public-message-counts";

  List<PushNotification> _notificationList = [];

  List<PushNotification> get notificationList {
    return [..._notificationList];
  }

  Future<List<PushNotification>> getAllPublicMessages() async {
    _notificationList.clear();

    final res = await WebClient().get(url_get_all);
    final resData = res['data'];
    print(resData);
    resData.forEach((d) {
      _notificationList.add(PushNotification(
        id: d['id'],
        notiTitle: d['notiTitle'],
        notiBody: d['notiBody'],
        dataBody: d['dataBody'],
        dataScreen: d['dataScreen'],
        time: d['time'],
        is_user_read: d['is_user_read'],
      ));
    });
    return _notificationList;
  }

  Future<PushNotification> getDetail(String id) async {
    final res = await WebClient().get(url_get_all + "/" + id.toString());
    //
    return PushNotification(
      id: id,
      notiTitle: res['data'][0]['notiTitle'] ,
      notiBody: res['data'][0]['notiBody'],
      dataBody: res['data'][0]['dataBody'],
      dataScreen: res['data'][0]['dataScreen'],
      time:res['data'][0]['time'],
    );
  }

  // Future<bool> saveNoti(Map<String, dynamic> message) async {
  //   _noti = PushNotification(
  //     id: message["data"]["id"].toString(),
  //     notiTitle: message["notification"]["title"],
  //     notiBody: message["notification"]["body"],
  //     dataBody: message["data"]["body"],
  //     dataScreen: message["data"]["screen"],
  //     time: DateTime.now().toString(),
  //   );
    
  //     _notificationList.add(
  //       PushNotification(
  //         message["data"]["id"].toString(),
  //         message["notification"]["title"],
  //         message["notification"]["body"],
  //         message["data"]["body"],
  //         message["data"]["screen"],
  //         time: DateTime.now().toString(),
  //       )
  //     );

  //   await LocalStorage.setNotiInfo(_noti);
  //   //
  //   notifyListeners();
  //   return true;
  // }

}
