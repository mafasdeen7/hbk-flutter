import 'package:flutter/widgets.dart';
import 'package:hbk/helpers/Utill.dart';
import 'package:hbk/models/PaySupplier.dart';
import 'package:hbk/providers/WebClient.dart';

class PaySupplierProvider with ChangeNotifier {
  static const url_sendData = "wp-json/wp/v2/m/supplier-payment";
  static const url_get_all = "wp-json/wp/v2/m/get-supplier-payment";
  static const url_deleteData = "wp-json/wp/v2/m/delete-supplier-payment";

  Future<bool> sendData(
      String token,
      String amount,
      String beneficiaryName,
      String beneficiaryAddress,
      String bankName,
      String bankAddress,
      String accountNumber,
      String swiftCode,
      String country,
      String name,
      String email,
      String fileName,
      String depositSlip) async {
    print('Dx : Supplier Pay');
    print(email);
    print(name);
    var data = {
      'token': token,
      'amount': amount,
      'beneficiary_name': beneficiaryName,
      'beneficiary_address': beneficiaryAddress,
      'bank_name': bankName,
      'bank_address': bankAddress,
      'account_number': accountNumber,
      'swift_code': swiftCode,
      'country': country,
      'name': name,
      'email': email,
      'deposit_slip_name': fileName,
      'deposit_slip': depositSlip
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

  List<PaySupplier> _paySupplierList = [];

  List<PaySupplier> get paySupplierList {
    return [..._paySupplierList.reversed.toList()];
  }

  Future<List<PaySupplier>> getAllData(String token) async {
    var data = {
      'token': token,
    };

    final res = await WebClient().post(url_get_all, data);
    final resData = res['data'];
    _paySupplierList.clear();
    resData.forEach((d) {
      _paySupplierList.add(PaySupplier(
        id: d['id'],
        amount: d['amount'],
        beneficiary_name: d['beneficiary_name'],
        beneficiary_address: d['beneficiary_address'],
        bank_name: d['bank_name'],
        bank_address: d['bank_address'],
        account_number: d['account_number'],
        swift_code: d['swift_code'],
        country: d['country'],
        name: d['name'],
        email: d['email'],
        deposit_slip: d['deposit_slip'],
        paymentStatus: d['payment_status'],
      ));
    });
    return _paySupplierList;
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
       _paySupplierList.removeWhere((item) => item.id == int.parse(id));
      notifyListeners();
      return true;
    } else {
      Utill.showErrorToast(res['msg'][0]);
      return false;
    }
  }

  Future<bool> isPaymentDetailSent(bool isSent){
    isPaymentDetailSentBool = isSent;
  }
  
  bool isPaymentDetailSentBool = false;
  bool get getIsPaymentDetailSent{
    return isPaymentDetailSentBool;
  }

}
