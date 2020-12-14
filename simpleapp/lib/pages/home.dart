import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simpleapp/pages/page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;

  Future<String> getAppDir() async {
    var folder = await getApplicationDocumentsDirectory();
    return folder.path;
  }

  Future<File> getLocalFile() async {
    var path = await getAppDir();
    return File('$path/counter.txt');
  }

  Future<File> writeData(int c) async {
    File file = await getLocalFile();
    return file.writeAsString('$c');
  }

  Future<int> readData() async {
    try {
      File file = await getLocalFile();
      String content = await file.readAsString();
      return int.parse(content);
    } catch (e) {
      return 0;
    }
  }

  Future<void> gettoNextPage(String title) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PageFirst(title: title);
    }));
  }

  @override
  void initState() {
    super.initState();
    readData().then((value) {
      setState(() {
        counter = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Read/Write')),
      ),
      body: Center(child: Text('Counte $counter')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          gettoNextPage('World');
        },
      ),
    );
  }
}
