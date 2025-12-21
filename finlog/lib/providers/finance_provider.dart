// providers/finance_provider.dart
import 'package:flutter/material.dart';
import '../models/finance_model.dart';

class FinanceProvider extends ChangeNotifier {
  List<FinanceRecord> _records = [];
  
  List<FinanceRecord> get records => _records;
  
  // GET: Ambil semua data
  void loadRecords() {
    // Untuk demo, tambahkan data dummy
    _records = [
      FinanceRecord(
        id: '1',
        title: 'Gaji Bulanan',
        category: 'Gaji',
        amount: 5000000,
        date: DateTime.now(),
        type: 'income',
        notes: 'Gaji dari perusahaan',
      ),
      FinanceRecord(
        id: '2',
        title: 'Belanja Bulanan',
        category: 'Belanja',
        amount: 1500000,
        date: DateTime.now(),
        type: 'expense',
        notes: 'Belanja kebutuhan bulanan',
      ),
      FinanceRecord(
        id: '3',
        title: 'Bayar Listrik',
        category: 'Utilitas',
        amount: 500000,
        date: DateTime.now(),
        type: 'expense',
        notes: 'Tagihan listrik bulan November',
      ),
    ];
    notifyListeners();
  }
  
  // CREATE: Tambah data baru
  void addRecord(FinanceRecord record) {
    _records.add(record);
    notifyListeners();
  }
  
  // UPDATE: Edit data
  void updateRecord(String id, FinanceRecord updatedRecord) {
    final index = _records.indexWhere((record) => record.id == id);
    if (index != -1) {
      _records[index] = updatedRecord;
      notifyListeners();
    }
  }
  
  // DELETE: Hapus data
  void deleteRecord(String id) {
    _records.removeWhere((record) => record.id == id);
    notifyListeners();
  }
  
  // Hitung total pemasukan
  double get totalIncome {
    return _records
        .where((record) => record.type == 'income')
        .fold(0, (sum, record) => sum + record.amount);
  }
  
  // Hitung total pengeluaran
  double get totalExpense {
    return _records
        .where((record) => record.type == 'expense')
        .fold(0, (sum, record) => sum + record.amount);
  }
  
  // Hitung saldo
  double get balance {
    return totalIncome - totalExpense;
  }
}