import 'package:flutter/material.dart';
import 'package:maroapp/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medcare App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF29A887),
          primary: const Color(0xFF29A887),
          background: const Color(0xFF355456),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Default flutter font, can be changed later
      ),
      home: const SplashScreen(),
    );
  }
}
