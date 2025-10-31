import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/prefs_helper.dart';
import 'providers/budget_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/vault_provider.dart';
import 'providers/setting_provider.dart';
import 'providers/expense_goal_provider.dart';
import 'views/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BudgetProvider()..init()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..init()),
        ChangeNotifierProvider(create: (_) => VaultProvider()..init()),
        ChangeNotifierProvider(create: (_) => SettingProvider()..init()),
        ChangeNotifierProvider(create: (_) => ExpenseGoalProvider()..init()),
      ],
      child: Consumer<SettingProvider>(
        builder: (context, settingProvider, child) {
          return MaterialApp(
            title: 'Smart Daily Budget',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }

}
