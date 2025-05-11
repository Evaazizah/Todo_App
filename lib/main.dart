import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  StatefulWidget createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    ThemeMode _themeMode = ThemeMode.light;
  void _toggleTheme() {}
  
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(0xFFF1F8E9)
      ),
      home: TodoPage(),
    );
  }
}