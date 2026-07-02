class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final DateTime lastUpdated;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
  });

  // Factory untuk membuat data random (simulasi)
  factory WeatherModel.random(String city) {
    final conditions = [
      'Cerah',
      'Berawan',
      'Hujan Ringan',
      'Hujan Lebat',
      'Badai',
    ];

    final random = DateTime.now().millisecond;

    return WeatherModel(
      city: city,
      temperature: (20 + (random % 15)).toDouble(),
      condition: conditions[random % conditions.length],
      humidity: 50 + (random % 50),
      windSpeed: (5 + (random % 20)).toDouble(),
      lastUpdated: DateTime.now(),
    );
  }

  // Icon berdasarkan kondisi
  String get iconEmoji {
    switch (condition) {
      case 'Cerah':
        return '☀️';
      case 'Berawan':
        return '☁️';
      case 'Hujan Ringan':
        return '🌦️';
      case 'Hujan Lebat':
        return '🌧️';
      case 'Badai':
        return '⛈️';
      default:
        return '☀️';
    }
  }
}
