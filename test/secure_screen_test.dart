import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:protected_screen/protected_screen_native.dart';

void main() {
  const MethodChannel channel = MethodChannel('protected_screen');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
