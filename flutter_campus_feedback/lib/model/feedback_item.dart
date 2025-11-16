// lib/model/feedback_item.dart
class FeedbackItem {
  final String nama;
  final String nim;
  final String fakultas;
  final List<String> fasilitas;
  final double nilaiKepuasan;
  final String jenisFeedback; // "Pesan Opsional"
  final String? pesan;
  final bool setuju;
  final DateTime createdAt;

  FeedbackItem({
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.fasilitas,
    required this.nilaiKepuasan,
    required this.jenisFeedback,
    this.pesan,
    required this.setuju,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// Storage sederhana in-memory supaya daftar feedback persist saat navigasi.
class FeedbackStorage {
  static final List<FeedbackItem> _items = [];

  static List<FeedbackItem> get items => List.unmodifiable(_items);

  static void add(FeedbackItem item) {
    _items.add(item);
  }

  static void remove(FeedbackItem item) {
    _items.remove(item);
  }

  static void clear() {
    _items.clear();
  }
}
