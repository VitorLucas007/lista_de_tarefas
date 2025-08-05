import 'package:lista_de_tarefas/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static final Databasehelper _instance = Databasehelper._internal();
  static Database? _database;

  Databasehelper._internal();

  factory Databasehelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (index) {
      return Task.fromMap(maps[index]);
    });
  }

  Future<Task?> getTask(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete('tasks');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null; // Reset the database instance
  }
}
