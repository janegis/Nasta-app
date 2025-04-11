import 'package:flutter/material.dart';
import 'package:dienos_darbai/services/temp_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:dienos_darbai/screens/reports_review_screen.dart';  // Tikslus kelias į jūsų ReportsReviewScreen failą


class ReportFormScreen extends StatefulWidget {
  final List<Map<String, String>> employees;

  const ReportFormScreen({super.key, required this.employees});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();

}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final TextEditingController _reportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingReport();
  }

  Future<void> _loadExistingReport() async {
    final reportText = await TempStorageService.getReport();
    if (reportText != null) {
      _reportController.text = reportText;
    }
  }

  Future<void> _saveAndExit() async {
    final reportText = _reportController.text.trim();
    await TempStorageService.saveReport(reportText);
    SystemNavigator.pop();
  }

  Future<void> _addToMultipleReports() async {
    final reportText = _reportController.text.trim();
    if (reportText.isEmpty) return;

    await TempStorageService.addNewReport(reportText);

    setState(() {
      _reportController.clear(); // Išvalo lauką naujam įrašui
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ataskaita pridėta')),
    );
  }

  // Peržiūros funkcija
  Future<void> _previewReport() async {
    final employees = await TempStorageService.getData();
    final description = await TempStorageService.getDailyDescription();
    final photos = await TempStorageService.getPhotos();
    final allReports = await TempStorageService.getAllReports(); // ← paimk visas ataskaitas

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ataskaitos peržiūra'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('👤 Darbuotojai:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...employees.map((e) => Text('${e['name'] ?? ''} ${e['surname'] ?? ''}')),
              const SizedBox(height: 12),
              const Text('📝 Dienos aprašymas:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(description ?? 'Nėra'),
              const SizedBox(height: 12),
              const Text('🖼️ Nuotraukos:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${photos.length} nuotraukos (-ų)'),
              const SizedBox(height: 12),
              const Text('📄 Ataskaitos:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...allReports.map((r) => Text('- $r')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Uždaryti'),
          ),
        ],
      ),
    );
  }

  // Siuntimo funkcija
  Future<void> _sendReport() async {
    // Parodykite siuntimo pranešimą
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Siuntimas'),
        content: const Text('Duomenys bus išsiųsti ir laikini failai bus ištrinti.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Siųsti duomenis į serverį (reikia sukurti šią funkciją)
              // await sendDataToServer();

              // Ištrinti laikinuosius failus
              await TempStorageService.clearAll();

              // Papildomai galite atnaujinti būseną, jei reikia
              setState(() {
                // Išvalyti reikalingus laukus arba duomenis po siuntimo
                _reportController.clear();
              });

              // Parodyti pranešimą apie siuntimą
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Duomenys sėkmingai išsiųsti ir laikini failai ištrinti')),
              );
            },
            child: const Text('Gerai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dienos ataskaita'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/logo_nasta.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Įveskite objektą:',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _reportController,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Rašykite čia...',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0x80504343),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _addToMultipleReports,
                icon: const Icon(Icons.add),
                label: const Text('Pridėti ataskaitą'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                  backgroundColor: Colors.green,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _previewReport,
                      icon: const Icon(Icons.remove_red_eye),
                      label: const Text('Peržiūrėti'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _sendReport,
                      icon: const Icon(Icons.send),
                      label: const Text('Siųsti'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _saveAndExit,
                icon: const Icon(Icons.save),
                label: const Text('Išsaugoti ir išeiti'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                  backgroundColor: Colors.blue,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportsReviewScreen()),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Peržiūrėti visas ataskaitas'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 5,
                  backgroundColor: Colors.orange,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}