// lib/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import '../models/transaction_model.dart'; // Transaction bukan TransactionModel
import '../utils/formatters.dart';
import '../utils/constants.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction; // Ganti TransactionModel dengan Transaction
  final VoidCallback onTap; // Ubah onLongPress menjadi onTap untuk konsistensi
  final VoidCallback? onLongPress; // Tambahkan optional onLongPress

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: CircleAvatar(
          backgroundColor: isIncome 
              ? AppColors.income.withOpacity(0.1) 
              : AppColors.expense.withOpacity(0.1),
          child: Icon(
            isIncome 
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: isIncome ? AppColors.income : AppColors.expense,
            size: 20,
          ),
        ),
        title: Text(
          transaction.title, // Ganti transaction.title dengan transaction.description
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Formatters.formatDate(transaction.date),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.toRupiah(transaction.amount),
              style: TextStyle(
                color: isIncome ? AppColors.income : AppColors.expense,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isIncome ? "Pemasukan" : "Pengeluaran",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }
}