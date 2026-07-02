import 'package:flutter/material.dart';
import '../models/berita.dart';

class BeritaCard extends StatelessWidget {
  final Berita berita;

  const BeritaCard({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          berita.judul,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(berita.isi),
      ),
    );
  }
}
