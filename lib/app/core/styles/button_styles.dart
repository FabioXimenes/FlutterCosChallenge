import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 42),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ));
}
