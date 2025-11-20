import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  final bool isEnglish;
  const AlertsScreen({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Alerts' : 'الرٹس'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              isEnglish ? 'Recent Alerts' : 'حالیہ الرٹس',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: List.generate(
                  10,
                  (index) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.red),
                      title: Text(isEnglish
                          ? 'Alert #${index + 1}'
                          : 'الرٹ #${index + 1}'),
                      subtitle: Text(
                          isEnglish ? 'Check immediately' : 'فوری جانچ کریں'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
