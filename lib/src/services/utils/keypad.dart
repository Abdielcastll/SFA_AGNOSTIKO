import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void Function(RawKeyEvent event) rawKeypadHandler(
  BuildContext context, {
  void Function(int digit)? onDigit,
  void Function()? onBackspace,
  void Function()? onEnter,
  void Function()? onEscape,
}) {
  return (RawKeyEvent event) {
    // Solo se procesamos los eventos si la pantalla es visible
    if (ModalRoute.of(context)?.isCurrent == false) return;

    if (event.logicalKey.keyId == LogicalKeyboardKey.backspace.keyId) {
      if (onBackspace != null) onBackspace();
    } else if (event.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {
      if (onEnter != null) onEnter();
    } else if (event.logicalKey.keyId == LogicalKeyboardKey.escape.keyId) {
      if (onEscape != null) onEscape();
    } else {
      final String? character = event.character;
      if (character != null && onDigit != null) {
        int? digit = int.tryParse(character);
        if (digit != null && digit >= 0 && digit <= 9) {
          onDigit(digit);
        }
      }
    }
  };
}
