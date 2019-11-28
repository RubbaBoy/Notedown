import 'package:flutter/material.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/ui/views/login_view.dart';

void main() {
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notedown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoginView(),
    );
  }
}