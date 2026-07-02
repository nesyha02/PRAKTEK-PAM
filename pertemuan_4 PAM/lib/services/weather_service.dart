import 'dart:async';
import '../models/weather_model.dart';

enum WeatherErrorType { network, timeout, unknown }

class WeatherServiceException implements Exception {
  final WeatherErrorType type;
  final String message;

  WeatherServiceException(this.type, this.message);

  @override
  String toString() => message;
}

class WeatherService {
  late StreamController<WeatherModel> _controller;
  Timer? _updateTimer;
  bool _simulateErrors = true;

  // List kota yang akan ditampilkan
  final List<String> cities = ['Jakarta', 'Surabaya', 'Bandung', 'Yogyakarta'];

  int _currentCityIndex = 0;

  WeatherService() {
    _controller = StreamController<WeatherModel>();
    _startUpdates();
  }

  void _startUpdates() {
    _updateTimer?.cancel();

    // Kirim data pertama setelah 1 detik (simulasi loading)
    Future.delayed(const Duration(seconds: 1), () {
      if (_controller.isClosed) return;
      _sendNextWeather();
    });

    // Kirim data baru setiap 5 detik
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.isClosed) return;

      // Simulasi error (30% chance jika _simulateErrors true)
      if (_simulateErrors && DateTime.now().second % 3 == 0) {
        final errorType = DateTime.now().second % 2 == 0
            ? WeatherErrorType.network
            : WeatherErrorType.timeout;

        final errorMessage = errorType == WeatherErrorType.network
            ? 'Koneksi internet terputus'
            : 'Server tidak merespon (timeout)';

        _controller.addError(WeatherServiceException(errorType, errorMessage));
      } else {
        _sendNextWeather();
      }
    });
  }

  void _sendNextWeather() {
    _currentCityIndex = (_currentCityIndex + 1) % cities.length;
    final city = cities[_currentCityIndex];
    _controller.add(WeatherModel.random(city));
  }

  // Method untuk retry (membuat stream baru)
  void retry() {
    if (!_controller.isClosed) {
      _controller.close();
    }

    _controller = StreamController<WeatherModel>();
    _startUpdates();
  }

  // Toggle simulasi error (untuk demonstrasi)
  void toggleErrorSimulation() {
    _simulateErrors = !_simulateErrors;
  }

  Stream<WeatherModel> get stream => _controller.stream;

  void dispose() {
    _updateTimer?.cancel();
    _controller.close();
  }
}
