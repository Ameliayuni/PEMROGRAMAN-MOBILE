import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: const Color.fromARGB(255, 53, 193, 228),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 194, 224, 231),
              Color.fromARGB(255, 194, 224, 231),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 193, 228),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.flutter_dash,
                        size: 48,
                        color: const Color.fromARGB(255, 53, 193, 228),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tentang Aplikasi ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 53, 193, 228),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Flutter Navigation Demo\n\n'
                      'Aplikasi ini dibuat untuk mempelajari navigasi dasar Flutter, termasuk:\n\n'
                      '• Navigator.push() & Navigator.pop()\n'
                      '• Pengiriman data antar halaman\n'
                      '• BottomNavigationBar & Drawer\n\n'
                      'Desain dengan tema warna biru yang membuat hati ikut tenang.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 162, 212, 224),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 193, 228),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Made with  Flutter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}