import 'package:cash_counter/auth/provider/custom_auth_provider.dart';
import 'package:cash_counter/auth/service/auth_service.dart';
import 'package:cash_counter/dashboard/service/database_service.dart';
import 'package:cash_counter/auth/ui/login_screen.dart';
import 'package:cash_counter/core/storage_helper.dart';
import 'package:cash_counter/dashboard/provider/money_record_provider.dart';
import 'package:cash_counter/shared/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    DatabaseService databaseService = DatabaseService();
    await databaseService.initDatabase();
  Get.put(AuthService());
  Get.put(DatabaseService());
  Get.put(StorageHelper());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MoneyRecordProvider(databaseService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appColorScheme),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
