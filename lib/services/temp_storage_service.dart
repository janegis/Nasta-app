import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TempStorageService {
  static Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$filename';
  }

  static Future<File> _getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  // ======= LOGIN / REGISTRATION =======
  static Future<void> saveUser(String email, String password) async {
    final filePath = await _getFilePath('user_credentials.json');
    final file = File(filePath);
    await file.writeAsString(jsonEncode({'email': email, 'password': password}));
  }

  static Future<Map<String, String>?> getUser() async {
    final filePath = await _getFilePath('user_credentials.json');
    final file = File(filePath);
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      return {'email': data['email'], 'password': data['password']};
    }
    return null;
  }

  // =======================
  // ===== EMPLOYEES ======
  static Future<void> saveEmployeeData(String name, String surname) async {
    List<Map<String, String>> employees = await getData();
    employees.add({'name': name, 'surname': surname});
    await saveData(employees);
  }

  static Future<void> saveData(List<Map<String, String>> employees) async {
    final filePath = await _getFilePath('employees.json');
    final file = File(filePath);
    await file.writeAsString(jsonEncode(employees));
  }

  static Future<List<Map<String, String>>> getData() async {
    final filePath = await _getFilePath('employees.json');
    final file = File(filePath);
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content) as List;
      return data.map((e) => Map<String, String>.from(e)).toList();
    }
    return [];
  }

  // =======================
  // ===== DAILY TASK =====
  static Future<void> saveDailyDescription(String description) async {
    final filePath = await _getFilePath('daily_description.txt');
    final file = File(filePath);
    await file.writeAsString(description);
  }

  static Future<String?> getDailyDescription() async {
    final filePath = await _getFilePath('daily_description.txt');
    final file = File(filePath);
    if (await file.exists()) {
      return file.readAsString();
    }
    return null;
  }

  static Future<void> savePhotos(List<String> photoPaths) async {
    final filePath = await _getFilePath('photo_paths.json');
    final file = File(filePath);
    await file.writeAsString(jsonEncode(photoPaths));
  }

  static Future<List<String>> getPhotos() async {
    final filePath = await _getFilePath('photo_paths.json');
    final file = File(filePath);
    if (await file.exists()) {
      final content = await file.readAsString();
      return List<String>.from(jsonDecode(content));
    }
    return [];
  }

  // =======================
  // ===== MULTIPLE REPORTS =====
  static Future<void> addNewReport(String reportText) async {
    final file = await _getFile('multiple_reports.json');
    List<Map<String, dynamic>> existingReports = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      existingReports = jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    final newReport = {
      'timestamp': DateTime.now().toIso8601String(),
      'text': reportText,
    };

    existingReports.add(newReport);
    await file.writeAsString(jsonEncode(existingReports));
  }

  // Grąžina visas ataskaitas (jei nėra – grąžina tuščią sąrašą)
  static Future<List<Map<String, dynamic>>> getAllReports() async {
    final file = await _getFile('multiple_reports.json');
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);
    return jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // =======================
  // ===== REPORT FORM =====
  static Future<void> saveReport(String report) async {
    final filePath = await _getFilePath('report_text.txt');
    final file = File(filePath);
    await file.writeAsString(report);
  }

  static Future<String?> getReport() async {
    final filePath = await _getFilePath('report_text.txt');
    final file = File(filePath);
    if (await file.exists()) {
      return file.readAsString();
    }
    return null;
  }

  // Ištrina visus failus
  static Future<void> clearAll() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = [
      'employees.json',
      'daily_description.txt',
      'photo_paths.json',
      'report_text.txt',
    ];

    for (final name in files) {
      final file = File('${dir.path}/$name');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}




