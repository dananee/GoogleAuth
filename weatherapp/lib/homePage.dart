import 'package:flutter/material.dart';
import 'package:weatherapp/searchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Weather';
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primary,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return SearchBar();
                }));
              }),
        ],
      ),
      body: Column(
        children: [Text('Hello')],
      ),
    );
  }
}
