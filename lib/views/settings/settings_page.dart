import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/setting_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/vault_provider.dart';
import '../../providers/expense_goal_provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/services/google_drive_service.dart';
import 'package:intl/intl.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _currencyController = TextEditingController();
  final GoogleDriveService _driveService = GoogleDriveService();
  bool _isLoading = false;
  bool _isInitializing = true;
  Map<String, dynamic>? _backupInfo;

  @override
  void initState() {
    super.initState();
    _initDriveService();
  }

  Future<void> _initDriveService() async {
    setState(() => _isInitializing = true);
    await _driveService.init();
    if (_driveService.isSignedIn) {
      await _loadBackupInfo();
    }
    if (mounted) setState(() => _isInitializing = false);
  }

  Future<void> _loadBackupInfo() async {
    try {
      final info = await _driveService.getBackupInfo();
      if (mounted) {
        setState(() {
          _backupInfo = info;
        });
      }
    } catch (e) {
      print('Error loading backup info: $e');
    }
  }

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

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await _driveService.signIn();
      await _loadBackupInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in as ${_driveService.currentUser?.email}')),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Sign in failed: $e';

        // Provide helpful error messages
        if (e.toString().contains('People API') ||
            e.toString().contains('people.googleapis.com')) {
          errorMessage = 'People API not enabled!\n\n'
              'For web sign-in, enable People API:\n'
              '1. Visit: https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=321117363173\n'
              '2. Click "ENABLE"\n'
              '3. Wait a few minutes\n'
              '4. Try sign-in again\n\n'
              'Android works, web needs this API.';
        } else if (e.toString().contains('sign_in_failed') ||
            e.toString().contains('SIGN_IN_FAILED')) {
          errorMessage = 'Sign in failed!\n\n'
              'Please configure OAuth client in Google Cloud Console.\n\n'
              'Your SHA-1: BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7\n\n'
              'See FIX_SIGN_IN_FAILED.md for detailed instructions.';
        } else if (e.toString().contains('network_error')) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else if (e.toString().contains('sign_in_canceled')) {
          errorMessage = 'Sign in cancelled.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: dangerColor,
            duration: const Duration(seconds: 6),
            action: e.toString().contains('sign_in_failed')
                ? SnackBarAction(
                    label: 'Help',
                    textColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sign-In Setup Required'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'OAuth client not configured. Follow these steps:\n',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text('1. Open Google Cloud Console'),
                                const Text('2. Select project: money-controller-c5eee'),
                                const Text('3. Go to: APIs & Services → Credentials'),
                                const Text('4. Create OAuth Client ID (Android)'),
                                const Text('5. Package: com.iishanto.money_controller'),
                                const SizedBox(height: 8),
                                const Text('6. SHA-1 Certificate:'),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.grey[200],
                                  child: const SelectableText(
                                    'BA:2C:2A:1A:C4:80:90:E4:4A:06:BB:5C:8E:CC:6D:22:EC:2D:B0:C7',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('7. Download updated google-services.json'),
                                const Text('8. Replace file in android/app/'),
                                const SizedBox(height: 8),
                                const Text(
                                  'See FIX_SIGN_IN_FAILED.md for detailed guide.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : null,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignOut() async {
    setState(() => _isLoading = true);
    try {
      await _driveService.signOut();
      setState(() => _backupInfo = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: $e'), backgroundColor: dangerColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSwitchAccount() async {
    setState(() => _isLoading = true);
    try {
      await _driveService.switchAccount();
      await _loadBackupInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Switched to ${_driveService.currentUser?.email}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Switch account failed: $e'), backgroundColor: dangerColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleUploadBackup() async {
    setState(() => _isLoading = true);
    try {
      final result = await _driveService.uploadBackup();
      await _loadBackupInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: successColor),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: dangerColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDownloadBackup() async {
    // Show warning dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: const Text(BACKUP_WARNING),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(CANCEL),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: warningColor),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(CONTINUE),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final result = await _driveService.downloadBackup();

      // Reload all providers
      if (mounted) {
        await context.read<BudgetProvider>().init();
        await context.read<ExpenseProvider>().init();
        await context.read<VaultProvider>().init();
        await context.read<SettingProvider>().init();
        await context.read<ExpenseGoalProvider>().init();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result), backgroundColor: successColor),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e'), backgroundColor: dangerColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<SettingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(SETTINGS),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Google Drive Backup Section
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.cloud, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              BACKUP_RESTORE,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      if (_isInitializing) ...[
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ] else if (_driveService.isSignedIn) ...[
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.account_circle),
                          ),
                          title: Text(SIGNED_IN_AS),
                          subtitle: Text(_driveService.currentUser?.email ?? ''),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'signout') {
                                _handleSignOut();
                              } else if (value == 'switch') {
                                _handleSwitchAccount();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'switch',
                                child: Row(
                                  children: [
                                    Icon(Icons.swap_horiz),
                                    SizedBox(width: 8),
                                    Text(SWITCH_ACCOUNT),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'signout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(width: 8),
                                    Text(SIGN_OUT),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        if (_backupInfo != null)
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: Text(LAST_BACKUP),
                            subtitle: Text(
                              _backupInfo!['modifiedTime'] != null
                                  ? DateFormat('MMM dd, yyyy HH:mm').format(
                                      DateTime.parse(_backupInfo!['modifiedTime']),
                                    )
                                  : NO_BACKUP_FOUND,
                            ),
                          ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.cloud_upload, color: primaryColor),
                          title: Text(UPLOAD_BACKUP),
                          subtitle: const Text('Backup all data to Google Drive'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _handleUploadBackup,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.cloud_download, color: successColor),
                          title: Text(DOWNLOAD_BACKUP),
                          subtitle: const Text('Restore data from Google Drive'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _backupInfo != null ? _handleDownloadBackup : null,
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text(
                                NOT_SIGNED_IN,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _handleSignIn,
                                icon: const Icon(Icons.login),
                                label: Text(SIGN_IN_WITH_GOOGLE),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // App Settings Section
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
          // About Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  subtitle: const Text('Version 1.2.0'),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

