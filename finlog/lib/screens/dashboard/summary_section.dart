import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummarySection extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;

  const SummarySection({super.key, required this.income, required this.expense, required this.balance});

  String _formatCurrency(double value) {
    final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return f.format(value);
  }

  Widget _statCard(String label, String amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statCard('Pemasukan', _formatCurrency(income), Colors.green),
          _statCard('Pengeluaran', _formatCurrency(expense), Colors.red),
          _statCard('Saldo', _formatCurrency(balance), balance >= 0 ? Colors.blue : Colors.red),
        ],
      ),
    );
  }
}
