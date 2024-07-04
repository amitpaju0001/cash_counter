import 'package:cash_counter/dashboard/ui/add_money_record_screen.dart';
import 'package:cash_counter/dashboard/ui/money_record_chart_screen.dart';
import 'package:cash_counter/dashboard/ui/money_record_list_screen.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabScreenList = [
    const MoneyRecordListScreen(),
    const MoneyRecordChartScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: openAddTransactionScreen,
          child: const Icon(Icons.add),
        ),
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(moneyRecord),
          backgroundColor: Colors.white,
          leading:Image.asset(
            'assets/image/money.png',
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: moneyRecord,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: labelTextChart,
            ),
          ],
        ),
        body: _tabScreenList[_selectedIndex],
      ),
    );
  }
  void openAddTransactionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddMoneyRecordScreen();
        },
      ),
    );
  }

}