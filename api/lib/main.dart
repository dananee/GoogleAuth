import 'dart:convert';
import 'package:api/model.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(GetApi());

class GetApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Lang> lang;

  Future<Lang> getData() async {
    try {
      http.Response response = await http.get("http://10.0.2.2:8888/heroes");
      print(response.body[0]);
      String r;
      if (response.statusCode == 200) {
        var body = jsonEncode(response.body);
        for (int i = 0; i < body.length; i++) {
          r = body[i];
        }
        return Lang.fromJson(jsonDecode(r));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    lang = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: Text('Api Get Data'),
        ),
        body: Center(
          child: FutureBuilder<Lang>(
            future: lang,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.name[0]);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
