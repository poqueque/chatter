import 'package:flutter/material.dart';

class AppStyles {
  static const Color orange = Colors.deepOrange;
  static const separator = SizedBox(height: 24, width: 24);
  static const chatSeparator = SizedBox(height: 8, width: 8);

  static const mediumText = TextStyle(fontSize: 18);
  static const chatText = TextStyle(
    fontSize: 20,
    color: Colors.purple,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );
}
