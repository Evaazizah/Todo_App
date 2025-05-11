import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(0xFFF1F8E9)
      ),
      darkTheme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: TodoPage(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}