
import 'package:cash_counter/dashboard/model/money_record_model.dart';
import 'package:cash_counter/dashboard/provider/money_record_provider.dart';
import 'package:cash_counter/shared/app_colors.dart';
import 'package:cash_counter/shared/app_const.dart';
import 'package:cash_counter/shared/app_string.dart';
import 'package:cash_counter/shared/app_text_field.dart';
import 'package:cash_counter/shared/app_util.dart';
import 'package:cash_counter/shared/widget/radio_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMoneyRecordScreen extends StatefulWidget {
  const AddMoneyRecordScreen({super.key});

  @override
  State<AddMoneyRecordScreen> createState() => _AddMoneyRecordScreenState();
}

class _AddMoneyRecordScreenState extends State<AddMoneyRecordScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  late String selectedCategory;
  late int selectedDate = DateTime.now().millisecondsSinceEpoch;
  MoneyRecordType selectedType = MoneyRecordType.expense;
  List<String> categories = AppConst.getRecordCategories();

  @override
  void initState() {
    selectedCategory = categories[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(addMoneyTitleText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: titleController,
                suffixIcon: const Icon(Icons.title),
                hintText: hintTextTitle,
              ),
              const SizedBox(
                height: 8,
              ),
              AppTextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                suffixIcon: const Icon(Icons.attach_money_outlined),
                hintText: hintTextAmount,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items:
                  categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(Icons.category_sharp),
                          const SizedBox(width: 8),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: labelTextCategory,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text(dateText),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(transactionType),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.income,
                    selectedValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    title: incomeText,
                  ),
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.expense,
                    selectedValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    title: expenseText,
                  )
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              InkWell(
                onTap: () async {
                  await addMoneyRecord();
                  fetchMoneyRecord();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: textButtonColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    addRecordTitleText,
                    style: TextStyle(color: buttonTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked.millisecondsSinceEpoch;
      });
    }
  }

  Future addMoneyRecord() async {
    MoneyRecordModel moneyRecord = MoneyRecordModel(
      title: titleController.text,
      amount: double.parse(amountController.text),
      category: selectedCategory,
      date: selectedDate,
      type: selectedType,
    );
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyProvider.addMoneyRecord(moneyRecord);

    if (moneyProvider.error == null) {
      if (mounted) {
        AppUtil.showToast(recordAddMsg);
        Navigator.pop(context);
      }
    }
  }

  void fetchMoneyRecord() async {
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecord();
  }
}