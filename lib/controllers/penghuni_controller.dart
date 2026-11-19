import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/penghuni.dart';
import '../services/penghuni_service.dart';
import '../utils/format.dart';

class PenghuniController extends GetxController {
  final PenghuniService _service;
  PenghuniController(this._service);

  // State reaktif
  final daftar = <Penghuni>[].obs;
  final hanyaBelumLunas = false.obs;
  final kataKunci = ''.obs;

  @override
  void onInit() {
    super.onInit();
    muat();
  }

  void muat() => daftar.assignAll(_service.getAll());

  /// Daftar yang tampil: sudah kena filter belum lunas + pencarian.
  List<Penghuni> get tampil {
    final q = kataKunci.value.trim().toLowerCase();
    return daftar.where((p) {
      if (hanyaBelumLunas.value && p.lunas) return false;
      if (q.isEmpty) return true;
      return p.nama.toLowerCase().contains(q) ||
          p.noKamar.toLowerCase().contains(q) ||
          p.noHp.contains(q);
    }).toList();
  }

  /// Total biaya sewa yang belum lunas.
  double get totalTunggakan =>
      daftar.where((p) => !p.lunas).fold(0.0, (s, p) => s + p.biayaSewa);

  bool noKamarSudahAda(String v, {String? kecuali}) =>
      _service.noKamarSudahAda(v, kecuali: kecuali);

  // ---------- CREATE ----------
  Future<void> tambah(Penghuni p) async {
    await _service.create(p);
    muat();
    _sukses('Penghuni kamar ${p.noKamar} ditambahkan');
  }

  // ---------- UPDATE ----------
  Future<void> ubah(String noKamarLama, Penghuni baru) async {
    await _service.update(noKamarLama, baru);
    muat();
    _sukses('Data kamar ${baru.noKamar} diperbarui');
  }

  // ---------- DELETE (dengan dialog konfirmasi) ----------
  Future<void> hapus(Penghuni p) async {
    final ya = await _konfirmasi(
      judul: 'Hapus Penghuni',
      pesan: 'Hapus data ${p.nama} (kamar ${p.noKamar})?',
      tombolYa: 'Hapus',
    );
    if (ya != true) return;
    await _service.delete(p.noKamar);
    muat();
    _sukses('Data kamar ${p.noKamar} dihapus');
  }

  // ---------- FITUR KHUSUS: Tandai Lunas (dengan dialog konfirmasi) ----------
  Future<void> tandaiLunas(Penghuni p) async {
    final ya = await _konfirmasi(
      judul: 'Tandai Lunas',
      pesan:
          'Tandai sewa ${p.nama} (kamar ${p.noKamar}) sebesar ${rupiah.format(p.biayaSewa)} sebagai LUNAS?',
      tombolYa: 'Ya, Lunas',
    );
    if (ya != true) return;
    await _service.tandaiLunas(p.noKamar);
    muat();
    _sukses('Kamar ${p.noKamar} ditandai lunas');
  }

  Future<bool?> _konfirmasi({
    required String judul,
    required String pesan,
    required String tombolYa,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text(judul),
        content: Text(pesan),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: Text(tombolYa),
          ),
        ],
      ),
    );
  }

  void _sukses(String pesan) {
    Get.snackbar('Berhasil', pesan, snackPosition: SnackPosition.BOTTOM);
  }
}
