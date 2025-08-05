import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/task.dart';

class Addtaskdialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onTaskAdded;
  const Addtaskdialog({super.key, this.task, required this.onTaskAdded});

  @override
  State<Addtaskdialog> createState() => _AddtaskdialogState();
}

class _AddtaskdialogState extends State<Addtaskdialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Adicionar Tarefa' : 'Editar Tarefa'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, insira um título';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, insira uma descrição';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text(widget.task == null ? 'Adicionar' : 'Salvar'),
        ),
      ],
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task =
          widget.task?.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
          ) ??
          Task(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            createdAt: DateTime.now(),
          );

      widget.onTaskAdded(task);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
