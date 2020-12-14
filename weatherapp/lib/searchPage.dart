import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBar extends StatefulWidget {
  static String id = 'Search ';
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String title = 'Weather';
  String city;
  TextEditingController controller = TextEditingController();

  Future<void> getData() async {
    String apiId = 'c9e5c9993fe92a6be1dbf21d7f2756d0';
    String lang = 'ar';
    String units = 'metric';
    String url =
        "https://api.openweathermap.org/data/2.5/weather?q=${controller.text}&units=$units&appid=$apiId&lang=$lang";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(city);
      print(body['main']['temp']);
    }
  }

  @override
  void initState() {
    super.initState();
    city = controller.text;
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    city = controller.text;
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: primary,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 20.0),
                        borderRadius: BorderRadius.circular(30)),
                    hintText: 'City',
                    hintStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                    padding:
                        EdgeInsets.symmetric(horizontal: 60, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0)),
                    color: primary,
                    onPressed: () {
                      getData();

                      city = controller.text;
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
