import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/homePage.dart';
import 'package:weatherapp/searchPage.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(accentColor: Colors.white, primaryColor: Colors.deepOrange),
      home: HomePage(),
      routes: {
        SearchBar.id: (context) => SearchBar(),
      },
    );
  }
}
