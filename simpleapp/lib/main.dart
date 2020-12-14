import 'package:flutter/material.dart';
import 'package:simpleapp/pages/home.dart';
import 'package:simpleapp/pages/page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        PageFirst.id: (context) => PageFirst(),
      },
    );
  }
}
