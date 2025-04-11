import 'package:flutter/material.dart';
import '../services/temp_storage_service.dart';
import 'report_form.dart'; // Importuojame ReportFormScreen

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  List<Map<String, String>> employees = [];  // Darbuotojų sąrašas

  // Funkcija pridėti darbuotoją į sąrašą
  void _addEmployee() {
    if (_nameController.text.trim().isEmpty || _surnameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visi laukeliai turi būti užpildyti!')),
      );
      return;
    }

    // Pridedame darbuotojo duomenis į sąrašą
    setState(() {
      employees.add({
        'name': _nameController.text.trim(),
        'surname': _surnameController.text.trim(),
      });
    });

    // Išvalome laukus po pridėjimo
    _nameController.clear();
    _surnameController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Darbuotojų Sąrašas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Įveskite darbuotojo vardą',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Įveskite darbuotojo pavardę',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addEmployee, // Pridėti darbuotoją
              child: const Text('Pridėti darbuotoją'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('${employee['name']} ${employee['surname']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (employees.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pirmiausia pridėkite darbuotojus.')),
                  );
                  return;
                }

                // Pereiti į ReportFormScreen ir perduoti darbuotojų sąrašą
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportFormScreen(employees: employees),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Išsaugoti darbuotojus ir pereiti į ataskaitą'),
            ),
          ],
        ),
      ),
    );
  }
}








