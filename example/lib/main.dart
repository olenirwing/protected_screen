import 'package:flutter/material.dart';
import 'package:protected_screen/protected_screen.dart';

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

class SecuredScreen extends StatefulWidget {
  const SecuredScreen({Key? key}) : super(key: key);

  @override
  State<SecuredScreen> createState() => _SecuredScreenState();
}

class _SecuredScreenState extends State<SecuredScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProtectedScreen(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FlutterLogo(),
        ),
      ),
    );
  }
}
