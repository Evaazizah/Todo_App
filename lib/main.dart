import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(#A8E6CF)
      ),
      home: MyHomePage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Map<String, dynamic>> _todos = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List<dynamic> todosJson = json.decode(todosString);
      setState(() {
        _todos = List<Map<String, dynamic>>.from(json.decode(todosString));
      });
    }
  }
    
    void _saveTodos() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('todos', json.encode(_todos));
    }
    
    void _addTodo() {
        if (_controller.text.isEmpty) return;
        setState(() {
            _todos.add({'task': _controller.text, 'done': false});
            _controller.clear();
        });
        _saveTodos();
    }

    void _toggleTodo(int index) {
        setState(() {
        _todos[index]['done'] = !_todos[index]['done'];
        });
        _saveTodos();
    }

    void _deleteTodo(int index) {
        setState(() {
        _todos.removeAt(index);
        });
        _saveTodos();
    }
}