import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_3.dart';

class TodoList extends StatelessWidget {
  final List<Map<String, dynamic>> todos;
  final Function(int) toggleTodo;
  final Function(int) deleteTodo;
  final Function(int, String) editTodo;

  const TodoList({
    required this.todos,
    required this.toggleTodo,
    required this.deleteTodo,
    required this.editTodo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        final deadline = DateTime.parse(todo['deadline']);
        final formattedDeadline = DateFormat('dd-MM-yyyy HH:mm').format(deadline);
        final isPastDeadline = deadline.isBefore(DateTime.now());

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              todo['task'],
              style: TextStyle(
                decoration: (todo['done'] || isPastDeadline)
                    ? TextDecoration.lineThrough
                    : null,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            subtitle: Text(
              '📅 Deadline: $formattedDeadline',
              style: TextStyle(
                color: isPastDeadline ? Colors.red : Theme.of(context).textTheme.bodySmall?.color, 
              ),
            ),
            leading: IconButton(
              icon: Icon(
                todo['done'] ? Icons.check_circle : Icons.radio_button_unchecked,
                color: todo['done'] ? Colors.green : Colors.grey,
              ),
              onPressed: () => toggleTodo(index),
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
                              editTodo(index, editController.text);
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
                              deleteTodo(index);
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
    );
  }
}