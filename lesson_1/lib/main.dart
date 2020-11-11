import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'model/post.dart';

void main() => runApp(LessonOne());

class LessonOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var postData;
  @override
  void initState() {
    super.initState();
    postData = getData();
  }

  Future<Posts> getData() async {
    http.Response response = await http.get('http://127.1.1.1:4050/heroes');

    if (response.statusCode == 200) {
      print(response.body);
      // return Posts.fromJson(json.decode(response.body));
    } else {
      throw Exception('Cant Connect something wrong!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Hello"),
    );
  }
}
