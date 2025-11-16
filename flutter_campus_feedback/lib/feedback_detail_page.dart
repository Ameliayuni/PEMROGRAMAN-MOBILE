// lib/feedback_detail_page.dart
import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem item;
  const FeedbackDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Feedback'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${item.nama}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('NIM: ${item.nim}'),
            const SizedBox(height: 6),
            Text('Fakultas: ${item.fakultas}'),
            const SizedBox(height: 6),
            Text('Fasilitas: ${item.fasilitas.isEmpty ? "-" : item.fasilitas.join(", ")}'),
            const SizedBox(height: 6),
            Text('Nilai Kepuasan: ${item.nilaiKepuasan.toStringAsFixed(1)}'),
            const SizedBox(height: 6),
            Text('Jenis Feedback: ${item.jenisFeedback}'),
            const SizedBox(height: 6),
            Text('Pesan: ${item.pesan == null || item.pesan!.isEmpty ? "-" : item.pesan}'),
            const SizedBox(height: 6),
            Text('Setuju Syarat & Ketentuan: ${item.setuju ? "Ya" : "Tidak"}'),
            const SizedBox(height: 12),
            Text('Dibuat: ${item.createdAt.toLocal()}'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 54, 158, 244),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Hapus Feedback'),
                        content: const Text('Yakin ingin menghapus feedback ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              FeedbackStorage.remove(item);
                              Navigator.pop(context); // tutup dialog
                              Navigator.pop(context, 'deleted'); // kembali ke list dan beri hasil
                            },
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
