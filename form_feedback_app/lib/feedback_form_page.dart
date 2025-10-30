import 'package:flutter/material.dart';
import 'feedback_result_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _komentarController = TextEditingController();
  double _rating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Feedback'),
        backgroundColor: const Color.fromARGB(255, 52, 125, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama:', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama Anda',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 45, 140, 196),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (_) => setState(() {}), // real-time update
              ),
              const SizedBox(height: 20),

              const Text('Komentar:', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _komentarController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Masukkan komentar Anda',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 103, 190, 224),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (_) => setState(() {}), // real-time update
              ),
              const SizedBox(height: 20),

              Text('Rating (1–5): ${_rating.toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _rating,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: const Color.fromARGB(255, 77, 143, 230),
                label: _rating.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    _rating = value; // update real-time rating
                  });
                },
              ),
              const SizedBox(height: 30),

              // 👇 Preview real-time feedback
              Card(
                color: const Color.fromARGB(255, 53, 150, 196),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Preview Feedback Anda:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      Text("Nama: ${_namaController.text.isEmpty ? '-' : _namaController.text}"),
                      Text("Komentar: ${_komentarController.text.isEmpty ? '-' : _komentarController.text}"),
                      Text("Rating: ${_rating.toInt()} / 5"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 35, 166, 199),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_namaController.text.isEmpty ||
                        _komentarController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nama dan komentar tidak boleh kosong!'),
                          backgroundColor: Color.fromARGB(255, 37, 180, 216),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackResultPage(
                            nama: _namaController.text,
                            komentar: _komentarController.text,
                            rating: _rating.toInt(),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Kirim Feedback',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
