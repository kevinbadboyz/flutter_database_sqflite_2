import 'package:flutter/material.dart';
import 'package:flutter_database_sqflite_2/create_employee.dart';
import 'package:flutter_database_sqflite_2/database_helper.dart';
import 'package:flutter_database_sqflite_2/employee_model.dart';
import 'package:flutter_database_sqflite_2/search_employee.dart';
import 'package:sqflite/sqflite.dart';

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
  List<Map<String, dynamic>> listEmployee = [];
  bool isLoading = true;
  TextEditingController tecName = TextEditingController();
  TextEditingController tecSalary = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshEmployee();
  }

  void refreshEmployee() async {
    final data = await DatabaseHelper().getEmployees();
    setState(() {
      listEmployee = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void showForm(int? id) async {
      if (id != null) {
        // id  == null -> create new stok
        // id != null -> update an existing stok
        final existingStok =
        listEmployee.firstWhere((element) => element['id'] == id);
        tecName.text = existingStok['name'];
        tecSalary.text = existingStok['salary'].toString();
      }

      Future<void> _addEmployee() async {
        await DatabaseHelper().addEmployee(Employee(
            name: tecName.text, salary: int.parse(tecSalary.text.toString())));
        refreshEmployee();
      }

      Future<void> _updateEmployee(int id) async {
        await DatabaseHelper().updateEmployee(
            id,
            Employee(
                name: tecName.text,
                salary: int.parse(tecSalary.text.toString())));
        refreshEmployee();
      }

      showModalBottomSheet(
          context: context,
          elevation: 5,
          builder: (_) => Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            height: 600,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Form New Employee',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: tecName,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Entry your name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: tecSalary,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Salary',
                      hintText: 'Entry your salary',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonBar(
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (id == null) {
                              await _addEmployee();
                            }

                            if (id != null) {
                              await _updateEmployee(id);
                            }

                            tecName.text = '';
                            tecSalary.text = '';
                            Navigator.of(context).pop();
                          },
                          child:
                          Text(id == null ? 'Create New' : 'Update')),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ));
    }

    void _deleteEmployee(int id, String name) {
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text('Information'),
          content: Text('Delete data $name?'),
          actions: [
            ElevatedButton(onPressed: () async {
              await DatabaseHelper().deleteEmployee(id);
              refreshEmployee();
              Navigator.pop(context);
            }, child: const Text('Yes')),
            OutlinedButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('No')),
          ],
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Sqflite'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushAndRemoveUntil(context, 
                MaterialPageRoute(builder: (context)=> SearchEmployee()), (Route<dynamic>route) => false);
          }, icon: Icon(Icons.search))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listEmployee.length,
              itemBuilder: (context, index) => Card(
                    color: Colors.white70,
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(listEmployee[index]['name']),
                      subtitle: Text(listEmployee[index]['salary'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    showForm(listEmployee[index]['id']),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () =>
                                    _deleteEmployee(listEmployee[index]['id'], listEmployee[index]['name']),
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () => showForm(null)),
    );
  }
}
