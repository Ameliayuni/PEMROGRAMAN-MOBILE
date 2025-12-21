// lib/providers/transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  
  // Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  TransactionProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();
      
      _transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return Transaction.fromFirestore(doc.id, data);
      }).toList();
      
      print('✅ Loaded ${_transactions.length} transactions from Firebase');
    } catch (e) {
      print('❌ Error loading transactions: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add(transaction.toFirestore());
      
      // Add local dengan ID dari Firebase
      transaction = transaction.copyWith(id: docRef.id);
      _transactions.insert(0, transaction);
      
      print('✅ Transaction added to Firebase: ${transaction.title}');
    } catch (e) {
      print('❌ Error adding transaction: $e');
      rethrow;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toFirestore());
      
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
      }
      
      print('✅ Transaction updated in Firebase: ${transaction.title}');
    } catch (e) {
      print('❌ Error updating transaction: $e');
      rethrow;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transactionId)
          .delete();
      
      _transactions.removeWhere((t) => t.id == transactionId);
      
      print('✅ Transaction deleted from Firebase: $transactionId');
    } catch (e) {
      print('❌ Error deleting transaction: $e');
      rethrow;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  // Helper methods
  List<Transaction> getTransactionsForDate(DateTime date) {
    return _transactions.where((t) {
      return t.date.year == date.year && t.date.month == date.month && t.date.day == date.day;
    }).toList();
  }

  double getTotalIncome(List<Transaction> list) {
    return list.where((t) => t.type == TransactionType.income).fold(0.0, (s, t) => s + t.amount);
  }

  double getTotalExpense(List<Transaction> list) {
    return list.where((t) => t.type == TransactionType.expense).fold(0.0, (s, t) => s + t.amount);
  }
}