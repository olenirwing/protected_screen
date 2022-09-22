import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class SecureScreenHandler {
  static const MethodChannel _channel = const MethodChannel('secure_screen');

  static Future secure() {
    return _channel.invokeMethod('secure');
  }

  static Future unsecure() {
    return _channel.invokeMethod('unsecure');
  }
}
