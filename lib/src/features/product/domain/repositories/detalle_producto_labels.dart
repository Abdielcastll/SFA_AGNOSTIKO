import 'package:flutter/material.dart';

class DetalleLabels extends ChangeNotifier {
  static final DetalleLabels _instance = DetalleLabels._internal();

  factory DetalleLabels() {
    return _instance;
  }

  DetalleLabels._internal();

  String _diseno = '';
  String _linea = '';
  String _tamano = '';

  String get diseno => _diseno;
  String get linea => _linea;
  String get tamano => _tamano;

  void setValues(
      {required String diseno, required String linea, required String tamano}) {
    _diseno = diseno;
    _linea = linea;
    _tamano = tamano;
    notifyListeners(); // Notify UI or listeners
  }
}
