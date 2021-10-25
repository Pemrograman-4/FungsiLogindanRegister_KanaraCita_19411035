import 'package:flutter/material.dart';
import 'package:kanarapemograman/ui/login.dart';
import 'package:kanarapemograman/ui/startup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     debugShowCheckedModeBanner: false,
      home: StartUp()
    );
  }
}
