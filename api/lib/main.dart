import 'dart:convert';

import 'package:api/model.dart';
import 'package:flutter/widgets.dart';

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
  Future<Model> datafetch;
  List<Model> list = List<Model>();
  Future<Model> getData() async {
    var response =
        await http.get('https://jsonplaceholder.typicode.com/posts/');

    if (response.statusCode == 200) {
      List<dynamic> value = List<dynamic>();
      value = jsonDecode(response.body);
      if (value.length > 0) {
        for (int i = 0; i < value.length; i++) {
          if (i != null) {
            Map<String, dynamic> map = value[i];
            list.add(Model.fromJson(map));
          }
        }
      }
    } else {
      throw Exception('Failed To load album');
    }
  }

  @override
  void initState() {
    super.initState();
    datafetch = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: Text('Api Get Data'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          if (list.isNotEmpty) {
            return Card(
              child: Column(
                children: [
                  Text(
                    list[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      list[index].body,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Text('Error');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
