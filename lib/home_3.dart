import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatelessWidget {
  final String task;
  final String deadline;
  final bool done;

  const TaskDetailPage({
    required this.task,
    required this.deadline,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDeadline = DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(deadline));

    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Tugas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(task, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('📅 Deadline:',  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(formattedDeadline, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('✅ Status:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(done ? 'Sudah Selesai' : 'Belum Selesai', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}