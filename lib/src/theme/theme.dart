import 'package:flutter/material.dart';

final myTheme = ThemeData.light().copyWith(
  useMaterial3: false,
  colorScheme: const ColorScheme.light(
    // Colores primarios
    // primary: Color.fromRGBO(46, 62, 174, 1),
    primary: Color.fromRGBO(67, 83, 194, 1),
    secondary: Color.fromRGBO(90, 93, 119, 1),
    // tertiary: Color.fromRGBO(255, 255, 255, 1),
    tertiary: Color.fromRGBO(125, 80, 112, 1),
    // Background
    background: Color.fromRGBO(255, 251, 255, 1),
    onBackground: Color.fromRGBO(27, 27, 31, 1),
    // Containers
    primaryContainer: Color.fromRGBO(223, 224, 255, 1),
    tertiaryContainer: Color.fromRGBO(255, 215, 240, 1),
    secondaryContainer: Color.fromRGBO(223, 224, 255, 1),
    // onContainers
    onPrimaryContainer: Color.fromARGB(255, 0, 24, 143),
    onSecondaryContainer: Color.fromRGBO(23, 26, 49, 1),
    onTertiaryContainer: Color.fromRGBO(49, 14, 42, 1),
    // Errores
    error: Color.fromRGBO(186, 26, 26, 1),
    errorContainer: Color.fromRGBO(255, 218, 214, 1),
    onErrorContainer: Color.fromARGB(255, 100, 40, 34),
    // Colores alternativos de fondo
    surface: Color.fromRGBO(240, 238, 251, 1),
  ),
  // textTheme: const TextTheme(
  //   // Displays
  //   displayLarge: TextStyle(
  //       letterSpacing: -0.25,
  //       fontSize: 57,
  //       height: 64,
  //       fontFamily: 'Poppins-regular'),
  //   displayMedium: TextStyle(
  //       letterSpacing: 0,
  //       fontSize: 45,
  //       height: 52,
  //       fontFamily: 'Poppins-regular'),
  //   displaySmall: TextStyle(
  //       letterSpacing: 0,
  //       fontSize: 36,
  //       height: 44,
  //       fontFamily: 'Poppins-regular'),
  //   // Headlines
  //   headlineLarge: TextStyle(
  //       letterSpacing: 0,
  //       fontSize: 32,
  //       height: 40,
  //       fontFamily: 'Poppins-regular'),
  //   headlineMedium: TextStyle(
  //       letterSpacing: 0,
  //       fontSize: 28,
  //       height: 36,
  //       fontFamily: 'Poppins-regular'),
  //   headlineSmall: TextStyle(
  //       letterSpacing: 0,
  //       fontSize: 24,
  //       height: 32,
  //       fontFamily: 'Poppins-regular'),
  //   // Titles
  //   titleLarge: TextStyle(
  //       letterSpacing: 0,
  //       fontSize: 22,
  //       height: 28,
  //       fontFamily: 'Poppins-regular'),
  //   titleMedium: TextStyle(
  //       letterSpacing: 0.15,
  //       fontSize: 16,
  //       fontFamily: 'Poppins-regular'),
  //   titleSmall: TextStyle(
  //       letterSpacing: 0.1,
  //       fontSize: 14,
  //       height: 20,
  //       fontFamily: 'Poppins-regular'),
  //   // Bodies
  //   bodyLarge: TextStyle(
  //       letterSpacing: 0.5,
  //       fontSize: 16,
  //       fontFamily: 'Poppins-regular'),
  //   bodyMedium: TextStyle(
  //       letterSpacing: 0.15,
  //       fontSize: 14,
  //       height: 20,
  //       fontFamily: 'Poppins-regular'),
  //   bodySmall: TextStyle(
  //       letterSpacing: 0.4,
  //       fontSize: 12,
  //       fontFamily: 'Poppins-regular'),
  //   // Labels
  //   labelLarge: TextStyle(
  //       letterSpacing: 0.1,
  //       fontSize: 14,
  //       height: 20,
  //       fontFamily: 'Poppins-regular'),
  //   labelMedium: TextStyle(
  //       letterSpacing: 0.5,
  //       fontSize: 12,
  //       height: 16,
  //       fontFamily: 'Poppins-regular'),
  //   labelSmall: TextStyle(
  //       letterSpacing: 0.6,
  //       fontSize: 11,
  //       height: 16,
  //       fontFamily: 'Poppins-regular'),
  // ),
);
