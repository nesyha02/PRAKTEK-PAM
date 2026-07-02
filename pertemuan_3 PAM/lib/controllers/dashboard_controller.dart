import 'dart:async';

import '../models/stock_model.dart';
import '../models/notification_model.dart';
import '../models/log_model.dart';

class DashboardController {
  // Singleton
  static final DashboardController _instance = DashboardController._internal();

  factory DashboardController() => _instance;

  DashboardController._internal();

  // Broadcast Stream untuk harga saham
  late final StreamController<StockModel> _stockController;
  Stream<StockModel> get stockStream => _stockController.stream;

  // Single Subscription Stream untuk notifikasi
  late final StreamController<NotificationModel> _notificationController;
  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;

  // Stream untuk log aktivitas
  late final StreamController<LogModel> _logController;
  Stream<LogModel> get logStream => _logController.stream;

  Timer? _stockTimer;
  bool _simulateError = false;

  // Inisialisasi
  void initialize() {
    _stockController = StreamController<StockModel>.broadcast();

    _notificationController = StreamController<NotificationModel>();

    _logController = StreamController<LogModel>();

    _startStockSimulation();
  }

  // Simulasi harga saham
  void _startStockSimulation() {
    _stockTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Simulasi Error
      if (DateTime.now().second % 5 == 0 && _simulateError) {
        _stockController.addError("Gagal mendapatkan harga saham!");

        _addLog(LogModel.error("Error: Gagal mendapatkan harga saham"));

        return;
      }

      // Data saham acak
      final stock1 = StockModel.random("BBCA");
      final stock2 = StockModel.random("BBRI");
      final stock3 = StockModel.random("TLKM");

      _stockController.add(stock1);
      _stockController.add(stock2);
      _stockController.add(stock3);

      _addLog(LogModel.info("Harga saham diperbarui: $stock1"));
    });
  }

  // Kirim notifikasi
  void sendNotification(String message, NotificationType type) {
    NotificationModel notification;

    switch (type) {
      case NotificationType.info:
        notification = NotificationModel.info(message);
        break;

      case NotificationType.warning:
        notification = NotificationModel.warning(message);
        break;

      case NotificationType.error:
        notification = NotificationModel.error(message);
        break;
    }

    _notificationController.add(notification);

    _addLog(LogModel.info("Notifikasi: $message"));
  }

  // Tambah log
  void _addLog(LogModel log) {
    _logController.add(log);
  }

  // Aktif / Nonaktif simulasi error
  void toggleErrorSimulation() {
    _simulateError = !_simulateError;

    sendNotification(
      "Error Simulation : ${_simulateError ? "ON" : "OFF"}",
      _simulateError ? NotificationType.warning : NotificationType.info,
    );
  }

  // Tes Error Manual
  void sendTestError() {
    _logController.addError("Test Error dari pengguna!");
  }

  // Dispose
  void dispose() {
    _stockTimer?.cancel();

    _stockController.close();
    _notificationController.close();
    _logController.close();
  }
}
