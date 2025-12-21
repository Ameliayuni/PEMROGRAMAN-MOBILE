// lib/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final DateTime? createdAt;
  final String? paymentMethod;
  final String? notes;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
    this.paymentMethod,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'category': category,
      'date': Timestamp.fromDate(date),
      'notes': notes,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  factory Transaction.fromFirestore(String id, Map<String, dynamic> data) {
    DateTime? created;
    if (data['createdAt'] is Timestamp) {
      created = (data['createdAt'] as Timestamp).toDate();
    }

    return Transaction(
      id: id,
      title: data['title'] as String,
      amount: (data['amount'] as num).toDouble(),
      type: (data['type'] as String) == 'income' ? TransactionType.income : TransactionType.expense,
      category: data['category'] as String,
      date: (data['date'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String?,
      createdAt: created,
      notes: data['notes'] as String?,
    );
  }

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
    String? notes,
    String? paymentMethod,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum TransactionType { income, expense }