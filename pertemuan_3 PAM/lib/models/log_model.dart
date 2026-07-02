import 'package:flutter/material.dart';

enum LogLevel { info, error }

class LogModel {
  final String message;
  final LogLevel level;
  final DateTime timestamp;

  LogModel(this.message, this.level, this.timestamp);

  // Log informasi
  factory LogModel.info(String message) {
    return LogModel(message, LogLevel.info, DateTime.now());
  }

  // Log error
  factory LogModel.error(String message) {
    return LogModel(message, LogLevel.error, DateTime.now());
  }

  // Format waktu
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  // Warna berdasarkan level log
  Color get color {
    switch (level) {
      case LogLevel.info:
        return Colors.black;

      case LogLevel.error:
        return Colors.red;
    }
  }

  @override
  String toString() {
    return '[$formattedTime] $message';
  }
}
