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
      appBar: AppBar(
        title: const Text(moneyRecordChart),
        actions: [
          IconButton(
            onPressed: () {
              _openFilterScreen(context);
            },
            icon: const Icon(Icons.filter_list),
          ),
          Visibility(visible: selectedType != MoneyRecordType.all,
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearFilter,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
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
                        sectionsSpace: 0,
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
                  return ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      color: getRandomColor(record.category),
                    ),
                    title: Text(record.category),
                    subtitle: Text('Amount: ${record.amount}'),
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
      if (record.type == selectedType &&
          (selectedCategory.isEmpty || record.category == selectedCategory)) {
        if (categoryRecord.containsKey(record.category)) {
          categoryRecord[record.category] =
              (categoryRecord[record.category] ?? 0) + record.amount;
        } else {
          categoryRecord[record.category] = record.amount;
        }
      }
    }

    List<MoneyRecordModel> filteredRecords = categoryRecord.entries.map((record) {
      return MoneyRecordModel(
        type: selectedType,
        category: record.key,
        amount: record.value,
        date: DateTime.now().microsecondsSinceEpoch,
        title: '',
      );
    }).toList();

    return filteredRecords;
  }

  Color getRandomColor(String category) {
    if (category == AppConst.getRecordCategories()[0]) {
      return Colors.red;
    }
    if (category == AppConst.getRecordCategories()[1]) {
      return Colors.blue;
    }
    if (category == AppConst.getRecordCategories()[2]) {
      return Colors.green;
    }
    if (category == AppConst.getRecordCategories()[3]) {
      return Colors.yellow;
    }
    if (category == AppConst.getRecordCategories()[4]) {
      return Colors.orange;
    }
    if (category == AppConst.getRecordCategories()[5]) {
      return Colors.purple;
    }
    if (category == AppConst.getRecordCategories()[6]) {
      return Colors.black;
    }
    if (category == AppConst.getRecordCategories()[7]) {
      return Colors.grey;
    }
    if (category == AppConst.getRecordCategories()[8]) {
      return Colors.blueAccent;
    }
    if (category == AppConst.getRecordCategories()[9]) {
      return Colors.brown;
    }
    if (category == AppConst.getRecordCategories()[10]) {
      return Colors.deepOrangeAccent;
    }

    return Colors.amberAccent;
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
        String recordCategory = record.category;
        expensesByCategory.update(
          recordCategory,
              (value) => value + record.amount,
          ifAbsent: () => record.amount,
        );
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