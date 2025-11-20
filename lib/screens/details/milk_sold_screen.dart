import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MilkSoldScreen extends StatefulWidget {
  final bool isEnglish;
  const MilkSoldScreen({super.key, required this.isEnglish});

  @override
  State<MilkSoldScreen> createState() => _MilkSoldScreenState();
}

class _MilkSoldScreenState extends State<MilkSoldScreen> {
  String selectedPeriod = 'Today';
  DateTimeRange? customRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEnglish ? 'Milk Sold' : 'فروخت شدہ دودھ'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            periodSelector(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summaryCard(widget.isEnglish ? 'Today\'s Sold' : 'آج فروخت شدہ', '150 L'),
                summaryCard(widget.isEnglish ? 'Revenue' : 'آمدنی', '\$450'),
              ],
            ),
            const SizedBox(height: 40),
            milkSoldGraph(),
          ],
        ),
      ),
    );
  }

  Widget periodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: selectedPeriod,
          items: ['Today', 'Weekly', 'Monthly', 'Yearly']
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(widget.isEnglish ? e : translatePeriod(e)),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => selectedPeriod = v);
          },
        ),
        ElevatedButton(
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (range != null) setState(() => customRange = range);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text(widget.isEnglish ? 'Select Range' : 'رینج منتخب کریں'),
        ),
      ],
    );
  }

  Widget summaryCard(String title, String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget milkSoldGraph() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: LineChart(LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 120),
              FlSpot(1, 150),
              FlSpot(2, 130),
              FlSpot(3, 170),
              FlSpot(4, 140),
            ],
            isCurved: true,
            gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      )),
    );
  }

  String translatePeriod(String period) {
    switch (period) {
      case 'Today':
        return 'آج';
      case 'Weekly':
        return 'ہفتہ وار';
      case 'Monthly':
        return 'ماہانہ';
      case 'Yearly':
        return 'سالانہ';
      default:
        return period;
    }
  }
}
