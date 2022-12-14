import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CurrencyProvider extends ChangeNotifier {
  String? _currentCurrency = 'Dolares - USD';

  String? get currentCurrency => _currentCurrency;

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

    //    if (selectedValue == null) {
    //                                   sharedPreferences!.setString(
    //                                       'currentCoin', 'Dolares - USD');
    //                                   Navigator.pop(context);
    //                                   Fluttertoast.showToast(
    //                                       msg: 'Moneda reestablecida a dolares');
    //                                 } else {
    //                                   sharedPreferences!.setString('currentCoin',
    //                                       selectedValue.toString());
    //                                   Navigator.pop(context);
    //                                   Fluttertoast.showToast(
    //                                       msg:
    //                                           'Moneda cambiada a $selectedValue');
    //                                 }
    // }
  }
}
