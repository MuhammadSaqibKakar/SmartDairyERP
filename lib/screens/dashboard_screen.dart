import 'package:flutter/material.dart';

import 'details/animals_screen.dart';
import 'details/milk_produced_screen.dart';
import 'details/milk_sold_screen.dart';
import 'details/inventory_screen.dart';
import 'details/revenue_screen.dart';
import 'details/alerts_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool isEnglish;
  final ValueChanged<bool>? onLanguageToggle;

  const DashboardScreen({
    super.key,
    required this.isEnglish,
    this.onLanguageToggle,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late bool isEnglish;

  @override
  void initState() {
    super.initState();
    isEnglish = widget.isEnglish;
  }

  void _toggleLanguage() {
    setState(() => isEnglish = !isEnglish);
    widget.onLanguageToggle?.call(isEnglish);
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.pets, 'label': 'Animals', 'page': AnimalsScreen(isEnglish: isEnglish)},
      {'icon': Icons.local_drink, 'label': 'Milk Produced', 'page': MilkProducedScreen(isEnglish: isEnglish)},
      {'icon': Icons.sell, 'label': 'Milk Sold', 'page': MilkSoldScreen(isEnglish: isEnglish)},
      {'icon': Icons.inventory, 'label': 'Inventory', 'page': InventoryScreen(isEnglish: isEnglish)},
      {'icon': Icons.attach_money, 'label': 'Revenue', 'page': RevenueScreen(isEnglish: isEnglish)},
      {'icon': Icons.notifications, 'label': 'Alerts', 'page': AlertsScreen(isEnglish: isEnglish)},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Dashboard' : 'ڈیش بورڈ',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 25,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (_, i) {
                    final icon = items[i]['icon'] as IconData;
                    final label = items[i]['label'] as String;
                    final page = items[i]['page'] as Widget;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => page),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(icon, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isEnglish ? label : _translate(label),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _translate(String label) {
    switch (label) {
      case 'Animals':
        return 'جانور';
      case 'Milk Produced':
        return 'تیار شدہ دودھ';
      case 'Milk Sold':
        return 'فروخت شدہ دودھ';
      case 'Inventory':
        return 'اسٹاک';
      case 'Revenue':
        return 'آمدنی';
      case 'Alerts':
        return 'الرٹس';
      default:
        return label;
    }
  }
}
