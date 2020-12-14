import 'package:flutter/material.dart';
import 'package:litesql_app/dbhelper.dart';
import 'package:litesql_app/pages/display_page.dart';
import 'package:litesql_app/pages/edit_page.dart';
import 'package:litesql_app/pages/save_page.dart';

import 'model/model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String content, name;
  int hours;
  DbHelper dbHelper;
  Model model;
  Future allcontent;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();

    allcontent = dbHelper.query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SQL Database'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SavePage();
                  }));
                }),
          ],
        ),
        body: FutureBuilder(
           
            future: allcontent,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    key: UniqueKey(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      Model model = Model.fromMap(snapshot.data[index]);
                      return contents(model);
                    });
              }
            }));
  }

  Widget contents(model) {
    return Card(
      child: ListTile(
        key: UniqueKey(),
        title: Text("${model.name} - ${model.hours}"),
        subtitle: Text(
          model.content,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.redAccent,
                onPressed: () {
                  setState(() {
                    dbHelper.deleteData(model.id);
                  });
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.grey,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (content) {
                    return Edit(model);
                  }));
                },
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return DisplayPage(model);
          }));
        },
      ),
    );
  }
}
