import 'package:flutter/material.dart';
import 'package:litesql_app/dbhelper.dart';

import 'model/model.dart';

class Edit extends StatefulWidget {
  Model model;
  Edit(this.model);
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  DbHelper dbHelper;

  TextEditingController tname = TextEditingController();
  TextEditingController tcontent = TextEditingController();
  TextEditingController thours = TextEditingController();
  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    tname.text = widget.model.name;
    tcontent.text = widget.model.content;
    thours.text = widget.model.hours.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              TextField(
                controller: tname,
              ),
              TextField(
                maxLines: 10,
                controller: tcontent,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: thours,
              ),
              RaisedButton(
                  child: Text('Save'),
                  onPressed: () {
                    var editing = Model({
                      'id': widget.model.id,
                      'name': tname.text,
                      'content': tcontent.text,
                      'hours': int.parse(thours.text),
                    });
                    dbHelper.updateData(editing);
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ));
  }
}
