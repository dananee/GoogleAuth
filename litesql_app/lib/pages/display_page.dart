import 'package:flutter/material.dart';
import 'model/model.dart';

class DisplayPage extends StatefulWidget {
  Model model;

  DisplayPage(this.model);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.model.name,
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(widget.model.content,
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(
                height: 20.0,
              ),
              Text(widget.model.hours.toString(),
                  style: TextStyle(fontSize: 12.0))
            ],
          ),
        ),
      ),
    );
  }
}
