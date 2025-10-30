import 'package:flutter/material.dart';

class FeedbackResultPage extends StatelessWidget {
  final String nama;
  final String komentar;
  final int rating;

  const FeedbackResultPage({
    super.key,
    required this.nama,
    required this.komentar,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Feedback'),
        backgroundColor: const Color.fromARGB(255, 136, 128, 255),
      ),
      body: Center(
        child: Card(
          color: Colors.pink.shade50,
          elevation: 5,
          margin: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nama: $nama',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('Komentar: $komentar',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Rating: $rating / 5',
                    style: TextStyle(
                        fontSize: 16, color: const Color.fromARGB(255, 70, 108, 177))),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 128, 187, 255),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
