import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import 'employee_model.dart'; //import model class
import 'dart:io';
import 'dart:async';

class DatabaseHelper{
  final String _databaseName = 'hrd.db';
  final int _databaseVersion = 1;
  final String _tableName = 'tbemployee';
  final String _columnID = 'id';
  final String _columnName = 'name';
  final String _columnSalary = 'salary';

  Future<Database> init() async{
    Directory directory = await getApplicationDocumentsDirectory();
    final path =  join(directory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async{
        await db.execute(
          'create table $_tableName('
              '$_columnID integer primary key autoincrement, $_columnName text, $_columnSalary integer)'
        );
      }
    );
  }

  Future<int> addEmployee(Employee employee) async{
    //Open database
    final database = await init();
    return database.insert(_tableName, employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<List<Employee>> getAllEmployee() async{
    final database = await init();
    final List<Map<String, dynamic>> maps = await database.query(_tableName);
    return List.generate(maps.length, (index) => Employee(
        id : maps[index][_columnID],
        name: maps[index][_columnName],
        salary: maps[index][_columnSalary]
    )
    );
  }

  Future<List<Employee>> getAllEmployeeII() async{
    // halloooo......
    final database = await init();
    final List<Map<String, dynamic>> maps = await database.query(_tableName);
    return maps.map((e) => Employee.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getEmployees() async{
    final database = await init();
    // return await database.query(_tableName, orderBy: 'id');
    return await database.rawQuery('select * from $_tableName order by id');
  }

  Future<int> updateEmployee(int id, Employee employee) async{
    final database = await init();
    final data = {
      'name': employee.name,
      'salary': int.parse(employee.salary.toString())
    };
    return database.update(_tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteEmployee(int id) async{
    final database = await init();
    try{
     // database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
      database.rawDelete('Delete from ${_tableName} where ${_columnID} = $id');
    }catch (err){
      debugPrint('Error delete data');
    }
  }

  Future<List<Map<String, dynamic>>> queryRow(name) async{
    final database = await init();
    // return await database.query(_tableName, where: "${_columnName} LIKE '%$name%' ");
    return await database.rawQuery("select * from ${_tableName} where ${_columnName} LIKE '%$name%' ");
  }
}