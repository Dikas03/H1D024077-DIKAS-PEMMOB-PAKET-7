import 'package:hive/hive.dart';

class Penghuni {
  final String noKamar;
  final String nama;
  final String noHp;
  final double biayaSewa;
  final DateTime tanggalMasuk;
  final bool lunas;

  Penghuni({
    required this.noKamar,
    required this.nama,
    required this.noHp,
    required this.biayaSewa,
    required this.tanggalMasuk,
    this.lunas = false,
  });

  Penghuni copyWith({
    String? noKamar,
    String? nama,
    String? noHp,
    double? biayaSewa,
    DateTime? tanggalMasuk,
    bool? lunas,
  }) =>
      Penghuni(
        noKamar: noKamar ?? this.noKamar,
        nama: nama ?? this.nama,
        noHp: noHp ?? this.noHp,
        biayaSewa: biayaSewa ?? this.biayaSewa,
        tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
        lunas: lunas ?? this.lunas,
      );
}

/// TypeAdapter ditulis manual (tanpa build_runner). typeId harus unik.
class PenghuniAdapter extends TypeAdapter<Penghuni> {
  @override
  final int typeId = 1;

  @override
  Penghuni read(BinaryReader reader) {
    final jumlah = reader.readByte();
    final f = <int, dynamic>{
      for (int i = 0; i < jumlah; i++) reader.readByte(): reader.read(),
    };
    return Penghuni(
      noKamar: f[0] as String,
      nama: f[1] as String,
      noHp: f[2] as String,
      biayaSewa: f[3] as double,
      tanggalMasuk: f[4] as DateTime,
      lunas: f[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Penghuni obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.noKamar)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.noHp)
      ..writeByte(3)
      ..write(obj.biayaSewa)
      ..writeByte(4)
      ..write(obj.tanggalMasuk)
      ..writeByte(5)
      ..write(obj.lunas);
  }
}
