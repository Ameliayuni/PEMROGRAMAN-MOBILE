import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isDarkMode = themeProvider.isDarkMode;
    
    // Warna tema biru langit
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).colorScheme.background;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    
    // Ambil data user dari auth provider
    final userInfo = authProvider.getUserInfo();
    final userName = userInfo['name'] ?? 'Pengguna';
    final userEmail = userInfo['email'] ?? 'email@example.com';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Header Profil Pengguna
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                    : [const Color(0xFF87CEEB), const Color(0xFFB0E2FF)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Avatar dengan border gradient - GUNAKAN LOGO ANDA
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/finlog_logo.png', // LOGO ANDA DI SINI
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback jika logo tidak ditemukan
                          return Icon(
                            Icons.person,
                            size: 45,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Nama Pengguna
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Email Pengguna
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Tombol Edit Profil
                OutlinedButton.icon(
                  onPressed: () {
                    _showProfileDialog(context, isDarkMode, authProvider);
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Edit Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // List Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Dark Mode Toggle
                Card(
                  elevation: 2,
                  color: surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Ubah tema aplikasi',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.1),
                            primaryColor.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    value: isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    activeColor: primaryColor,
                  ),
                ),
                
                const SizedBox(height: 16),

                // Tentang Aplikasi
                Card(
                  elevation: 2,
                  color: surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.1),
                            Colors.blue.withOpacity(0.2),
                        ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.info,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      'Versi 1.0.0',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: () {
                      _showAboutDialog(context, isDarkMode);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),

                // Keluar Akun
                Card(
                  elevation: 2,
                  color: surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.1),
                            Colors.red.withOpacity(0.2),
                        ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Keluar Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      'Keluar dari aplikasi',
                      style: TextStyle(
                        color: Colors.red.withOpacity(0.7),
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.red.withOpacity(0.5),
                    ),
                    onTap: () {
                      _showLogoutDialog(context, isDarkMode, authProvider);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context, bool isDarkMode, AuthProvider authProvider) {
    final userInfo = authProvider.getUserInfo();
    final TextEditingController nameController = TextEditingController(text: userInfo['name']);
    
    showDialog(
      context: context,
      builder: (context) {
        final primaryColor = Theme.of(context).primaryColor;
        
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.edit,
                color: primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar di dialog - GUNAKAN LOGO ANDA
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/.finlog_logo.png', // LOGO ANDA DI SINI
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                
                // Field Nama
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: primaryColor.withOpacity(0.7),
                    ),
                    filled: isDarkMode,
                    fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[50],
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Info Email (read-only)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userInfo['email'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.info,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Email tidak dapat diubah',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Tombol Batal
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            
            // Tombol Simpan
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Nama tidak boleh kosong'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                  return;
                }

                final result = await authProvider.updateProfile(
                  name: nameController.text.trim(),
                );
                
                if (result['success']) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profil berhasil diperbarui',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Gagal: ${result['message']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        final primaryColor = Theme.of(context).primaryColor;
        
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info,
                color: primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOGO APLIKASI ANDA - BESAR
                Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      isDarkMode && 
                      _logoExists('assets/images/finlog_logo.png') // Jika ada logo putih untuk dark mode
                        ? 'assets/images/finlog_logo.png'
                        : 'assets/images/finlog_logo.png', // LOGO ANDA DI SINI
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback jika logo tidak ditemukan
                        return Icon(
                          Icons.account_balance_wallet,
                          size: 60,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                
                // Nama Aplikasi
                Text(
                  'FinLog',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Versi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Versi 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Deskripsi
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Aplikasi:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Aplikasi untuk melacak keuangan pribadi dengan mudah dan efisien. '
                      'Pantau pemasukan dan pengeluaran Anda setiap hari.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      'Fitur Utama:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // List Fitur dengan icon
                    Column(
                      children: [
                        _buildFeatureItem(
                          context,
                          Icons.receipt_long,
                          'Catat transaksi harian',
                          isDarkMode,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.trending_up,
                          'Pantau pemasukan & pengeluaran',
                          isDarkMode,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.summarize,
                          'Ringkasan keuangan',
                          isDarkMode,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.dark_mode,
                          'Dark Mode',
                          isDarkMode,
                        ),
                        _buildFeatureItem(
                          context,
                          Icons.person,
                          'Profil pengguna',
                          isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Copyright
                Text(
                  '© 2025 FinLog App',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper untuk mengecek apakah logo ada
  bool _logoExists(String path) {
    // Ini hanya simulasi, di aplikasi sebenarnya perlu pengecekan file
    // Anda bisa implementasi pengecekan file jika perlu
    return true; // Ganti dengan logika pengecekan file
  }

  // Helper untuk membuat item fitur
  Widget _buildFeatureItem(BuildContext context, IconData icon, String text, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[300] : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDarkMode, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(
              'Konfirmasi Keluar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.exit_to_app,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Apakah Anda yakin ingin keluar dari akun?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          // Tombol Batal
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Tombol Keluar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              await authProvider.logout();
              
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Keluar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}