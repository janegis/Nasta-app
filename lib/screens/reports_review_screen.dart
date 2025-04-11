import 'package:flutter/material.dart';
import 'package:dienos_darbai/services/temp_storage_service.dart';

class ReportsReviewScreen extends StatefulWidget {
  const ReportsReviewScreen({super.key});

  @override
  State<ReportsReviewScreen> createState() => _ReportsReviewScreenState();
}

class _ReportsReviewScreenState extends State<ReportsReviewScreen> {
  List<String> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    // Paimkite visus ataskaitų duomenis iš TempStorageService
    final reports = await TempStorageService.getAllReports();

    // Konvertuokite List<Map<String, dynamic>> į List<String>, jei norite tik tekstinius duomenis
    setState(() {
      _reports = reports.map((report) => report['report_text'].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peržiūrėti Ataskaitas')),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_reports[index]),
          );
        },
      ),
    );
  }
}

