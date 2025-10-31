import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/setting_provider.dart';
import '../../providers/budget_provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _currencyController = TextEditingController();

  @override
  void dispose() {
    _currencyController.dispose();
    super.dispose();
  }

  void _showCurrencyDialog(String currentSymbol) {
    _currencyController.text = currentSymbol;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Currency Symbol'),
        content: TextField(
          controller: _currencyController,
          decoration: const InputDecoration(
            labelText: 'Currency Symbol',
            hintText: 'e.g., \$, €, ৳',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(CANCEL),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currencyController.text.isNotEmpty) {
                context.read<SettingProvider>().setCurrencySymbol(_currencyController.text);
                Navigator.pop(context);
              }
            },
            child: const Text(SAVE),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<SettingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(SETTINGS),
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Hard Saving Mode'),
                  subtitle: const Text('Unused allowance automatically goes to Vault'),
                  value: settingProvider.hardSavingMode,
                  activeTrackColor: primaryColor,
                  onChanged: (value) {
                    settingProvider.setHardSavingMode(value);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: const Text('Currency Symbol'),
                  subtitle: Text(settingProvider.currencySymbol),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _showCurrencyDialog(settingProvider.currencySymbol),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Month Start Day'),
                  subtitle: Text('Day ${settingProvider.monthStartDay}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Month Start Day'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 31,
                            itemBuilder: (context, index) {
                              final day = index + 1;
                              return ListTile(
                                title: Text('Day $day'),
                                selected: settingProvider.monthStartDay == day,
                                onTap: () async {
                                  await settingProvider.setMonthStartDay(day);
                                  Navigator.pop(context);
                                  // Recalculate budget with new period
                                  if (context.mounted) {
                                    context.read<BudgetProvider>().recalculateWithCustomPeriod(
                                      settingProvider.monthStartDay,
                                      settingProvider.monthEndDay,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Month End Day'),
                  subtitle: Text('Day ${settingProvider.monthEndDay}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Month End Day'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 31,
                            itemBuilder: (context, index) {
                              final day = index + 1;
                              return ListTile(
                                title: Text('Day $day'),
                                selected: settingProvider.monthEndDay == day,
                                onTap: () async {
                                  await settingProvider.setMonthEndDay(day);
                                  Navigator.pop(context);
                                  // Recalculate budget with new period
                                  if (context.mounted) {
                                    context.read<BudgetProvider>().recalculateWithCustomPeriod(
                                      settingProvider.monthStartDay,
                                      settingProvider.monthEndDay,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  subtitle: const Text('Version 1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('App Info'),
                  subtitle: const Text('Smart Daily Budget - Manage your budget efficiently'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

