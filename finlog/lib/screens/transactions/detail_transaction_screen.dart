import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class DetailTransactionScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const DetailTransactionScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // Format mata uang sesuai locale yang dipilih
    final currencyFormat = NumberFormat.currency(
      locale: themeProvider.languageCode == 'id' ? 'id_ID' : 'en_US',
      symbol: themeProvider.languageCode == 'id' ? 'Rp ' : '\$ ',
      decimalDigits: 0,
    );

    // Mengambil data dari map transaksi
    final String title = transaction['title'] ?? '-';
    final double amount = (transaction['amount'] ?? 0).toDouble();
    final String type = transaction['type'] ?? 'expense'; // income atau expense
    final DateTime date = DateTime.parse(transaction['date'] ?? DateTime.now().toString());
    final String category = transaction['category'] ?? 'General';

    return Scaffold(
      appBar: AppBar(
        title: Text(themeProvider.languageCode == 'id' ? 'Detail Transaksi' : 'Transaction Details'),
        backgroundColor: themeProvider.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER JUMLAH ---
            Center(
              child: Column(
                children: [
                  Text(
                    themeProvider.languageCode == 'id' ? 'Total Nominal' : 'Total Amount',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(amount),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: type == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- KARTU INFORMASI ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
              ),
            ),
            
            _buildDetailItem(
              context,
              label: themeProvider.languageCode == 'id' ? 'Keterangan' : 'Description',
              value: title,
              icon: Icons.title,
            ),
            const Divider(),
            _buildDetailItem(
              context,
              label: themeProvider.languageCode == 'id' ? 'Kategori' : 'Category',
              value: category,
              icon: Icons.category,
            ),
            const Divider(),
            _buildDetailItem(
              context,
              label: themeProvider.languageCode == 'id' ? 'Tanggal' : 'Date',
              value: DateFormat.yMMMMEEEEd(themeProvider.languageCode).format(date),
              icon: Icons.calendar_today,
            ),
            const Divider(),
            _buildDetailItem(
              context,
              label: themeProvider.languageCode == 'id' ? 'Tipe' : 'Type',
              value: type == 'income' 
                  ? (themeProvider.languageCode == 'id' ? 'Pemasukan' : 'Income')
                  : (themeProvider.languageCode == 'id' ? 'Pengeluaran' : 'Expense'),
              icon: type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
              valueColor: type == 'income' ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk baris detail
  Widget _buildDetailItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}