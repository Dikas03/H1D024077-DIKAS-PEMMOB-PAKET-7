import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'kartu_tunggakan.dart';
import '../controllers/penghuni_controller.dart';
import '../models/penghuni.dart';
import '../routes/app_routes.dart';
import '../utils/format.dart';

class PenghuniListView extends GetView<PenghuniController> {
  const PenghuniListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.form),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          // FITUR KHUSUS 3: total tunggakan di atas 
                    Obx(() => KartuTunggakan(total: controller.totalTunggakan)),
          // Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              onChanged: (v) => controller.kataKunci.value = v,
              decoration: const InputDecoration(
                hintText: 'Cari nama, no. kamar, atau no. HP',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          // FITUR KHUSUS 1: filter belum lunas
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Obx(() => Row(
                  children: [
                    FilterChip(
                      label: const Text('Belum lunas saja'),
                      selected: controller.hanyaBelumLunas.value,
                      onSelected: (v) => controller.hanyaBelumLunas.value = v,
                    ),
                    const Spacer(),
                    Text('${controller.tampil.length} penghuni'),
                  ],
                )),
          ),
          Expanded(
            child: Obx(() {
              final data = controller.tampil;
              if (data.isEmpty) {
                return _kosong(controller.daftar.isEmpty);
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                itemCount: data.length,
                itemBuilder: (_, i) => _kartu(data[i]),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Empty state
  Widget _kosong(bool memangKosong) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            memangKosong ? Icons.meeting_room_outlined : Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            memangKosong
                ? 'Belum ada data penghuni'
                : 'Tidak ada penghuni yang cocok',
            style: const TextStyle(color: Colors.grey),
          ),
          if (memangKosong)
            const Text('Tekan tombol Tambah untuk mulai mendata',
                style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _kartu(Penghuni p) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Kamar ${p.noKamar} - ${p.nama}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Chip(
                  label: Text(p.lunas ? 'Lunas' : 'Belum Lunas'),
                  backgroundColor:
                      p.lunas ? Colors.green.shade100 : Colors.red.shade100,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Text('HP: ${p.noHp}'),
            Text('Sewa: ${rupiah.format(p.biayaSewa)}'),
            Text('Masuk: ${formatTanggal.format(p.tanggalMasuk)}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // FITUR KHUSUS 2: tombol Tandai Lunas
                if (!p.lunas)
                  FilledButton.tonalIcon(
                    onPressed: () => controller.tandaiLunas(p),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Tandai Lunas'),
                  ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed: () => Get.toNamed(AppRoutes.form, arguments: p),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  tooltip: 'Hapus',
                  onPressed: () => controller.hapus(p),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
