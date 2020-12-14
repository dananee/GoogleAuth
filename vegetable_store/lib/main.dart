import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  var myFuture = Future(getnum);

  myFuture.then((value) => print(value)).catchError((error) => print(error));
  print(1);

  runApp(VegStore());
}

getnum() {
  return 3;
}

class VegStore extends StatelessWidget {
  const VegStore({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getData() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Cant Connect something wrong!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Isolte'),
        ),
        body: Center(
          child: RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
            child: Text('Click'),
            onPressed: () {
              getData()
                  .then((value) => print('Done'))
                  .catchError((e) => print(e));
            },
          ),
        ));
  }
}

getname(String name) {
  print('Hell0 $name');
  sleep(Duration(seconds: 1));
  print('Goodbye $name');
}
