import 'package:flutter/material.dart';
import 'package:dienos_darbai/screens/report_form.dart';
import 'employee_list_screen.dart';
import 'daily_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ataskaita'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Pushes content to the top and bottom
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo_nasta.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DailyTaskScreen()),
                  );
                },
                icon: const Icon(Icons.construction, size: 24), // Add an icon for clarity
                label: const Text('Dienos Darbai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  minimumSize: const Size.fromHeight(50), // Adjust button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding for better spacing
                  elevation: 5, // Add shadow for depth
                ),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
                  );
                },
                icon: const Icon(Icons.person_2_rounded, size: 24), // Add an icon for clarity
                label: const Text('Darbuotoju Sarašas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  minimumSize: const Size.fromHeight(50), // Adjust button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding for better spacing
                  elevation: 5, // Add shadow for depth
                ),
              ),

              // Custom Button for Nauja ataskaita
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportFormScreen(employees:[])),
                  );
                },
                icon: const Icon(Icons.note_add, size: 24), // Add an icon for clarity
                label: const Text('Nauja ataskaita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  minimumSize: const Size.fromHeight(50), // Adjust button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding for better spacing
                  elevation: 5, // Add shadow for depth
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


