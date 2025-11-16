import 'package:flutter/material.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // === Daftar warna tema ===
  final Map<String, Color> themeColors = {
    'Biru': Colors.blue,
    'Hijau': Colors.green,
    'Merah': Colors.red,
    'Ungu': Colors.purple,
    'Oranye': Colors.orange,
  };

  String selectedColor = 'Biru';

  @override
  Widget build(BuildContext context) {
    final Color currentColor = themeColors[selectedColor]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Feedback'),
        centerTitle: true,
        actions: [
          const Icon(Icons.light_mode),
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
          const Icon(Icons.dark_mode),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // === Logo Aplikasi ===
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: currentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: currentColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: currentColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Gambar logo dengan warna border dinamis
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: currentColor, width: 2),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/flutter_logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Campus Feedback App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: currentColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // === Dropdown untuk Ubah Warna Tema ===
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.color_lens, color: Colors.blueAccent),
                const SizedBox(width: 10),
                const Text(
                  "Pilih Warna Tema:",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedColor,
                  items: themeColors.keys.map((String colorName) {
                    return DropdownMenuItem<String>(
                      value: colorName,
                      child: Text(colorName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedColor = value);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // === Tombol Navigasi ===
            _buildMenuButton(
              context,
              title: 'Formulir Feedback Mahasiswa',
              color: currentColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedbackFormPage()),
              ),
            ),
            const SizedBox(height: 10),
            _buildMenuButton(
              context,
              title: 'Daftar Feedback',
              color: currentColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedbackListPage()),
              ),
            ),
            const SizedBox(height: 10),
            _buildMenuButton(
              context,
              title: 'Profil Aplikasi / Tentang Kami',
              color: currentColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              '“Coding adalah seni memecahkan masalah dengan logika dan kreativitas.”',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: widget.isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Fungsi Pembuat Tombol Navigasi ===
  Widget _buildMenuButton(BuildContext context,
      {required String title,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
