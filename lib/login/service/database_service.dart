import 'package:cash_counter/dashboard/model/money_record_model.dart';
import 'package:cash_counter/login/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  late Database database;
  String userTableName = 'user';
  String moneyRecordTableName = 'money_record';

  Future<void> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'money_tracker.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        createUserTable(db);
        createMoneyRecordTable(db);
        if (kDebugMode) {
          print("Tables created successfully");
        }
      },
    );
  }

  Future<void> createMoneyRecordTable(Database db) async {
    await db.execute(
        "create table $moneyRecordTableName(id integer primary key autoincrement, "
            "title text, amount real, category text "
            ",date integer,type text )");
  }

  Future<void> createUserTable(Database db) async {
    await db.execute(
        'CREATE TABLE $userTableName (email TEXT PRIMARY KEY, name TEXT, password TEXT)');
  }

  Future<void> registerUser(UserModel user) async {
    await database.rawInsert(
        'INSERT INTO $userTableName (email, name, password) VALUES (?, ?, ?)',
        [user.email, user.name, user.password]);
    if (kDebugMode) {
      print('User added successfully');
    }
  }

  Future<bool> isUserExists(UserModel user) async {
    List<Map<String, dynamic>> list = await database.rawQuery(
        "SELECT * FROM $userTableName WHERE email = ? AND password = ?",
        [user.email, user.password]);
    return list.isNotEmpty;
  }

  Future<void> addMoneyRecord(MoneyRecordModel moneyRecord) async {
    await database.rawInsert(
        'INSERT INTO $moneyRecordTableName (title  , amount  ,category  ,date ,type )VALUES ( ?, ?,?,?,?)',
        [
          moneyRecord.title,
          moneyRecord.amount,
          moneyRecord.category,
          moneyRecord.date,
          moneyRecord.type.toString(),
        ]);
    if (kDebugMode) {
      print('Money Record added successfully');
    }
  }

  Future<void> editMoneyRecord(MoneyRecordModel record) async {
    await database.rawUpdate(
      '''
    UPDATE $moneyRecordTableName
    SET
      title = ?,
      amount = ?,
      category = ?,
      date = ?,
      type = ?
    WHERE
      id =?
    ''',
      [
        record.title,
        record.amount,
        record.category,
        record.date,
        record.type.toString(),
        record.id,
      ],
    );

    if (kDebugMode) {
      print('Money Record updated successfully');
    }
  }

  Future<void> deleteMoneyRecord(int id) async {
    await database
        .rawInsert('delete from $moneyRecordTableName where id = ?', [id]);

    if (kDebugMode) {
      print('Money Record delete successfully');
    }
  }

  Future<List<MoneyRecordModel>> getMoneyRecords() async {
    List<Map<String, dynamic>> records =
    await database.rawQuery("select * from $moneyRecordTableName");

    List<MoneyRecordModel> moneyRecordList = [];
    for (int i = 0; i < records.length; i++) {
      Map<String, dynamic> map = records[i];
      MoneyRecordModel moneyRecord = MoneyRecordModel.fromJson(map);
      moneyRecordList.add(moneyRecord);
    }

    return moneyRecordList;
  }
}