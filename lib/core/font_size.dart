import 'package:flutter/material.dart';

enum DeviceName {
  n910,
  k10,
  k20,
}

class FontSize {
  static bool _initialized = false;
  static late DeviceName _deviceName;
  static late double _fontXS;
  static late double _fontS;
  static late double _fontM;
  static late double _fontL;
  static late double _fontXL;
  static late double _font2XL;
  static late double _font3XL;  
  
  static final FontSize _instance = FontSize._();
  FontSize._();

  // Getters
  static FontSize get instance => _instance;
  static double get fontXS  => _ensureInitialized(_fontXS);
  static double get fontS   => _ensureInitialized(_fontS);
  static double get fontM   => _ensureInitialized(_fontM);
  static double get fontL   => _ensureInitialized(_fontL);
  static double get fontXL  => _ensureInitialized(_fontXL);
  static double get font2XL => _ensureInitialized(_font2XL);
  static double get font3XL => _ensureInitialized(_font3XL);

  static void initialize(BuildContext context) {
    if (_initialized) return;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final dpi = MediaQuery.of(context).devicePixelRatio;
    final physicalWidth = screenWidth * dpi;

    if (physicalWidth <= 720) _deviceName = DeviceName.n910;
    if (physicalWidth > 720 && physicalWidth < 1080) _deviceName = DeviceName.k10;
    if (physicalWidth >= 1080) _deviceName = DeviceName.k20;

    _setFontSize(_deviceName, screenWidth);
    _initialized = true;
  }

  static void _setFontSize(DeviceName device, double width) {
    late final double multiplier;

    if (device == DeviceName.n910) multiplier = 0.030;
    if (device == DeviceName.k10) multiplier = 0.0200;
    if (device == DeviceName.k20) multiplier = 0.0200;

    _fontXS = width * 0.9 * multiplier;
    _fontS = width * 1.0 * multiplier;
    _fontM = width * 1.2 * multiplier;
    _fontL = width * 1.4 * multiplier;
    _fontXL = width * 1.6 * multiplier;
    _font2XL = width * 1.8 * multiplier;
    _font3XL = width * 2.0 * multiplier;
  }

  static double _ensureInitialized(double value) {
    assert(_initialized, 'FontSize.initialize() must be called before access any font sizes');
    return value;
  }
}
