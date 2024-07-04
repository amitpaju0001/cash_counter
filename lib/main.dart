import 'package:cash_counter/dashboard/provider/money_record_provider.dart';
import 'package:cash_counter/login/provider/auth_provider.dart';
import 'package:cash_counter/login/service/database_service.dart';
import 'package:cash_counter/login/ui/login_screen.dart';
import 'package:cash_counter/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseService databaseService = DatabaseService();
  await databaseService.initDatabase();

  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.databaseService,super.key});
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return AuthProvider(databaseService);
        },),
        ChangeNotifierProvider(create: (context) {
          return MoneyRecordProvider(databaseService);
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: appColorScheme),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

