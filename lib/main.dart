import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
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