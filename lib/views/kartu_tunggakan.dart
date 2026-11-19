import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../utils/format.dart';

class KartuTunggakan extends StatelessWidget {
  final double total;
  const KartuTunggakan({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Tunggakan'),
          const SizedBox(height: 4),
          Text(
            rupiah.format(total),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'Tunggakan Rp 1.500.000')
Widget previewKartuTunggakan() => MaterialApp(
      home: Scaffold(body: KartuTunggakan(total: 1500000)),
    );

@Preview(name: 'Tunggakan nol')
Widget previewKartuTunggakanNol() => MaterialApp(
      home: Scaffold(body: KartuTunggakan(total: 0)),
    );