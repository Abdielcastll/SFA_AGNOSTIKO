import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';

class OrderProvider extends ChangeNotifier {
  bool? _orderActive = false;
  Clients? _clientForTheOrder = Clients(
    name: 'no-name',
    prices: 'GENER-03',
  );

  bool? get orderActive => _orderActive;

  Clients? get clientForTheOrder => _clientForTheOrder;

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
