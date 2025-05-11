import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_2.dart';

class TodoPage extends StatefulWidget {
    final Function(bool) onToggleTheme;
    final bool isDarkMode;

    TodoPage({required this.onToggleTheme, required this.isDarkMode});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Map<String, dynamic>> _todos = [];
  String _filter = 'all';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      setState(() {
        _todos = List<Map<String, dynamic>>.from(json.decode(todosString)).map((todo) {
          return {
            'task': todo['task'],
            'done': todo['done'],
            'deadline': todo['deadline'] ?? DateTime.now().toIso8601String(),
          };
        }).toList();
      });
    }
  }
  
  void _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todos', json.encode(_todos));
  }
  
  void _addTodo() async {
    if (_controller.text.isEmpty) return;

    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    final deadline = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
    );

    setState(() {
        _todos.add({
            'task': _controller.text, 
            'done': false, 
            'deadline': deadline.toIso8601String()
        });
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
  
  void _editTodo(int index, String newTask) {
    setState(() {
        _todos[index]['task'] = newTask;
    });
    _saveTodos(); 
  }
  
  void _deleteTodo(int index) {
    setState(() {
        _todos.removeAt(index);
    });
    _saveTodos();
  }
  
  List<Map<String, dynamic>> get _filteredTodos {
    List<Map<String, dynamic>> filtered = _todos;

    if (_filter == 'done') {
        filtered = filtered.where((todo) => todo['done']).toList();
    } else if (_filter == 'not_done') {
        filtered = filtered.where((todo) => !todo['done']).toList();
    }

    if (_searchController.text.isNotEmpty) {
        filtered = filtered.where((todo) => 
            todo['task'].toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    return filtered;
  }
  
  void _setFilter(String value) {
    setState(() {
        _filter = value;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final todos = _filteredTodos;

    return Scaffold(
        appBar: AppBar(
            title: _showSearchBar
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: '🔍 Cari Tugas',
                        border: InputBorder.none,
                    ),
                    onChanged: (value) {
                        setState(() {});
                    },
                )
                : Text('📋Daftar Tugas Harian'),
            centerTitle: true,
            actions: [
                IconButton(
                    icon: Icon(_showSearchBar ? Icons.close : Icons.search),
                    onPressed: () {
                        setState(() {
                            _showSearchBar = !_showSearchBar;
                            if (!_showSearchBar) _searchController.clear();
                        });
                    },
                ),
                PopupMenuButton<String>(
                    onSelected: _setFilter,
                    itemBuilder: (context) => [
                        PopupMenuItem(value: 'all', child: Text('Semua Tugas')),
                        PopupMenuItem(value: 'done', child: Text('Tugas Selesai')),
                        PopupMenuItem(value: 'not_done', child: Text('Tugas Belum Selesai')),
                    ],
                )
            ],
        ),
        body: Column(
            children: [
                SizedBox(height: 12),
                Text(
                    '✨ Tetap semangat! Selesaikan tugas-tugasmu! 💪',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                ),
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                        children: [
                            Expanded(
                                child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                        labelText: '✍️ Tambahkan tugas baru',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.add_circle, color: Colors.teal),
                                            onPressed: _addTodo,
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
                Expanded(
                    child: TodoList(
                        todos: todos,
                        toggleTodo: _toggleTodo,
                        editTodo: _editTodo,
                        deleteTodo: _deleteTodo,
                        ),
                    ),
                ],
            ),
        );
    }
}