import 'package:flutter/material.dart';
import 'src/views/UserInfo.dart';
import 'src/views/UsersList.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => UsersList(),
        '/userDesatils': (context) => UserInfo()
      },
    );
  }
}
