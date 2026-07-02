import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BeritaLoading extends StatelessWidget {
  const BeritaLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Container(height: 80, padding: const EdgeInsets.all(12)),
          ),
        );
      },
    );
  }
}
