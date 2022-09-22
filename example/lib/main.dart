import 'package:flutter/material.dart';
import 'package:secure_screen/secure_screen.dart';
import 'package:secure_screen/secure_screen_native.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => SecuredScreen())))),
    );
  }
}

class SecuredScreen extends StatelessWidget {
  const SecuredScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SecureScreen(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
