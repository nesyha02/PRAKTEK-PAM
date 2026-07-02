import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multiple Stream Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MultipleStreamPage(),
    );
  }
}

class MultipleStreamPage extends StatefulWidget {
  const MultipleStreamPage({super.key});

  @override
  State<MultipleStreamPage> createState() => _MultipleStreamPageState();
}

class _MultipleStreamPageState extends State<MultipleStreamPage> {
  // Stream Controller
  late StreamController<int> _counterController;
  late StreamController<String> _messageController;
  late StreamController<DateTime> _timeController;

  // Menyimpan data terakhir
  int _lastCounter = 0;
  String _lastMessage = "Belum ada pesan";
  DateTime _lastTime = DateTime.now();

  // Subscription Counter
  late StreamSubscription<int> _counterSubscription;
  bool _isCounterPaused = false;

  @override
  void initState() {
    super.initState();

    _counterController = StreamController<int>();
    _messageController = StreamController<String>();
    _timeController = StreamController<DateTime>();

    // Listener Counter
    _counterSubscription = _counterController.stream.listen((data) {
      setState(() {
        _lastCounter = data;
      });
      print("Counter: $data");
    });

    // Listener Message
    _messageController.stream.listen((data) {
      setState(() {
        _lastMessage = data;
      });
      print("Pesan: $data");
    });

    // Listener Time
    _timeController.stream.listen((data) {
      setState(() {
        _lastTime = data;
      });
      print("Waktu: $data");
    });

    _startSimulatingData();
  }

  void _startSimulatingData() {
    // Counter setiap 2 detik
    int counter = 0;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));

      if (_counterController.isClosed) {
        return false;
      }

      counter++;
      _counterController.add(counter);

      return true;
    });

    // Pesan setiap 5 detik
    final messages = [
      "Halo",
      "Apa kabar?",
      "Selamat Belajar",
      "Flutter Hebat",
      "Stream Keren",
    ];

    int msgIndex = 0;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));

      if (_messageController.isClosed) {
        return false;
      }

      _messageController.add(messages[msgIndex % messages.length]);

      msgIndex++;

      return true;
    });

    // Waktu setiap 1 detik
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (_timeController.isClosed) {
        return false;
      }

      _timeController.add(DateTime.now());

      return true;
    });
  }

  @override
  void dispose() {
    _counterSubscription.cancel();
    _counterController.close();
    _messageController.close();
    _timeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multiple Stream Demo"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "📊 COUNTER",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Nilai : $_lastCounter",
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (_isCounterPaused) {
                            _counterSubscription.resume();
                          } else {
                            _counterSubscription.pause();
                          }

                          setState(() {
                            _isCounterPaused = !_isCounterPaused;
                          });
                        },
                        child: Text(_isCounterPaused ? "Lanjutkan" : "Jeda"),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "💬 MESSAGE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(_lastMessage, style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),

              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "⏰ TIME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${_lastTime.hour.toString().padLeft(2, '0')}:"
                        "${_lastTime.minute.toString().padLeft(2, '0')}:"
                        "${_lastTime.second.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
