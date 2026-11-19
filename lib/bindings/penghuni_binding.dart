import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controllers/penghuni_controller.dart';
import '../models/penghuni.dart';
import '../services/penghuni_service.dart';

class PenghuniBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PenghuniService>(
      PenghuniService(Hive.box<Penghuni>(PenghuniService.boxName)),
      permanent: true,
    );
    Get.put<PenghuniController>(
      PenghuniController(Get.find<PenghuniService>()),
      permanent: true,
    );
  }
}
