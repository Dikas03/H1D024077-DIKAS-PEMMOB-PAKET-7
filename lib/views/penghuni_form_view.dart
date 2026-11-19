import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/penghuni_controller.dart';
import '../models/penghuni.dart';
import '../utils/format.dart';

class PenghuniFormView extends StatefulWidget {
  const PenghuniFormView({super.key});

  @override
  State<PenghuniFormView> createState() => _PenghuniFormViewState();
}

class _PenghuniFormViewState extends State<PenghuniFormView> {
  final c = Get.find<PenghuniController>();
  final _formKey = GlobalKey<FormState>();

  late final Penghuni? _lama;
  late final TextEditingController _kamarC;
  late final TextEditingController _namaC;
  late final TextEditingController _hpC;
  late final TextEditingController _biayaC;
  DateTime? _tanggal;
  bool _lunas = false;
  String? _errorTanggal;

  bool get _edit => _lama != null;

  @override
  void initState() {
    super.initState();
    _lama = Get.arguments as Penghuni?;
    final p = _lama;
    _kamarC = TextEditingController(text: p?.noKamar ?? '');
    _namaC = TextEditingController(text: p?.nama ?? '');
    _hpC = TextEditingController(text: p?.noHp ?? '');
    _biayaC = TextEditingController(
        text: p != null ? p.biayaSewa.toStringAsFixed(0) : '');
    _tanggal = p?.tanggalMasuk;
    _lunas = p?.lunas ?? false; // default false
  }

  @override
  void dispose() {
    _kamarC.dispose();
    _namaC.dispose();
    _hpC.dispose();
    _biayaC.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (hasil != null) {
      setState(() {
        _tanggal = hasil;
        _errorTanggal = null;
      });
    }
  }

  Future<void> _simpan() async {
    final formValid = _formKey.currentState!.validate();
    if (_tanggal == null) {
      setState(() => _errorTanggal = 'Tanggal masuk wajib dipilih');
    }
    if (!formValid || _tanggal == null) return;

    final baru = Penghuni(
      noKamar: _kamarC.text.trim(),
      nama: _namaC.text.trim(),
      noHp: _hpC.text.trim(),
      biayaSewa: double.parse(_biayaC.text.trim()),
      tanggalMasuk: _tanggal!,
      lunas: _lunas,
    );

    if (_edit) {
      await c.ubah(_lama!.noKamar, baru);
    } else {
      await c.tambah(baru);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_edit ? 'Edit Penghuni' : 'Tambah Penghuni'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _kamarC,
              decoration: const InputDecoration(
                  labelText: 'No. Kamar', border: OutlineInputBorder()),
              validator: (v) {
                final nilai = (v ?? '').trim();
                if (nilai.isEmpty) return 'No. kamar wajib diisi';
                if (c.noKamarSudahAda(nilai, kecuali: _lama?.noKamar)) {
                  return 'No. kamar sudah dipakai';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaC,
              decoration: const InputDecoration(
                  labelText: 'Nama', border: OutlineInputBorder()),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hpC,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  labelText: 'No. HP', border: OutlineInputBorder()),
              validator: (v) {
                final nilai = (v ?? '').trim();
                if (nilai.isEmpty) return 'No. HP wajib diisi';
                if (!RegExp(r'^\d{10,13}$').hasMatch(nilai)) {
                  return 'Hanya angka, 10-13 digit';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _biayaC,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  labelText: 'Biaya Sewa',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder()),
              validator: (v) {
                final angka = double.tryParse((v ?? '').trim());
                if (angka == null) return 'Biaya sewa wajib diisi';
                if (angka <= 0) return 'Biaya sewa harus lebih dari 0';
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pilihTanggal,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal Masuk',
                  border: const OutlineInputBorder(),
                  errorText: _errorTanggal,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(_tanggal == null
                    ? 'Pilih tanggal'
                    : formatTanggal.format(_tanggal!)),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Sudah lunas'),
              value: _lunas,
              onChanged: (v) => setState(() => _lunas = v),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _simpan,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_edit ? 'Simpan Perubahan' : 'Simpan'),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Batal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}