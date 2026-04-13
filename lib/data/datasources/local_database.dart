import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('employees.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
        empCode TEXT PRIMARY KEY, empName TEXT NOT NULL, mobile TEXT,
        dob TEXT, dateOfJoining TEXT, salary REAL, address TEXT, remark TEXT
      )
    ''');
  }

  Future<void> insertEmployee(EmployeeModel employee) async {
    final db = await instance.database;
    await db.insert('employees', employee.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EmployeeModel>> getAllEmployees() async {
    final db = await instance.database;
    final result = await db.query('employees');
    return result.map((json) => EmployeeModel.fromMap(json)).toList();
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    final db = await instance.database;
    await db.update('employees', employee.toMap(),
        where: 'empCode = ?', whereArgs: [employee.empCode]);
  }

  Future<void> deleteEmployee(String empCode) async {
    final db = await instance.database;
    await db.delete('employees', where: 'empCode = ?', whereArgs: [empCode]);
  }
}
