import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';

class TransactionListScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(Transaction)? onTapTransaction;

  const TransactionListScreen({super.key, required this.transactions, this.onTapTransaction});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long, size: 72, color: Colors.grey),
            SizedBox(height: 12),
            Text('Tidak ada transaksi', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isIncome = tx.type == TransactionType.income;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.green : Colors.red),
          ),
          title: Text(tx.title),
          subtitle: Text(tx.category),
          trailing: Text(tx.amount.toStringAsFixed(0), style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
          onTap: () => onTapTransaction?.call(tx),
        );
      },
    );
  }
}
