import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/temp_storage_service.dart';
import 'employee_list_screen.dart';  // Pridėkite importą

class DailyTaskScreen extends StatefulWidget {
  const DailyTaskScreen({super.key});

  @override
  _DailyTaskScreenState createState() => _DailyTaskScreenState();
}

class _DailyTaskScreenState extends State<DailyTaskScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _photos = [];
  final ImagePicker _picker = ImagePicker();

  // Pridėti foto
  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
  }

  // Išsaugoti (jei laukas neužpildytas - nedaryti nieko)
  void _saveToFile() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aprašymo laukas negali būti tuščias!')),
      );
      return;
    }

    // Išsaugome aprašymą ir nuotraukas į laikinas atminties vietas
    await TempStorageService.saveDailyDescription(_descriptionController.text.trim());
    await TempStorageService.savePhotos(_photos.map((f) => f.path).toList());

    // Pranešimas vartotojui
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duomenys sėkmingai išsaugoti')),
    );

    // Pereiti į Employee List ekraną
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeListScreen()),
    );
  }

  // Išvalyti viską su patvirtinimu
  void _clearFields() async {
    final confirmDelete = await _showConfirmationDialog(context);

    if (confirmDelete) {
      setState(() {
        _descriptionController.clear();
        _photos.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visi duomenys pašalinti')),
      );
    }
  }

  // Dialogas, patvirtinantis ištrynimą
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Įspėjimas'),
          content: const Text('Ar tikrai norite ištrinti visus duomenis?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Atšaukti'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Ištrinti'),
            ),
          ],
        );
      },
    );

    // Jei 'result' yra null, grąžinkite false
    return result ?? false;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dienos Darbo Aprašymas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              maxLength: 500,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Įveskite dienos darbo aprašymą',
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _photos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _photos.removeAt(index);
                      });
                    },
                    child: Image.file(
                      _photos[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveToFile,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Išsaugoti'),
                ),
                ElevatedButton(
                  onPressed: _getImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Ištrinti'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



