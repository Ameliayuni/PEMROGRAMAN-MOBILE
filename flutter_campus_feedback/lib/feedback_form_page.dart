// lib/feedback_form_page.dart
import 'package:flutter/material.dart';
import 'model/feedback_item.dart';
import 'feedback_list_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _nama = '';
  String _nim = '';
  String? _fakultas;
  final List<String> _selectedFasilitas = [];
  double _nilaiKepuasan = 3;
  String _jenisFeedback = 'Saran';
  String? _pesan;
  bool _setuju = false;

  final List<String> _fakultasList = [
    'FST',
    'FEB',
    'FSH',
    'FUAD',
    'FDK',
  ];

  final List<String> _fasilitasList = [
    'Ruang Kelas',
    'Laboratorium',
    'Perpustakaan',
    'Kantin',
    'Toilet',
    'Akses Internet',
  ];

  void _trySave() {
    // validasi field wajib
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      // form not valid, tunjukkan snackbar atau biarkan field menampilkan validator
      return;
    }

    // jika switch belum aktif, tampilkan AlertDialog konfirmasi sesuai spesifikasi
    if (!_setuju) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Setuju Syarat & Ketentuan'),
          content: const Text(
              'Anda belum mengaktifkan "Setuju Syarat & Ketentuan". Apakah ingin mengaktifkannya agar dapat menyimpan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // tutup dialog, jangan lanjut
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // aktifkan dan lanjut simpan
                setState(() {
                  _setuju = true;
                });
                Navigator.of(context).pop();
                _saveAndNavigate();
              },
              child: const Text('Aktifkan & Simpan'),
            ),
          ],
        ),
      );
      return;
    }

    // jika semua valid dan setuju true, simpan
    _saveAndNavigate();
  }

  void _saveAndNavigate() {
    _formKey.currentState?.save();

    final item = FeedbackItem(
      nama: _nama.trim(),
      nim: _nim.trim(),
      fakultas: _fakultas ?? '',
      fasilitas: List.from(_selectedFasilitas),
      nilaiKepuasan: _nilaiKepuasan,
      jenisFeedback: _jenisFeedback,
      pesan: _pesan?.trim(),
      setuju: _setuju,
    );

    // simpan ke storage in-memory
    FeedbackStorage.add(item);

    // Navigasi ke FeedbackListPage dan kirim object melalui konstruktor (sesuai permintaan)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeedbackListPage(newItem: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback Mahasiswa'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Nama
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Mahasiswa'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                  onSaved: (v) => _nama = v ?? '',
                ),
                const SizedBox(height: 12),

                // NIM (number input)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'NIM'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                    final numValue = int.tryParse(v.trim());
                    if (numValue == null) return 'Isi dengan angka';
                    return null;
                  },
                  onSaved: (v) => _nim = v ?? '',
                ),
                const SizedBox(height: 12),

                // Fakultas DropdownButtonFormField
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Fakultas'),
                  items: _fakultasList
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  value: _fakultas,
                  onChanged: (v) => setState(() => _fakultas = v),
                  validator: (v) => v == null || v.isEmpty ? 'Pilih fakultas' : null,
                  onSaved: (v) => _fakultas = v,
                ),
                const SizedBox(height: 12),

                // Fasilitas yang Dinilai (CheckboxListTile multiple)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Fasilitas yang Dinilai',
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                Column(
                  children: _fasilitasList
                      .map(
                        (f) => CheckboxListTile(
                          title: Text(f),
                          value: _selectedFasilitas.contains(f),
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                if (!_selectedFasilitas.contains(f)) {
                                  _selectedFasilitas.add(f);
                                }
                              } else {
                                _selectedFasilitas.remove(f);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Nilai Kepuasan (Slider 1-5)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Nilai Kepuasan: ${_nilaiKepuasan.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                Slider(
                  value: _nilaiKepuasan,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _nilaiKepuasan.round().toString(),
                  onChanged: (v) => setState(() => _nilaiKepuasan = v),
                ),
                const SizedBox(height: 12),

                // Jenis Feedback (RadioListTile)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Jenis Feedback',
                      style: Theme.of(context).textTheme.labelLarge),
                ),
                Column(
                  children: ['Saran', 'Keluhan', 'Apresiasi']
                      .map(
                        (type) => RadioListTile<String>(
                          title: Text(type),
                          value: type,
                          groupValue: _jenisFeedback,
                          onChanged: (v) => setState(() => _jenisFeedback = v!),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Pesan tambahan (optional)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Pesan opsional',
                  ),
                  maxLines: 3,
                  onSaved: (v) => _pesan = v,
                ),
                const SizedBox(height: 12),

                // Switch Setuju Syarat & Ketentuan
                SwitchListTile(
                  title: const Text('Setuju Syarat & Ketentuan'),
                  subtitle: const Text('Harus aktif sebelum menyimpan'),
                  value: _setuju,
                  onChanged: (v) => setState(() => _setuju = v),
                ),
                const SizedBox(height: 12),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _trySave,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Simpan Feedback'),
                    ),
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
