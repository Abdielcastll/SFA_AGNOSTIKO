import 'package:flutter/material.dart';

ThemeData myThemeBase = ThemeData.light().copyWith(
  //useMaterial3: false,
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
);

class ThemeProvider with ChangeNotifier {
  ThemeData _myTheme = ThemeData.light().copyWith(
    //useMaterial3: false,
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
  );

  ThemeData get myTheme => _myTheme;

  // Update theme colors after fetching from Firestore
  void setColors({
    required Color primary,
    required Color secondary,
    required Color onBackground,
    required Color onPrimaryContainer,
    required Color onTertiaryContainer,
  }) {
    print('setColors');
    print(primary);
    print(secondary);
    _myTheme = ThemeData.light().copyWith(
      //useMaterial3: false,
      colorScheme: ColorScheme.light(
        // Colores primarios
        primary: primary,
        secondary: secondary,
        tertiary: const Color.fromRGBO(125, 80, 112, 1),
        // Background
        background: const Color.fromRGBO(255, 251, 255, 1),
        onBackground: onBackground,
        // Containers
        primaryContainer: const Color.fromRGBO(223, 224, 255, 1),
        tertiaryContainer: const Color.fromRGBO(255, 215, 240, 1),
        secondaryContainer: const Color.fromRGBO(223, 224, 255, 1),
        // onContainers
        onPrimaryContainer: onPrimaryContainer,
        onSecondaryContainer: const Color.fromRGBO(23, 26, 49, 1),
        onTertiaryContainer: onTertiaryContainer,
        // Errores
        error: const Color.fromRGBO(186, 26, 26, 1),
        errorContainer: const Color.fromRGBO(255, 218, 214, 1),
        onErrorContainer: const Color.fromARGB(255, 100, 40, 34),
        // Colores alternativos de fondo
        surface: const Color.fromRGBO(240, 238, 251, 1),
      ),
    );
    notifyListeners();
  }
}
