import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/task.dart';
import 'package:lista_de_tarefas/service/dataBaseHelper.dart';
import '../widgets/addTaskDialogWidget.dart';

class Tasklistview extends StatefulWidget {
  const Tasklistview({super.key});

  @override
  State<Tasklistview> createState() => _TasklistviewState();
}

class _TasklistviewState extends State<Tasklistview> {
  final Databasehelper _databasehelper = Databasehelper();
  List<Task> _tasks = [];
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isloading = true);

    final tasks = await _databasehelper.getAllTasks();

    setState(() {
      _tasks = tasks;
      _isloading = false;
    });
  }

  Future<void> _addTask(Task task) async {
    await _databasehelper.insertTask(task.toMap());
    _loadTasks();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tarefa adicionada com sucesso!')));
  }

  Future<void> _updateTask(Task task) async {
    await _databasehelper.updateTask(task);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _databasehelper.deleteTask(id);
    _loadTasks();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tarefa Excluida!')));
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => Addtaskdialog(onTaskAdded: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: Colors.blue[600],
        elevation: 0,
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
          ? _buildEmptyState()
          : _buildTaskList(),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddTaskDialog,
            backgroundColor: Colors.blue[600],
            child: Icon(Icons.add),
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Nenhuma tarefa encontrada',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          Text(
            'Toque no botão "+" para adicionar uma tarefa',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                _updateTask(task.copyWith(isCompleted: value ?? false));
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                    color: task.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                    color: task.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18,),
                      SizedBox(width: 8,),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red,),
                      SizedBox(width: 8,),
                      Text('Excluir', style: TextStyle(color: Colors.red),),
                    ],
                  ),
                )
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditTaskDialog(task);
                } else if(value == 'delete') {
                  _showDeleteConfirmationDialog(task);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => Addtaskdialog(
        task: task,
        onTaskAdded: (updatedTask) {
          _updateTask(updatedTask);
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Tarefa'),
        content: Text('Tem certeza que deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTask(task.id!);
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    );
  }
}

