import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';

class CounterLimitFirestore extends ChangeNotifier {
  int _productsLimit = 10;
  int _scrollProductLimit = 10;
  int _clientsLimit = 10;
  int _scrollClientLimit = 10;
  Timestamp _selectedDayVisits = Timestamp.fromDate(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
    0,
    0,
  ));
  Timestamp _selectedDayOrder = Timestamp.fromDate(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
    0,
    0,
  ));
  Timestamp? _selectedDayInvoice = Timestamp.fromDate(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
    0,
    0,
  ));

  int get getProductsLimit => _productsLimit;
  int get getScrollProductLimit => _scrollProductLimit;
  int get getClientsLimit => _clientsLimit;
  int get getScrollClientLimit => _scrollClientLimit;
  Timestamp get currentDayVisits => _selectedDayVisits;
  Timestamp get currentDayOrder => _selectedDayOrder;
  Timestamp? get currentDayInvoice => _selectedDayInvoice;

  void setClientsLimit(int? newLimit, int? newScrollLimit) {
    if (newLimit != null) {
      try {
        _clientsLimit = newLimit;
        if (newScrollLimit != null && newScrollLimit != 0) {
          _scrollClientLimit = newScrollLimit;
        } else if (newScrollLimit != null && newScrollLimit == 0) {
          _scrollClientLimit = 0;
        }
        notifyListeners();
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Error al cambiar la cantidad de clientes a mostrar');
        print(e);
      }
    } else if (newLimit == null) {
      _clientsLimit = 10;
      _scrollClientLimit = 10;
      notifyListeners();
    }
  }

  void setNewDayInvoice(Timestamp? newDay) {
    if (newDay != null) {
      _selectedDayInvoice = newDay;
      notifyListeners();
    } else {
      _selectedDayInvoice = null;
      // Timestamp.fromDate(DateTime(
      //   DateTime.now().year + 99,
      //   DateTime.now().month + 99,
      //   DateTime.now().day + 99,
      //   0,
      //   0,
      //   0,
      //   0,
      //   0,
      // ));
      notifyListeners();
    }
  }

  void setNewDayOrder(Timestamp? newDay) {
    if (newDay != null) {
      _selectedDayOrder = newDay;
      notifyListeners();
    } else {
      _selectedDayOrder = Timestamp.now();
      notifyListeners();
    }
  }

  void setNewDayVisits(Timestamp? newDay) {
    if (newDay != null) {
      _selectedDayVisits = newDay;
      notifyListeners();
    } else {
      _selectedDayVisits = Timestamp.now();
      notifyListeners();
    }
  }

  void setProductsLimit(int? newLimit, int? newScrollLimit) {
    if (newLimit != null) {
      try {
        _productsLimit = newLimit;
        if (newScrollLimit != null && newScrollLimit != 0) {
          _scrollProductLimit = newScrollLimit;
        } else if (newScrollLimit != null && newScrollLimit == 0) {
          _scrollProductLimit = 0;
        }
        notifyListeners();
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Error al cambiar la cantidad de productos a mostrar');
        print(e);
      }
    } else if (newLimit == null) {
      _productsLimit = 10;
      _scrollProductLimit = 10;
      notifyListeners();
    }
  }
}
