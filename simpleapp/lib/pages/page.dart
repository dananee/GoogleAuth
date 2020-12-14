import 'package:flutter/material.dart';

class PageFirst extends StatelessWidget {
  static String id = 'Page';
  final String title;
  PageFirst({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello $title'),
      ),
    );
  }
}
