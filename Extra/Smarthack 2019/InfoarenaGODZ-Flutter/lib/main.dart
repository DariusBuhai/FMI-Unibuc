import 'package:flutter/material.dart';
import 'company_list.dart';

// main class of the app

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final appTitle = 'FTSE 100 - Analytics';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {

  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.black87
      ), // appBar with app title 
      body: CompanyList(),
      // list of companies we anlized
    );
  }
}
