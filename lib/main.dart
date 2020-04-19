import 'package:deadly_timer/pages/default_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AnnotatedRegion<SystemUiOverlayStyle>(value: SystemUiOverlayStyle.dark, child: DefaultHomePage()));
  }
}
