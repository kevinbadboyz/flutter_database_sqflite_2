import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_database_sqflite_2/database_helper.dart';
import 'package:flutter_database_sqflite_2/employee_model.dart';

class CreateEmployee extends StatefulWidget {
  const CreateEmployee({Key? key}) : super(key: key);

  @override
  _CreateEmployeeState createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  TextEditingController tecName = TextEditingController();
  TextEditingController tecSalary = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Data Employee'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: tecName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Entry your name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: tecSalary,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Salary',
                  hintText: 'Entry your salary',
                ),
                keyboardType: TextInputType.number,
              ),
              ButtonBar(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await databaseHelper.addEmployee(Employee(
                            name: tecName.text,
                            salary: int.parse(tecSalary.text.toString())));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Add data succesffuly...')));
                      },
                      child: const Text('Save')),
                  OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
