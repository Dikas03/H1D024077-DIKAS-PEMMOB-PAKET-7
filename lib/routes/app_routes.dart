import 'package:get/get.dart';

import '../views/penghuni_form_view.dart';
import '../views/penghuni_list_view.dart';

class AppRoutes {
  static const daftar = '/';
  static const form = '/form';

  static final pages = <GetPage>[
    GetPage(name: daftar, page: () => const PenghuniListView()),
    GetPage(name: form, page: () => const PenghuniFormView()),
  ];
}
