import 'package:artcollector/pages/initpage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:artcollector/pages/resultpage.dart';


Future<void> main() async {
  // Load environment variables from .env file
  //await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitPage(),
    );
  }
}