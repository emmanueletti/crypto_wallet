import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './authentication.dart';

void main() async {
  // First thing is to instantiate Firebase connection
  // https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// Application root widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      home: Authentication(),
    );
  }
}
