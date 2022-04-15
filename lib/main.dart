import 'package:baable/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baable',
      theme:
          ThemeData(fontFamily: 'Raleway', primaryColor: Colors.lightBlue[100]),
      debugShowCheckedModeBanner: false,
      routes: Routes.getroutes,
    );
  }
}
