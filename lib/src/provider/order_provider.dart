import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';

class OrderProvider extends ChangeNotifier {
  bool? _orderActive = false;
  Clients? _clientForTheOrder = Clients(
    name: 'no-name',
    prices: 'GENER-03',
  );

  int _navigationIndex = 0;
  int _diaryIndex = 0;

  bool? get orderActive => _orderActive;

  Clients? get clientForTheOrder => _clientForTheOrder;

  int? get navigationIndex => _navigationIndex;
  int? get diaryIndex => _diaryIndex;

  void setNavigationIndex(int? newIndex) {
    if (newIndex != null) {
      _navigationIndex = newIndex;
      notifyListeners();
    }
    return;
  }

  void setDiaryIndex(int? newDiaryIndex) {
    if (newDiaryIndex != null) {
      _diaryIndex = newDiaryIndex;
      notifyListeners();
    }
    return;
  }

  void setOrder(bool? orderActive, Clients? client) {
    if (orderActive == true) {
      _orderActive = orderActive;
      _clientForTheOrder = client;
      notifyListeners();

      // print('Orden activa: $_orderActive');
      // print('Cliente actual: ${client?.name}');
      // print('Lista de precios activa: ${client?.prices}');
      return;
    } else if (orderActive == false) {
      _orderActive = orderActive;
      _clientForTheOrder = Clients(name: 'no-name', prices: 'GENER-03');
      notifyListeners();

      // print('Orden activa: $_orderActive');
      // print('Cliente actual: ${client?.name}');
      // print('Lista de precios activa: ${client?.prices}');
      return;
    }
  }
}
