import 'package:dienos_darbai/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dienos darbai',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.redAccent, // Keičia AppBar foną
          foregroundColor: Colors.white, // Keičia tekstą į baltą
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(), //<- Pradinis langas turi būti HomeScreen

      },
    );
  }
}


