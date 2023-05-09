import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CurrencyProvider extends ChangeNotifier {
  // String? _currentCurrency = 'Dolares - USD';
  String? _currentCurrency = 'Pesos Mexicanos - MXN';
  bool? _isUserAdmin = false;

  String? get currentCurrency => _currentCurrency;
  bool? get isUserAdmin => _isUserAdmin;

  // void setIfUserIsAdmin(String? roleID) {
  //   if (roleID == null) {
  //     _isUserAdmin = false;
  //     notifyListeners();
  //   } else {
  //     if(roleID == 'userRole')
  //   }
  // }

  void setCurrentCoin(String? coin) {
    if (coin == null) {
      _currentCurrency = 'Dolares - USD';
      notifyListeners();
      Fluttertoast.showToast(msg: 'Nulo - Moneda cambiada a $_currentCurrency');
    } else {
      _currentCurrency = coin;
      notifyListeners();
      Fluttertoast.showToast(msg: 'Moneda cambiada a $coin');
    }
  }
}
