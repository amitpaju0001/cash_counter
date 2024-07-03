class MoneyRecordModel {
  int? id;
  String title;
  double amount;
  String category;
  int date;
  MoneyRecordType type;

  MoneyRecordModel({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.type = MoneyRecordType.expense,
  });

  factory MoneyRecordModel.fromJson(Map<String, dynamic> json) {
    return MoneyRecordModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: json['date'],
      type: MoneyRecordType.values.firstWhere(
            (e) => e.toString() == json['type'],
        orElse: () => MoneyRecordType.expense,
      ),
    );
  }
}

enum MoneyRecordType { income, expense, all }