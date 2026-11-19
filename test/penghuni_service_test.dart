import 'dart:io';

import 'package:flutter_application_1/models/penghuni.dart';
import 'package:flutter_application_1/services/penghuni_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

Penghuni buat(String kamar, {String nama = 'Budi', bool lunas = false}) =>
    Penghuni(
      noKamar: kamar,
      nama: nama,
      noHp: '081234567890',
      biayaSewa: 750000,
      tanggalMasuk: DateTime(2026, 1, 15),
      lunas: lunas,
    );

void main() {
  late Directory dir;
  late Box<Penghuni> box;
  late PenghuniService service;

  setUpAll(() {
    dir = Directory.systemTemp.createTempSync('kos_test_');
    Hive.init(dir.path);
    Hive.registerAdapter(PenghuniAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<Penghuni>('box_${DateTime.now().microsecondsSinceEpoch}');
    service = PenghuniService(box);
  });

  tearDown(() async {
    await box.deleteFromDisk();
  });

  tearDownAll(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  test('create lalu read: data tersimpan dan bisa dibaca', () async {
    expect(service.getAll(), isEmpty);

    await service.create(buat('101'));
    await service.create(buat('102', nama: 'Sari'));

    final semua = service.getAll();
    expect(semua.length, 2);
    expect(service.getByNoKamar('102')!.nama, 'Sari');
    expect(service.getByNoKamar('101')!.lunas, false); // default false
  });

  test('create dengan no. kamar kembar ditolak', () async {
    await service.create(buat('101'));
    await expectLater(
        service.create(buat('101', nama: 'Lain')), throwsArgumentError);
    expect(service.getAll().length, 1);
  });

  test('update: mengubah data dan boleh mengganti no. kamar', () async {
    await service.create(buat('101'));

    await service.update('101', buat('101', nama: 'Budi Santoso'));
    expect(service.getByNoKamar('101')!.nama, 'Budi Santoso');

    await service.update('101', buat('105', nama: 'Budi Santoso'));
    expect(service.getByNoKamar('101'), isNull);
    expect(service.getByNoKamar('105')!.nama, 'Budi Santoso');
    expect(service.getAll().length, 1);
  });

  test('delete: data terhapus', () async {
    await service.create(buat('101'));
    await service.create(buat('102'));

    await service.delete('101');

    expect(service.getByNoKamar('101'), isNull);
    expect(service.getAll().length, 1);
  });

  test('tandaiLunas: status berubah menjadi lunas', () async {
    await service.create(buat('101'));
    await service.tandaiLunas('101');
    expect(service.getByNoKamar('101')!.lunas, true);
  });
}
