import 'dart:async';

import 'package:flutter/services.dart';

class ProtectedScreenHandler {
  static const MethodChannel _channel = MethodChannel('protected_screen');

  static Future addProtectionForPause() {
    return _channel.invokeMethod('addProtectionForPause');
  }

  static Future removeProtectionForPause() {
    return _channel.invokeMethod('removeProtectionForPause');
  }
}
