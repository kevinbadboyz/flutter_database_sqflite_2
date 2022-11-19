import 'package:flutter/material.dart';
import 'package:flutter_database_sqflite_2/create_employee.dart';
import 'package:flutter_database_sqflite_2/database_helper.dart';
import 'package:flutter_database_sqflite_2/employee_model.dart';
import 'package:sqflite/sqflite.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   DatabaseHelper databaseHelper = DatabaseHelper();
//
//   // final employee = Employee(name: 'Kevin', salary: 1000000);
//   // await databaseHelper.addEmployee(employee);
//   var employees = await databaseHelper.getAllEmployee();
//   print(employees);
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.deepOrange),
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DatabaseHelper _databaseHelper;
  List<Employee> employeeList = [];

  @override
  void initState() {
    super.initState();
    this._databaseHelper = DatabaseHelper();
    refreshEmployee();
  }

  void refreshEmployee() async {
    final data = await _databaseHelper.getAllEmployeeII();
    setState(() {
      employeeList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Sqflite'),
      ),
      body: FutureBuilder(
          future: _databaseHelper.getAllEmployeeII(),
          builder: (BuildContext ctx, AsyncSnapshot<List<Employee>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(itemCount: employeeList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(5),
                      elevation: 2.0,
                      child: ListTile(
                        // title: Text(snapshot.data![index].name),
                        // subtitle: Text(snapshot.data![index].salary.toString()),
                        title: Text(employeeList[index].name),
                        subtitle: Text(employeeList[index].salary.toString()),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreateEmployee()));
        },
      ),
    );
  }
}