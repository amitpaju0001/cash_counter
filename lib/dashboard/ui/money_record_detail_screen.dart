import 'package:cash_counter/dashboard/model/money_record_model.dart';
import 'package:cash_counter/shared/app_colors.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:cash_counter/shared/app_util.dart';
import 'package:flutter/material.dart';

class MoneyRecordDetailScreen extends StatefulWidget {
  const MoneyRecordDetailScreen({super.key, required this.moneyRecord});

  final MoneyRecordModel moneyRecord;

  @override
  State<MoneyRecordDetailScreen> createState() =>
      _MoneyRecordDetailScreenState();
}

class _MoneyRecordDetailScreenState extends State<MoneyRecordDetailScreen> {
  @override
  Widget build(BuildContext context) {
    DateTime recordDate =
    DateTime.fromMillisecondsSinceEpoch(widget.moneyRecord.date);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppUtil.formattedDate(recordDate),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: widget.moneyRecord.type == MoneyRecordType.expense
              ? expenseColor
              : incomeColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              moneyRecordRow(
                label: labelTextName,
                value: widget.moneyRecord.title,
              ),
              moneyRecordRow(
                label: labelTextAmount,
                value: widget.moneyRecord.amount.toString(),
              ),
              moneyRecordRow(
                label: labelTextCategory,
                value: widget.moneyRecord.category,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row moneyRecordRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold), // Bold label text
        ),
        Text(
          value,
          style: const TextStyle(),
        ),
      ],
    );
  }
}