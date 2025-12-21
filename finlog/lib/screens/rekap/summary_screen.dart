import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';
import '../../providers/theme_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap'),
        backgroundColor: isDarkMode ? Colors.grey[900] : const Color.fromARGB(255, 153, 202, 235),
        foregroundColor: isDarkMode ? const Color.fromARGB(255, 153, 202, 235) : Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, 
            color: isDarkMode ? const Color.fromARGB(255, 175, 217, 241) : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color.fromARGB(255, 255, 255, 255),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          final transactions = transactionProvider.transactions;
          
          // Hitung total pemasukan dan pengeluaran
          final totalIncome = transactions
              .where((t) => t.type == TransactionType.income)
              .fold(0.0, (sum, t) => sum + t.amount);
              
          final totalExpense = transactions
              .where((t) => t.type == TransactionType.expense)
              .fold(0.0, (sum, t) => sum + t.amount);
          
          final balance = totalIncome - totalExpense;
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ringkasan
                Card(
                  elevation: 2,
                  color: isDarkMode ? const Color.fromARGB(255, 255, 254, 254) : const Color.fromARGB(255, 170, 210, 236),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Ringkasan Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? const Color.fromARGB(255, 251, 253, 255) : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem('Pemasukan', totalIncome, Colors.green, isDarkMode),
                            _buildSummaryItem('Pengeluaran', totalExpense, Colors.red, isDarkMode),
                            _buildSummaryItem('Saldo', balance, 
                                balance >= 0 ? const Color.fromARGB(255, 111, 192, 240) : Colors.red, isDarkMode),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Statistik bulanan dengan latar belakang biru
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color.fromARGB(255, 168, 197, 241) : const Color.fromARGB(255, 191, 212, 240), // Warna biru
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistik Bulan Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Konten transaksi bulan ini
                      if (transactions.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Belum ada transaksi bulan ini',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: transactions.take(3).map((transaction) => // Tampilkan maksimal 3 transaksi
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: transaction.type == TransactionType.income
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      transaction.type == TransactionType.income
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: transaction.type == TransactionType.income
                                          ? Colors.green[300]
                                          : Colors.red[300],
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transaction.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${transaction.category} • ${_formatDate(transaction.date)}',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${transaction.type == TransactionType.income ? '+' : '-'}Rp ${transaction.amount.toStringAsFixed(0).replaceAllMapped(
                                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                      (Match m) => '${m[1]}.',
                                    )}',
                                    style: TextStyle(
                                      color: transaction.type == TransactionType.income
                                          ? Colors.green[300]
                                          : Colors.red[300],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ).toList(),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Label untuk daftar lengkap
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Text(
                    'Semua Transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? const Color.fromARGB(255, 156, 203, 235) : Colors.black,
                    ),
                  ),
                ),
                
                // Daftar transaksi lengkap
                Expanded(
                  child: transactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart, 
                                size: 64, 
                                color: isDarkMode ? Colors.grey[600] : Colors.grey
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada data transaksi',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: isDarkMode ? Colors.grey[800] : Colors.white,
                              elevation: 1,
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: transaction.type == TransactionType.income
                                        ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
                                        : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    transaction.type == TransactionType.income
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: transaction.type == TransactionType.income
                                        ? Colors.green
                                        : Colors.red,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  transaction.title,
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  '${transaction.category} • ${_formatDate(transaction.date)}',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                                trailing: Text(
                                  '${transaction.type == TransactionType.income ? '+' : '-'}Rp ${transaction.amount.toStringAsFixed(0).replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]}.',
                                  )}',
                                  style: TextStyle(
                                    color: transaction.type == TransactionType.income
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String title, double amount, Color color, bool isDarkMode) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}