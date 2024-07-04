import 'package:cash_counter/dashboard/model/money_record_model.dart';
import 'package:cash_counter/dashboard/provider/money_record_provider.dart';
import 'package:cash_counter/dashboard/ui/money_record_filter_screen.dart';
import 'package:cash_counter/shared/app_const.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoneyRecordChartScreen extends StatefulWidget {
  const MoneyRecordChartScreen({super.key});

  @override
  State<MoneyRecordChartScreen> createState() => _MoneyRecordChartScreenState();
}

class _MoneyRecordChartScreenState extends State<MoneyRecordChartScreen> {
  List<MoneyRecordModel> recordList = [];
  MoneyRecordType selectedType = MoneyRecordType.all;
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchMoneyRecord(context);
  }

  Future<void> fetchMoneyRecord(BuildContext context) async {
    final moneyProvider =
        Provider.of<MoneyRecordProvider>(context, listen: false);
    recordList = moneyProvider.moneyRecordsList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: PieChart(
                      swapAnimationDuration: const Duration(milliseconds: 150),
                      swapAnimationCurve: Curves.linear,
                      PieChartData(
                        sections: getExpenseSections(),
                        borderData: FlBorderData(show: true),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: calculateFilteredRecords().map((record) {
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getRandomColor(record.category),
                        ),
                      ),
                      title: Text(record.category),
                      subtitle: Text('Amount: ${record.amount}'),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> getExpenseSections() {
    Map<String, double> expensesByCategory =
        getExpensesByCategory(recordList, selectedType, selectedCategory);
    List<PieChartSectionData> sections = [];

    expensesByCategory.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: getRandomColor(category),
          value: amount,
          title: '',
          showTitle: true,
          radius: 100,
          titleStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    return sections;
  }

  List<MoneyRecordModel> calculateFilteredRecords() {
    if (selectedType == MoneyRecordType.all && selectedCategory.isEmpty) {
      return recordList;
    }

    Map<String, double> categoryRecord = {};

    for (MoneyRecordModel record in recordList) {
      if ((record.type == selectedType ||
              selectedType == MoneyRecordType.all) &&
          (selectedCategory.isEmpty || record.category == selectedCategory)) {
        categoryRecord.update(record.category, (value) => value + record.amount,
            ifAbsent: () => record.amount);
      }
    }

    return categoryRecord.entries.map((entry) {
      return MoneyRecordModel(
        type: selectedType,
        category: entry.key,
        amount: entry.value,
        date: DateTime.now().millisecondsSinceEpoch,
        title: '',
      );
    }).toList();
  }

  Color getRandomColor(String category) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.black,
      Colors.grey,
      Colors.blueAccent,
      Colors.brown,
      Colors.deepOrangeAccent,
      Colors.amberAccent,
    ];
    int index = AppConst.getRecordCategories().indexOf(category);
    return colors[index % colors.length];
  }

  void _openFilterScreen(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MoneyRecordFilterScreen(
          onFilterChanged: (MoneyRecordType type, String category) {
            _handleFilterChanged(type, category);
            Navigator.pop(context);
          },
          initialSelectedType: selectedType,
          initialSelectedCategory: selectedCategory,
        );
      },
    );
  }

  void _handleFilterChanged(MoneyRecordType type, String category) {
    setState(() {
      selectedType = type;
      selectedCategory = category;
    });
  }

  Map<String, double> getExpensesByCategory(
      List<MoneyRecordModel> records, MoneyRecordType type, String category) {
    Map<String, double> expensesByCategory = {};

    for (MoneyRecordModel record in records) {
      if ((type == MoneyRecordType.all || record.type == type) &&
          (category.isEmpty || record.category == category)) {
        expensesByCategory.update(
            record.category, (value) => value + record.amount,
            ifAbsent: () => record.amount);
      }
    }

    return expensesByCategory;
  }

  void clearFilter() {
    setState(() {
      selectedType = MoneyRecordType.all;
      selectedCategory = '';
    });
  }
}
