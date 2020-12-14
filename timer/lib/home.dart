import 'dart:html';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var images;
  var imageFile;

  final picker = ImagePicker();

  Future loadImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    try {
      if (pickedFile != null) {
        setState(() {
          images = pickedFile.path;
        });
      } else {
        print('Empty');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        actions: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () {},
          )
        ],
      ),
      body: images == null
          ? ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Image.network(images);
              },
            )
          : Center(
              child: Text('Empty'),
            ),
    );
  }
}
