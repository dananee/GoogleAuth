import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff3D1BA4),
        accentColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
