// lib/models/employee.dart
class Employee {
  final String name;
  final String surname;

  Employee({required this.name, required this.surname});

  Map<String, String> toMap() {
    return {'name': name, 'surname': surname};
  }

  factory Employee.fromMap(Map<String, String> map) {
    return Employee(
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
    );
  }
}

