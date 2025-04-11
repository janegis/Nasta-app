import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Nepamiršk pridėti šito pubspec.yaml faile
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
    final reports = await TempStorageService.getAllReports();

    final formatter = DateFormat('yyyy-MM-dd HH:mm');

    setState(() {
      _reports = reports.map((report) {
        final dynamic timestampRaw = report['timestamp'];

        // Patikriname ar tai String, jei ne, priskiriam tuščią
        final timestampString = timestampRaw is String ? timestampRaw : '';

        final dateTime = DateTime.tryParse(timestampString) ?? DateTime.now();
        final formattedTime = formatter.format(dateTime);

        final dynamic textRaw = report['text'];
        final text = textRaw is String ? textRaw : '';

        return '$formattedTime\n$text';
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peržiūrėti Ataskaitas')),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _reports[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}


