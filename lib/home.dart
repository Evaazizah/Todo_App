import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Map<String, dynamic>> _todos = [];
  String _filter = 'all';
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
    if (_filter == 'done') {
        return _todos.where((todo) => todo['done']).toList();
    } else if (_filter == 'not_done') {
        return _todos.where((todo) => !todo['done']).toList();
    }
    return _todos;
  }
  
  void _setFilter(String value) {
    setState(() {
        _filter = value;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final todos = _filteredTodos;

    return Scaffold(
        appBar: AppBar(
            title: Text('📋Daftar Tugas Harian'),
            centerTitle: true,
            actions: [
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
                Expanded(
                    child: todos.isEmpty
                            ? Center(
                                    child: Text(
                                        '📅 Tidak ada tugas saat ini!😎',
                                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                                    ),
                                )
                            : ListView.builder(
                                itemCount: todos.length,
                                    itemBuilder: (context, index) {
                                        final todo = todos[index];
                                        final realIndex = _todos.indexOf(todo);

                                        final deadline = DateTime.tryParse(todo['deadline'] ?? '');
                                        final isExpired = deadline != null && DateTime.now().isAfter(deadline);

                                        return Card(
                                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            elevation: 2,
                                            child: ListTile(
                                                title: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text(
                                                            todo['task'],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                decoration: (todo['done'] || isExpired)
                                                                        ? TextDecoration.lineThrough 
                                                                        : null,
                                                                color: isExpired ? Colors.grey : null,
                                                            ),
                                                        ),
                                                        if (deadline != null)
                                                            Text(
                                                                '🕒 Deadline: ${deadline.toString().substring(0, 16)}',
                                                                style: TextStyle(
                                                                    color: isExpired ? Colors.red : Colors.black54,
                                                                    fontSize: 12,
                                                                ),
                                                            ),
                                                    ],
                                                ),
                                                leading: IconButton(
                                                    icon: Icon(
                                                        todo['done'] ? Icons.check_circle : Icons.radio_button_unchecked,
                                                        color: todo['done'] ? Colors.green : Colors.grey,
                                                    ),
                                                    onPressed: () => _toggleTodo(realIndex),
                                                ),
                                                trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                            IconButton(
                                                                icon: Icon(Icons.edit, color: Colors.orange),
                                                                onPressed: () {
                                                                    final editController = TextEditingController(text: todo['task']);
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (_) => AlertDialog(
                                                                            title: Text('Edit Tugas'),
                                                                            content: TextField(controller: editController),
                                                                            actions: [
                                                                                TextButton(
                                                                                    onPressed: () => Navigator.pop(context),
                                                                                    child: Text('Batal'),
                                                                                ),
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                        _editTodo(realIndex, editController.text);
                                                                                        Navigator.pop(context);
                                                                                    },
                                                                                    child: Text('Simpan'),
                                                                                ),
                                                                                    
                                                                            ],
                                                                        ),
                                                                    );
                                                                },
                                                            ),
                                                            IconButton(
                                                                icon: Icon(Icons.delete_forever, color: Colors.red),
                                                                onPressed: () {
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (_) => AlertDialog(
                                                                            title: Text('Konfirmasi Hapus'),
                                                                            content: Text('Apakah Anda yakin ingin menghapus tugas ini?'),
                                                                            actions: [
                                                                                TextButton(
                                                                                    onPressed: () => Navigator.pop(context),
                                                                                    child: Text('Batal'),
                                                                                ),
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                        _deleteTodo(realIndex);
                                                                                        Navigator.pop(context);
                                                                                    },
                                                                                    child: Text('Hapus'),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    );   
                                                                            
                                                                },
                                                            ),   
                                                            
                                                        ],
                                                    ),
                                                ),
                                            );
                                        },
                                        
                                    ),
                    ),
                ],
            ),
        );
    }
}