import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/views/taskListView.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: const Tasklistview(),
      debugShowCheckedModeBanner: false,
    );
  }
}