import 'package:flutter/material.dart';


Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text widget',
      home: Scaffold(
        body: Center(
          child: Container(
            child: new Text('text str...',style: TextStyle(fontSize: 25.0)),
            alignment: Alignment.center,
            width: 500.0,
            height: 400.0,
            color: Colors.lightBlue,
          )
        )
      )
    );
  }
}