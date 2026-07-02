import 'package:flutter/material.dart';
import '../models/log_model.dart';

class LogList extends StatelessWidget {
  final List<LogModel> logs;

  const LogList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: logs.isEmpty
          ? const Center(
              child: Text("Belum ada log", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              reverse: true, // Log terbaru di atas
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];

                return ListTile(
                  leading: Icon(
                    log.level == LogLevel.error ? Icons.error : Icons.info,
                    color: log.color,
                    size: 20,
                  ),
                  title: Text(
                    "[${log.formattedTime}] ${log.message}",
                    style: TextStyle(fontSize: 13, color: log.color),
                  ),
                  dense: true,
                );
              },
            ),
    );
  }
}
