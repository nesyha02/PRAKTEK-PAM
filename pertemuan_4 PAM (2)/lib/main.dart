import 'package:flutter/material.dart';

import 'models/berita.dart';
import 'services/berita_service.dart';
import 'widgets/berita_card.dart';
import 'widgets/berita_loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Berita",
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BeritaService service = BeritaService();

  late Stream<List<Berita>> stream;

  @override
  void initState() {
    super.initState();
    stream = service.getBerita();
  }

  void retry() {
    setState(() {
      stream = service.getBerita();
    });
  }

  String pesanError(String error) {
    if (error.contains("wifi")) {
      return "Tidak ada koneksi internet.";
    }

    if (error.contains("server")) {
      return "500 Internal Server Error.";
    }

    return "Gagal membaca data.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Berita Hari Ini")),
      body: StreamBuilder<List<Berita>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const BeritaLoading();
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pesanError(snapshot.error.toString()),
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: retry, child: const Text("Retry")),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada berita hari ini.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return BeritaCard(berita: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
