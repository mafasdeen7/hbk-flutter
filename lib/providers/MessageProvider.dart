import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/models/Message.dart';
import 'package:hbk/models/MessageDetails.dart';
import 'package:hbk/providers/WebClient.dart';

class MessageProvider with ChangeNotifier {
  static const url_get_all = "wp-json/wp/v2/m/get-messages";
  static const url_send_message = "wp-json/wp/v2/m/send-messages";
  static const url_deleteData = "wp-json/wp/v2/m/delete-messages";
  static const url_getCount = "wp-json/wp/v2/m/get-messages-counts";

  List<Message> _messageList = [];

  List<Message> get messageList {
    return [..._messageList.reversed.toList()];
  }

  Future<List<Message>> getAllMessages(String token) async {
    _messageList.clear();
    var data = {
      'token': token
    };
    final res = await WebClient().post(url_get_all, data);
    final resData = res['data'];
    print(resData);
    resData.forEach((d) {
      _messageList.add(Message(
        id: d['id'],
        name: d['name'],
        isRead: d['is_read'],
        email: d['email'],
        phoneNumber: d['phone_number'],
        subject: d['subject'],
        message: d['message'],
        attachementLink: d['attachementLink'],
        is_user_read: d['is_user_read'],
      ));
    });
    return _messageList;
  }


  List<MessageDetails> _messageDetailsList = [];

  List<MessageDetails> get messageDetailsList {
    return [..._messageDetailsList];
  }
  Future<List<MessageDetails>> getMessageDetail(int id, String token) async {
    _messageDetailsList.clear();
    var data = {
      'token': token
    };
    final res = await WebClient().post(url_get_all + "/" + id.toString(),data);
    final resData = res['data'];
    print(resData);
    resData.forEach((d) {
      _messageDetailsList.add(MessageDetails(
        id: d['id'],
        entryId: d['entry_id'],
        username: d['user_name'],
        userId: d['user_id'],
        dateCreated: d['date_created'],
        value: d['value'],
        noteType: d['note_type'],
        createdBy: d['created_by'],
      ));
    });
    return _messageDetailsList;
  }

  Future<bool> sendMessage(String token, String message_id, String message) async {
    print('send message');
    print(message_id + message);
    var data = {
      'token': token,
      'message_id': message_id,
      'message': message,
    };

    final res = await WebClient().post(url_send_message, data);
    if (res['error'] == 0) {
      Utill.showSuccessToast(res['msg'][0]);
      return true;
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    }
  }

  Future<bool> deleteData(
    String id,
    String token,
  ) async {
    var data = {
      'id': id,
      'token': token,
    };

    final res = await WebClient().post(url_deleteData, data);
    print(res['msg'][0]);
    if (res['error'] == 0) {
      Utill.showSuccessToast(res['msg'][0]);
      _messageList.removeWhere((item) => item.id == int.parse(id));
      notifyListeners();
      return true;
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    }
  }

  markedAsRead(int id) async {
    final tile = _messageList.firstWhere((item) => item.id == id, orElse: null);
    if (tile != null)  tile.is_user_read = '1';
    notifyListeners();
  }

  int count = 0;
  Future<int> getUnReadMessageCount(String token) async {
    try {  
      var data = {
      'token': token
    };
    final res = await WebClient().post(url_getCount,data);
    final resData = res['data'];
    count = resData['un-read-messages'];
    print(resData); 
    }  
    catch(e) { 
        print(e); 
    } 
    return count;
  }

  int get messageCount{
    return count;
  }

}
