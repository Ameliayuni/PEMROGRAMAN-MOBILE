import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // Singleton (disarankan untuk service)
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService() => instance;

  // Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  SharedPreferences? _prefs;

  /// Wajib dipanggil sekali (misalnya di main atau provider)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    debugPrint('DatabaseService initialized (Firestore & SharedPreferences)');
  }

  // =========================
  // SharedPreferences (Theme)
  // =========================

  Future<void> saveThemeColor(int colorIndex) async {
    await _ensurePrefsReady();
    await _prefs!.setInt('themeColor', colorIndex);
  }

  int getThemeColor() {
    if (_prefs == null) return 0;
    return _prefs!.getInt('themeColor') ?? 0;
  }

  // =========================
  // Firestore - Transactions
  // =========================

  Future<void> insertTransaction(Map<String, dynamic> data) async {
    try {
      await _db.collection('transactions').add(data);
    } catch (e, s) {
      debugPrint('Firestore Insert Error: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactionsStream() {
    return _db
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> updateTransaction(
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _db.collection('transactions').doc(documentId).update(data);
    } catch (e, s) {
      debugPrint('Firestore Update Error: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<void> deleteTransaction(String documentId) async {
    try {
      await _db.collection('transactions').doc(documentId).delete();
    } catch (e, s) {
      debugPrint('Firestore Delete Error: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  // =========================
  // Internal helper
  // =========================

  Future<void> _ensurePrefsReady() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }
}
