import 'package:cash_counter/dashboard/model/money_record_model.dart';
import 'package:cash_counter/dashboard/provider/money_record_provider.dart';
import 'package:cash_counter/dashboard/ui/edit_money_record_screen.dart';
import 'package:cash_counter/dashboard/ui/money_record_detail_screen.dart';
import 'package:cash_counter/dashboard/ui/widget/money_record_list_item_widget.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:cash_counter/shared/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class MoneyRecordListScreen extends StatefulWidget {
  const MoneyRecordListScreen({super.key});

  @override
  State<MoneyRecordListScreen> createState() => _MoneyRecordListScreenState();
}

class _MoneyRecordListScreenState extends State<MoneyRecordListScreen> {


  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchMoneyRecord();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Consumer<MoneyRecordProvider>(
        builder: (context, moneyRecordProvider, widget) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                MoneyRecordModel moneyRecord =
                moneyRecordProvider.moneyRecordsList[index];
                return Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDeleteConfirmDialog(moneyRecord);
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          editOpenMoneyRecordScreen(moneyRecord);
                        },
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MoneyRecordDetailScreen(
                              moneyRecord: moneyRecord,
                            );
                          },
                        ),
                      );
                    },
                    child: MoneyRecordListItemWidget(
                      moneyRecord: moneyRecord,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: moneyRecordProvider.moneyRecordsList.length,
            ),
          );
        },
      ),
    );

  }

  void fetchMoneyRecord() async {
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecord();
  }


  void showDeleteConfirmDialog(MoneyRecordModel moneyRecord) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(deleteAlert),
            content: const Text(deleteAlertText),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(cancelAlert),
              ),
              TextButton(
                onPressed: () {
                  deleteMoneyRecord(moneyRecord.id!);
                  Navigator.of(context).pop();
                },
                child: const Text(okayAlert),
              ),
            ],
          );
        });
  }

  void editOpenMoneyRecordScreen(MoneyRecordModel moneyRecord) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditMoneyRecordScreen(
        moneyRecord: moneyRecord,
      );
    }));
  }


  Future deleteMoneyRecord(int id) async {
    MoneyRecordProvider moneyRecordProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyRecordProvider.deleteMoneyRecord(id);
    if (moneyRecordProvider.error == null) {
      moneyRecordProvider.getMoneyRecord();
    } else {
      AppUtil.showToast(moneyRecordProvider.error!);
    }
  }
}