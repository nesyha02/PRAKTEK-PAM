import 'dart:async';
import 'dart:math';

import '../models/berita.dart';

class BeritaService {
  final Random random = Random();

  Stream<List<Berita>> getBerita() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 10));

      int angka = random.nextInt(100);

      // Error 20%
      if (angka < 20) {
        int jenis = random.nextInt(3);

        if (jenis == 0) {
          throw Exception("wifi");
        } else if (jenis == 1) {
          throw Exception("server");
        } else {
          throw Exception("parsing");
        }
      }

      // Empty 20%
      if (angka >= 20 && angka < 40) {
        yield [];
      }
      // Data normal
      else {
        yield [
          Berita(
            judul: "Flutter Semakin Populer",
            isi: "Flutter menjadi framework favorit developer.",
          ),
          Berita(
            judul: "AI Membantu Programmer",
            isi: "Teknologi AI mempercepat proses coding.",
          ),
          Berita(
            judul: "Teknologi Cloud",
            isi: "Cloud Computing semakin berkembang.",
          ),
        ];
      }
    }
  }
}
