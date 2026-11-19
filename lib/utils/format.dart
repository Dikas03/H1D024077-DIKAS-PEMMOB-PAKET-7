import 'package:intl/intl.dart';

final NumberFormat rupiah =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

final DateFormat formatTanggal = DateFormat('dd MMMM yyyy', 'id_ID');
