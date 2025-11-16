import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Aplikasi / Tentang Kami'),
        centerTitle: true,
      ),
      body: Center( // <-- Tambahan untuk menengahkan seluruh konten
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // agar konten tidak memenuhi seluruh layar
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/uin_sts_logo.png',
                height: 120,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 100),
              ),
              const SizedBox(height: 20),
              const Text(
                'UIN STS JAMBI',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Dosen Pengampu: Ahmad Nasukha, S.Hum, M.Si',
                textAlign: TextAlign.center,
              ),
              const Text(
                'Mata Kuliah: Pemrograman Mobile',
                textAlign: TextAlign.center,
              ),
              const Text(
                'Pengembang: Yuni Amelia',
                textAlign: TextAlign.center,
              ),
              const Text(
                'Tahun Akademik: 2025/2026',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Beranda'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
