// models/finance_model.dart
class FinanceRecord {
  String id;
  String title;
  String category;
  double amount;
  DateTime date;
  String type; // 'income' atau 'expense'
  String? notes;

  FinanceRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'notes': notes,
    };
  }

  factory FinanceRecord.fromMap(Map<String, dynamic> map) {
    return FinanceRecord(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: DateTime.parse(map['date']),
      type: map['type'] ?? 'expense',
      notes: map['notes'],
    );
  }
}