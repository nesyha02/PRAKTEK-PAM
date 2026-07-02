import 'package:flutter/material.dart';
import '../models/stock_model.dart';

class StockCard extends StatelessWidget {
  final StockModel stock;
  final String title;

  const StockCard({super.key, required this.stock, required this.title});

  @override
  Widget build(BuildContext context) {
    // Warna berdasarkan perubahan harga
    Color priceColor = stock.change >= 0 ? Colors.green : Colors.red;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),

            Text(
              stock.symbol,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Text(
              'Rp ${stock.price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: priceColor,
              ),
            ),

            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  stock.change >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  color: priceColor,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  '${stock.change.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: priceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              '${stock.timestamp.hour.toString().padLeft(2, '0')}:${stock.timestamp.minute.toString().padLeft(2, '0')}:${stock.timestamp.second.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
