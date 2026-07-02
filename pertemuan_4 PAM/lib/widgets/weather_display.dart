import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WeatherDisplay extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City name and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weather.city,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('HH:mm:ss').format(weather.lastUpdated),
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main weather info
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    weather.iconEmoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(0)}°C',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weather.condition,
                      style: TextStyle(fontSize: 24, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Additional details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  icon: Icons.water_drop,
                  value: '${weather.humidity}%',
                  label: 'Kelembaban',
                ),
                _buildDetailItem(
                  icon: Icons.air,
                  value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
                  label: 'Angin',
                ),
                _buildDetailItem(
                  icon: Icons.timer,
                  value: '5 detik',
                  label: 'Update',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Auto-refresh indicator
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.autorenew, size: 16, color: Colors.blue[800]),
                  const SizedBox(width: 4),
                  Text(
                    'Update setiap 5 detik',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue[800]),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }
}
