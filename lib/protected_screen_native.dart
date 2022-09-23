import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class ProtectedScreenHandler {
  static const MethodChannel _channel = const MethodChannel('protected_screen');

  static Future addProtection() {
    return _channel.invokeMethod('addProtection');
  }

  static Future removeProtection() {
    return _channel.invokeMethod('removeProtection');
  }
}
