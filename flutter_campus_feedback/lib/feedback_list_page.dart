// lib/feedback_list_page.dart
import 'package:flutter/material.dart';
import 'feedback_detail_page.dart';
import 'model/feedback_item.dart';

class FeedbackListPage extends StatefulWidget {
  final FeedbackItem? newItem;

  const FeedbackListPage({super.key, this.newItem});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<FeedbackItem> _list = [];

  @override
  void initState() {
    super.initState();
    _list = List.from(FeedbackStorage.items);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _list = List.from(FeedbackStorage.items);
    });
  }

  IconData _iconForType(String jenis) {
    switch (jenis) {
      case 'Apresiasi':
        return Icons.celebration;
      case 'Keluhan':
        return Icons.report_problem;
      default:
        return Icons.lightbulb;
    }
  }

  Color _colorForType(String jenis, BuildContext context) {
    switch (jenis) {
      case 'Apresiasi':
        return Colors.green;
      case 'Keluhan':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Feedback'),
        centerTitle: true,
      ),
      body: _list.isEmpty
          ? const Center(
              child: Text(
                'Belum ada feedback.\nSilakan tambahkan melalui Formulir Feedback.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (_, i) {
                final f = _list[_list.length - 1 - i]; // terbaru di atas
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          _colorForType(f.jenisFeedback, context).withOpacity(0.15),
                      child: Icon(
                        _iconForType(f.jenisFeedback),
                        color: _colorForType(f.jenisFeedback, context),
                      ),
                    ),
                    title: Text(f.nama),
                    subtitle: Text(
                        'Fakultas: ${f.fakultas} • Nilai: ${f.nilaiKepuasan.toStringAsFixed(1)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FeedbackDetailPage(item: f)),
                      );
                      if (result == 'deleted') {
                        setState(() {
                          _list = List.from(FeedbackStorage.items);
                        });
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
