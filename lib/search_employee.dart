import 'package:flutter/material.dart';
import 'package:flutter_database_sqflite_2/database_helper.dart';
import 'package:flutter_database_sqflite_2/employee_model.dart';

class SearchEmployee extends StatefulWidget {
  const SearchEmployee({Key? key}) : super(key: key);

  @override
  _SearchEmployeeState createState() => _SearchEmployeeState();
}

class _SearchEmployeeState extends State<SearchEmployee> {
  final dbHelper = DatabaseHelper();
  List<Employee> employeeByName = [];
  TextEditingController tecSearch = TextEditingController();

  void _query(name) async {
    final allEmployee = await dbHelper.queryRow(name);
    employeeByName.clear();
    allEmployee.forEach((row) => employeeByName.add(Employee.fromMap(row)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: tecSearch,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name of employee',
                  ),
                  onChanged: (text) {
                    if (text.length >= 2) {
                      setState(() {
                        _query(text);
                      });
                    } else {
                      setState(() {
                        employeeByName.clear();
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: employeeByName.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Center(
                          child: Text(
                              '[${employeeByName[index].id}] - ${employeeByName[index].name} - ${employeeByName[index].salary}'),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
