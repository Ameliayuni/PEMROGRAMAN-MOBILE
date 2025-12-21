import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../widgets/transaction_card.dart';

class TransactionListSection extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onTapTransaction;

  const TransactionListSection({
    super.key,
    required this.transactions,
    required this.onTapTransaction,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada transaksi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan transaksi pertama Anda',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TransactionCard(
            transaction: transaction,
            onTap: () => onTapTransaction(transaction),
          ),
        );
      },
    );
  }
}