import 'package:flutter/material.dart';

import 'models/weather_model.dart';
import 'services/weather_service.dart';
import 'widgets/weather_display.dart';
import 'widgets/weather_skeleton.dart';
import 'widgets/error_display.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late final WeatherService _weatherService;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService();
  }

  void _handleRetry() {
    setState(() {
      _weatherService.retry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Aplikasi Cuaca Real-time'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Toggle Error Simulation',
            onPressed: () {
              _weatherService.toggleErrorSimulation();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error simulation toggled'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<WeatherModel>(
        stream: _weatherService.stream,
        builder: (context, snapshot) {
          // Error
          if (snapshot.hasError) {
            debugPrint('Error detected: ${snapshot.error}');
            return ErrorDisplay(error: snapshot.error!, onRetry: _handleRetry);
          }

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('Waiting for data...');
            return const WeatherSkeleton();
          }

          // Stream aktif tetapi belum ada data
          if (snapshot.connectionState == ConnectionState.active &&
              !snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Menyiapkan data...'),
                ],
              ),
            );
          }

          // Data tersedia
          if (snapshot.hasData) {
            debugPrint('Data received: ${snapshot.data!.city}');
            return WeatherDisplay(weather: snapshot.data!);
          }

          // Fallback
          return const Center(child: Text('Tidak ada data yang tersedia'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleRetry,
        tooltip: 'Refresh Manual',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _weatherService.dispose();
    super.dispose();
  }
}
