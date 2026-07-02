import 'package:flutter/material.dart';

class SecondScreenWithData extends StatelessWidget {
  const SecondScreenWithData({super.key});

  @override
  Widget build(BuildContext context) {
    final String dataDiterima =
        ModalRoute.of(context)!.settings.arguments as String;

    return DetailView(detailText: dataDiterima);
  }
}

class DetailView extends StatelessWidget {
  final String detailText;

  const DetailView({super.key, required this.detailText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Halaman Detail")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "Menampilkan:\n$detailText",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
