import 'package:flutter/material.dart';
import 'package:litesql_app/dbhelper.dart';

import 'model/model.dart';

class SavePage extends StatefulWidget {
  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  String content, name;
  int hours;

  DbHelper dbHelper;
  Model model;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Content'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Enter Name'),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(hintText: 'Enter Content'),
                  onChanged: (value) {
                    setState(() {
                      content = value;
                    });
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Enter Hour'),
                  onChanged: (value) {
                    setState(() {
                      hours = int.parse(value);
                    });
                  },
                ),
                RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    setState(() async {
                      model = Model(
                          {'name': name, 'content': content, 'hours': hours});

                      await dbHelper.insertModel(model);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
