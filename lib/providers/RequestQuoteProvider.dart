import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/models/PriceQuote.dart';
import 'package:hbk/providers/WebClient.dart';

class RequestQuoteProvider with ChangeNotifier {
  static const url_sendData = "wp-json/wp/v2/m/request-quote";
  static const url_get_all = "wp-json/wp/v2/m/my-request-quotes";
  static const url_deleteData = "wp-json/wp/v2/m/delete-request-quote";
  static const url_getCount ="wp-json/wp/v2/m/get-unread-quotes-counts";

  Future<bool> sendData(
      String name,
      String email,
      String country,
      String boxWeight,
      String weightType,
      String boxQty,
      String itemDescription,
      String lenght,
      String width,
      String height,
      String dimension,
      String contactNumber,
      String message,
      String token) async {
    print('Dx : Request Quote Provider');
    print(email);
    print(name);
    var data = {
      'name': name,
      'email': email,
      'country_of_origin': country,
      'box_weight': boxWeight,
      'weight_type': weightType,
      'box_qty': boxQty,
      'item_description': itemDescription,
      'length': lenght,
      'width': width,
      'height': height,
      'dimension': dimension,
      'contact_number': contactNumber,
      'message': message,
      'token': token
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

  List<PriceQuote> _quoteList = [];

  List<PriceQuote> get quoteList {
    return [..._quoteList.reversed.toList()];
  }

  Future<List<PriceQuote>> getAllQuote(String token) async {
    var data = {
      'token': token,
    };

    final res = await WebClient().post(url_get_all, data);
    final resData = res['data'];
    _quoteList.clear();
    resData.forEach((d) {
      _quoteList.add(PriceQuote(
        id: d['id'],
        name: d['name'],
        country_of_origin: d['country_of_origin'],
        box_weight: d['box_weight'],
        item_description: d['item_description'],
        length: d['length'],
        width: d['width'],
        height: d['height'],
        dimension: d['dimension'],
        weight_type: d['weight_type'],
        box_qty: d['box_qty'],
        contact_number: d['contact_number'],
        message: d['message'],
        paymentStatus: d['payment_status'],
        is_user_read: d['is_user_read'],
      ));
    });
    return _quoteList;
  }

  Future<PriceQuote> getDetail(int id, String token) async {
    var data = {
      'token': token,
    };
    final res = await WebClient().post(url_get_all + "/" + id.toString(),data);
    //
    // return PriceQuote(
    //   id: id,
    //   content: res['data'][0]['post_content'],
    // );
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
      _quoteList.removeWhere((item) => item.id == int.parse(id));
      notifyListeners();
      return true;
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    }
  }
  
  markedAsRead(int id) async {
    final tile = _quoteList.firstWhere((item) => item.id == id, orElse: null);
    if (tile != null)  tile.is_user_read = '1';
    notifyListeners();
  }

  int count = 0;
  Future<int> getUnreadQuateCount(String token) async {
    try {
      var data = {
      'token': token
    };
    final res = await WebClient().post(url_getCount,data);
    final resData = res['data'];
    count = resData['un-read-quotes'];
    print(resData); 
    }  
    catch(e) { 
        print(e); 
    } 
    return count;
  }

  int get unreadQuateCount{
    return count;
  }

}
