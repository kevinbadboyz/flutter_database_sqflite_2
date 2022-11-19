class Employee{
  final int? id;
  final String name;
  final int salary;

  // Employee(this.id, this.name, this.salary);
  Employee({this.id, required this.name, required this.salary});

  // It converts a Employee into a Map. The keys correspond to the names of the columns in the database.
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'salary' : salary
    };
  }

  Employee.fromMap(Map<String, dynamic> res)
    : id = res['id'],
    name = res['name'],
    salary = res['salary'];
}