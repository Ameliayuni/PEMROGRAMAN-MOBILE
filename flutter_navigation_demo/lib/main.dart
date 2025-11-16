import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo - Blue Theme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 105, 195, 255),
        colorScheme: const ColorScheme.light(
          primary: const Color.fromARGB(255, 105, 195, 255),
          secondary: Color.fromARGB(255, 36, 231, 199),
          background: Color.fromARGB(255, 159, 214, 240),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 105, 195, 255),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 105, 195, 255),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}