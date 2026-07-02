import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Simulasi Future",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  bool isLoading = false;
  String hasil = "";

  Future<void> ambilData() async {
    setState(() {
      isLoading = true;
      hasil = "";
    });

    try {
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      setState(() {
        hasil = "🎉 Data berhasil diambil!";
      });
    } catch (e) {
      setState(() {
        hasil = "❌ Gagal mengambil data";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Simulasi Future",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_download, size: 90, color: Colors.blue),

              const SizedBox(height: 20),

              const Text(
                "Simulasi Pengambilan Data",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : ambilData,
                  icon: const Icon(Icons.download),
                  label: const Text(
                    "Ambil Data",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              if (isLoading)
                Column(
                  children: const [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 15),
                    Text(
                      "Sedang mengambil data...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),

              const SizedBox(height: 30),

              if (hasil.isNotEmpty)
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      hasil,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: hasil.contains("Gagal")
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
