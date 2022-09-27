import 'dart:async';

import 'package:flutter/services.dart';

class ProtectedScreenHandler {
  static const MethodChannel _channel = MethodChannel('protected_screen');

  static Future addProtection() {
    return _channel.invokeMethod('addProtection');
  }

  static Future removeProtection() {
    return _channel.invokeMethod('removeProtection');
  }
}
