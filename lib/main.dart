import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'bindings/penghuni_binding.dart';
import 'models/penghuni.dart';
import 'routes/app_routes.dart';
import 'services/penghuni_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  await Hive.initFlutter();
  Hive.registerAdapter(PenghuniAdapter());
  await Hive.openBox<Penghuni>(PenghuniService.boxName);
  runApp(const KosApp());
}

class KosApp extends StatelessWidget {
  const KosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Manajemen Kos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialBinding: PenghuniBinding(),
      initialRoute: AppRoutes.daftar,
      getPages: AppRoutes.pages,
    );
  }
}
