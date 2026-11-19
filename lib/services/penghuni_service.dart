import 'package:hive/hive.dart';

import '../models/penghuni.dart';

/// Satu-satunya lapisan yang mengakses Hive.
class PenghuniService {
  static const boxName = 'penghuni_box';

  final Box<Penghuni> _box;
  PenghuniService(this._box);

  List<Penghuni> getAll() {
    final list = _box.values.toList();
    list.sort((a, b) =>
        a.noKamar.toLowerCase().compareTo(b.noKamar.toLowerCase()));
    return list;
  }

  Penghuni? getByNoKamar(String noKamar) => _box.get(noKamar);

  /// Cek keunikan no. kamar (tidak peka huruf besar/kecil).
  /// [kecuali] dipakai saat edit agar data sendiri tidak dianggap kembar.
  bool noKamarSudahAda(String noKamar, {String? kecuali}) {
    final n = noKamar.trim().toLowerCase();
    return _box.keys.any((k) {
      final key = k.toString();
      return key.toLowerCase() == n && key != kecuali;
    });
  }

  Future<void> create(Penghuni p) async {
    if (noKamarSudahAda(p.noKamar)) {
      throw ArgumentError('No. kamar ${p.noKamar} sudah dipakai');
    }
    await _box.put(p.noKamar, p);
  }

  Future<void> update(String noKamarLama, Penghuni baru) async {
    if (!_box.containsKey(noKamarLama)) {
      throw StateError('Data kamar $noKamarLama tidak ditemukan');
    }
    if (noKamarSudahAda(baru.noKamar, kecuali: noKamarLama)) {
      throw ArgumentError('No. kamar ${baru.noKamar} sudah dipakai');
    }
    if (baru.noKamar != noKamarLama) {
      await _box.delete(noKamarLama);
    }
    await _box.put(baru.noKamar, baru);
  }

  Future<void> delete(String noKamar) => _box.delete(noKamar);

  Future<void> tandaiLunas(String noKamar) async {
    final p = _box.get(noKamar);
    if (p == null) {
      throw StateError('Data kamar $noKamar tidak ditemukan');
    }
    await _box.put(noKamar, p.copyWith(lunas: true));
  }
}
