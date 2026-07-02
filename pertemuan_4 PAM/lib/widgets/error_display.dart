import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class ErrorDisplay extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorDisplay({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    String title;
    String message;
    IconData icon;

    if (error is WeatherServiceException) {
      final weatherError = error as WeatherServiceException;

      switch (weatherError.type) {
        case WeatherErrorType.network:
          title = 'Koneksi Terputus';
          message = 'Periksa koneksi internet Anda dan coba lagi.';
          icon = Icons.wifi_off;
          break;

        case WeatherErrorType.timeout:
          title = 'Waktu Habis';
          message = 'Server tidak merespon. Coba lagi nanti.';
          icon = Icons.timer_off;
          break;

        default:
          title = 'Error';
          message = weatherError.message;
          icon = Icons.error;
      }
    } else {
      title = 'Error Tidak Dikenal';
      message = error.toString();
      icon = Icons.error;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
