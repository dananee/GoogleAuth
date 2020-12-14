import 'package:animation/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(Animation());

class Animation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
