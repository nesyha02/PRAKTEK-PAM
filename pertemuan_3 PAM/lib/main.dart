import 'dart:async';
import 'package:flutter/material.dart';

import 'models/notification_model.dart';
import 'models/stock_model.dart';
import 'models/log_model.dart';
import 'controllers/dashboard_controller.dart';
import 'widgets/stock_card.dart';
import 'widgets/notification_display.dart';
import 'widgets/log_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real-time Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final dashboardController = DashboardController();

  StockModel? _latestStock1;
  StockModel? _latestStock2;
  NotificationModel? _latestNotification;
  final List<LogModel> _logs = [];

  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    dashboardController.initialize();

    _subscriptions.add(
      dashboardController.stockStream.listen(
        (stock) {
          setState(() {
            if (stock.symbol == 'BBCA') {
              _latestStock1 = stock;
            } else if (stock.symbol == 'BBRI') {
              _latestStock2 = stock;
            }
          });
        },
        onError: (error) {
          setState(() {
            _logs.insert(0, LogModel.error('Stock Error: $error'));
          });
        },
      ),
    );

    _subscriptions.add(
      dashboardController.stockStream.listen((stock) {
        debugPrint('Listener kedua: ${stock.symbol}');
      }),
    );

    _subscriptions.add(
      dashboardController.notificationStream.listen((notification) {
        setState(() {
          _latestNotification = notification;
        });
      }),
    );

    _subscriptions.add(
      dashboardController.logStream.listen(
        (log) {
          setState(() {
            _logs.insert(0, log);
            if (_logs.length > 50) {
              _logs.removeLast();
            }
          });
        },
        onError: (error) {
          setState(() {
            _logs.insert(0, LogModel.error('System Error: $error'));
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }

    dashboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Real-time Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: () {
              dashboardController.toggleErrorSimulation();
            },
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              dashboardController.sendTestError();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📈 Harga Saham',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _latestStock1 != null
                      ? StockCard(stock: _latestStock1!, title: 'Widget 1')
                      : const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Menunggu data...'),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _latestStock2 != null
                      ? StockCard(stock: _latestStock2!, title: 'Widget 2')
                      : const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Menunggu data...'),
                          ),
                        ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              '🔔 Notifikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            NotificationDisplay(notification: _latestNotification),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      dashboardController.sendNotification(
                        'User membuka dashboard',
                        NotificationType.info,
                      );
                    },
                    child: const Text('Info'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      dashboardController.sendNotification(
                        'Memory tinggi',
                        NotificationType.warning,
                      );
                    },
                    child: const Text('Warning'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      dashboardController.sendNotification(
                        'Koneksi putus',
                        NotificationType.error,
                      );
                    },
                    child: const Text('Error'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              '📋 Log Aktivitas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            LogList(logs: _logs),
          ],
        ),
      ),
    );
  }
}
