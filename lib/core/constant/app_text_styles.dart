import 'package:flutter/cupertino.dart';

class AppTextStyles {
  static TextStyle text12({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.018,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text14({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.022,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text16({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.026,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text18({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.03,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text20({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.032,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text22({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.035,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text24({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.038,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text26({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.042,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }

  static TextStyle text28({required bool bold, required Size size}) {
    return TextStyle(
      fontSize: ((size.width + size.height) / 2) * 0.044,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );
  }
}
