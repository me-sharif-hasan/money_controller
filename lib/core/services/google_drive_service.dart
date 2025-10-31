import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import '../utils/prefs_helper.dart';
import '../constants/keys.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  void close() {
    _client.close();
  }
}

class GoogleDriveService {
  static const String _backupFileName = 'money_controller_backup.json';
  static const List<String> _scopes = [
    ga.DriveApi.driveAppdataScope,
    ga.DriveApi.driveFileScope,
  ];

  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;
  bool _isInitialized = false;

  GoogleDriveService() {
    _googleSignIn = GoogleSignIn(
      scopes: _scopes,
    );
  }

  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  // Initialize and check if user is already signed in
  Future<void> init() async {
    if (_isInitialized) return;

    // Listen to sign-in state changes
    _googleSignIn.onCurrentUserChanged.listen((account) {
      _currentUser = account;
      print('GoogleSignIn: User changed to ${account?.email ?? "null"}');
    });

    // Try to sign in silently (restore previous session)
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        _currentUser = account;
        print('GoogleSignIn: Silent sign-in successful for ${account.email}');
      } else {
        print('GoogleSignIn: No previous session found');
      }
    } catch (e) {
      print('GoogleSignIn: Silent sign-in failed - $e');
    }

    _isInitialized = true;
  }

  // Sign in with Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      // Check if already signed in
      if (_currentUser != null) {
        print('GoogleSignIn: Already signed in as ${_currentUser!.email}');
        return _currentUser;
      }

      print('GoogleSignIn: Starting interactive sign-in...');
      final account = await _googleSignIn.signIn();

      if (account != null) {
        // Don't manually set _currentUser, let the listener handle it
        print('GoogleSignIn: Sign-in successful for ${account.email}');
      } else {
        print('GoogleSignIn: Sign-in cancelled by user');
      }

      return account;
    } catch (e) {
      print('GoogleSignIn: Sign-in error - $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      // Don't manually set _currentUser, let the listener handle it
      print('GoogleSignIn: Signed out successfully');
    } catch (e) {
      print('GoogleSignIn: Sign-out error - $e');
      rethrow;
    }
  }

  // Switch account
  Future<GoogleSignInAccount?> switchAccount() async {
    try {
      print('GoogleSignIn: Disconnecting current account...');
      await _googleSignIn.disconnect();
      print('GoogleSignIn: Starting new sign-in...');
      return await signIn();
    } catch (e) {
      print('GoogleSignIn: Switch account error - $e');
      rethrow;
    }
  }

  // Ensure user is authenticated and token is valid
  Future<void> _ensureAuthenticated() async {
    if (_currentUser == null) {
      throw Exception('User not signed in. Please sign in first.');
    }

    // Try to get authenticated client to verify token is still valid
    try {
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        // Token might be expired, try silent sign-in to refresh
        print('GoogleSignIn: Token expired, refreshing...');
        final account = await _googleSignIn.signInSilently();
        if (account == null) {
          throw Exception('Session expired. Please sign in again.');
        }
        _currentUser = account;
      }
    } catch (e) {
      print('GoogleSignIn: Authentication check failed - $e');
      throw Exception('Authentication failed. Please sign in again.');
    }
  }

  // Get all app data to backup
  Future<Map<String, dynamic>> _getAllAppData() async {
    final data = <String, dynamic>{};

    // Get all data from shared preferences
    data['total_money'] = await PrefsHelper.getDouble(PREF_TOTAL_MONEY) ?? 0.0;
    data['fixed_costs'] = await PrefsHelper.getList(PREF_FIXED_COSTS);
    data['expenses'] = await PrefsHelper.getList(PREF_EXPENSES);
    data['vault_data'] = await PrefsHelper.getData(PREF_VAULT);
    data['settings'] = await PrefsHelper.getData(PREF_SETTINGS);
    data['saving_goal'] = await PrefsHelper.getData(PREF_GOAL);
    data['expense_goals'] = await PrefsHelper.getList(PREF_EXPENSE_GOALS);

    // Add metadata
    data['backup_version'] = '1.0';
    data['backup_date'] = DateTime.now().toIso8601String();
    data['app_version'] = '1.2.0';

    return data;
  }

  // Restore all app data from backup
  Future<void> _restoreAllAppData(Map<String, dynamic> data) async {
    // Restore each data type with proper type casting
    if (data.containsKey('total_money')) {
      await PrefsHelper.saveDouble(PREF_TOTAL_MONEY, (data['total_money'] as num).toDouble());
    }

    if (data.containsKey('fixed_costs') && data['fixed_costs'] != null) {
      final List<dynamic> rawList = data['fixed_costs'] as List<dynamic>;
      final List<Map<String, dynamic>> fixedCosts =
          rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      await PrefsHelper.saveList(PREF_FIXED_COSTS, fixedCosts);
    }

    if (data.containsKey('expenses') && data['expenses'] != null) {
      final List<dynamic> rawList = data['expenses'] as List<dynamic>;
      final List<Map<String, dynamic>> expenses =
          rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      await PrefsHelper.saveList(PREF_EXPENSES, expenses);
    }

    if (data.containsKey('vault_data') && data['vault_data'] != null) {
      final Map<String, dynamic> vaultData =
          Map<String, dynamic>.from(data['vault_data'] as Map);
      await PrefsHelper.saveData(PREF_VAULT, vaultData);
    }

    if (data.containsKey('settings') && data['settings'] != null) {
      final Map<String, dynamic> settings =
          Map<String, dynamic>.from(data['settings'] as Map);
      await PrefsHelper.saveData(PREF_SETTINGS, settings);
    }

    if (data.containsKey('saving_goal') && data['saving_goal'] != null) {
      final Map<String, dynamic> savingGoal =
          Map<String, dynamic>.from(data['saving_goal'] as Map);
      await PrefsHelper.saveData(PREF_GOAL, savingGoal);
    }

    if (data.containsKey('expense_goals') && data['expense_goals'] != null) {
      final List<dynamic> rawList = data['expense_goals'] as List<dynamic>;
      final List<Map<String, dynamic>> expenseGoals =
          rawList.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      await PrefsHelper.saveList(PREF_EXPENSE_GOALS, expenseGoals);
    }
  }

  // Upload backup to Google Drive
  Future<String> uploadBackup() async {
    // Ensure user is authenticated
    await _ensureAuthenticated();

    try {
      print('GoogleSignIn: Getting authenticated client for upload...');
      // Get authenticated client
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to get authenticated client');
      }

      final driveApi = ga.DriveApi(authClient);

      // Get all app data
      final appData = await _getAllAppData();
      final jsonString = jsonEncode(appData);
      final bytes = utf8.encode(jsonString);

      // Check if backup file already exists
      final existingFile = await _findBackupFile(driveApi);

      ga.File fileMetadata = ga.File()
        ..name = _backupFileName
        ..mimeType = 'application/json';

      if (existingFile != null) {
        // Update existing file
        fileMetadata.parents = null; // Don't change parent folder
        final response = await driveApi.files.update(
          fileMetadata,
          existingFile.id!,
          uploadMedia: ga.Media(Stream.value(bytes), bytes.length),
        );
        return 'Backup updated successfully (${response.name})';
      } else {
        // Create new file in appDataFolder
        fileMetadata.parents = ['appDataFolder'];
        final response = await driveApi.files.create(
          fileMetadata,
          uploadMedia: ga.Media(Stream.value(bytes), bytes.length),
        );
        return 'Backup created successfully (${response.name})';
      }
    } catch (e) {
      print('Upload error: $e');
      throw Exception('Failed to upload backup: $e');
    }
  }

  // Find existing backup file
  Future<ga.File?> _findBackupFile(ga.DriveApi driveApi) async {
    try {
      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name = '$_backupFileName'",
        $fields: 'files(id, name, modifiedTime)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first;
      }
      return null;
    } catch (e) {
      print('Error finding backup file: $e');
      return null;
    }
  }

  // Download backup from Google Drive
  Future<String> downloadBackup() async {
    // Ensure user is authenticated
    await _ensureAuthenticated();

    try {
      print('GoogleSignIn: Getting authenticated client for download...');
      // Get authenticated client
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to get authenticated client');
      }

      final driveApi = ga.DriveApi(authClient);

      // Find the backup file
      final backupFile = await _findBackupFile(driveApi);

      if (backupFile == null) {
        throw Exception('No backup found on Google Drive');
      }

      // Download the file
      final ga.Media media = await driveApi.files.get(
        backupFile.id!,
        downloadOptions: ga.DownloadOptions.fullMedia,
      ) as ga.Media;

      // Collect the data
      final List<int> dataStore = [];
      await for (var data in media.stream) {
        dataStore.addAll(data);
      }

      // Parse JSON
      final jsonString = utf8.decode(dataStore);
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      // Restore the data
      await _restoreAllAppData(backupData);

      final backupDate = backupData['backup_date'] ?? 'Unknown';
      return 'Backup restored successfully\nBackup date: $backupDate';
    } catch (e) {
      print('Download error: $e');
      throw Exception('Failed to download backup: $e');
    }
  }

  // Get backup info without downloading
  Future<Map<String, dynamic>?> getBackupInfo() async {
    if (_currentUser == null) {
      return null;
    }

    try {
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        return null;
      }

      final driveApi = ga.DriveApi(authClient);

      final backupFile = await _findBackupFile(driveApi);

      if (backupFile == null) {
        return null;
      }

      return {
        'name': backupFile.name,
        'modifiedTime': backupFile.modifiedTime?.toIso8601String(),
        'id': backupFile.id,
      };
    } catch (e) {
      print('Error getting backup info: $e');
      return null;
    }
  }

  // Delete backup from Google Drive
  Future<void> deleteBackup() async {
    // Ensure user is authenticated
    await _ensureAuthenticated();

    try {
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to get authenticated client');
      }

      final driveApi = ga.DriveApi(authClient);

      final backupFile = await _findBackupFile(driveApi);

      if (backupFile != null) {
        await driveApi.files.delete(backupFile.id!);
      }
    } catch (e) {
      print('Delete error: $e');
      throw Exception('Failed to delete backup: $e');
    }
  }
}

