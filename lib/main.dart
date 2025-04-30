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

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('📋Daftar Tugas Harian'),
                centerTitle: true,
            ),
            body: Column(
                children: [
                    SizedBox(height: 12),
                    Text(
                        '✨ Tetap semangat! Selesaikan tugas-tugasmu! 💪',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                labelText: 'Add a new task',
                                border: OutlineInputBorder(),
                            ),
                        ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: _todos.length,
                            itemBuilder: (context, index) {
                                return ListTile(
                                    title: Text(_todos[index]['task']),
                                    trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => _deleteTodo(index),
                                    ),
                                    leading: Checkbox(
                                        value: _todos[index]['done'],
                                        onChanged: (value) => _toggleTodo(index),
                                    ),
                                );
                            },
                        ),
                    ),
                ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: _addTodo,
                child: Icon(Icons.add),
            ),
        );
    }
}