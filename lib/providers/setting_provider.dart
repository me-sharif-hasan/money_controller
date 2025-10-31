import 'package:flutter/foundation.dart';
import '../core/constants/keys.dart';
import '../core/utils/prefs_helper.dart';

class SettingProvider with ChangeNotifier {
  bool _hardSavingMode = false;
  String _currencySymbol = '৳';
  int _monthStartDay = 1;
  int _monthEndDay = 31;
  bool _isLoading = false;

  bool get hardSavingMode => _hardSavingMode;
  String get currencySymbol => _currencySymbol;
  int get monthStartDay => _monthStartDay;
  int get monthEndDay => _monthEndDay;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _loadSettings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final data = await PrefsHelper.getData(PREF_SETTINGS);
    if (data != null) {
      _hardSavingMode = data['hardSavingMode'] as bool? ?? false;
      _currencySymbol = data['currencySymbol'] as String? ?? '৳';
      _monthStartDay = data['monthStartDay'] as int? ?? 1;
      _monthEndDay = data['monthEndDay'] as int? ?? 31;
    }
  }

  Future<void> setHardSavingMode(bool value) async {
    _hardSavingMode = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setCurrencySymbol(String symbol) async {
    _currencySymbol = symbol;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setMonthStartDay(int day) async {
    _monthStartDay = day;
    await _saveSettings();
    notifyListeners();
  }
  Future<void> setMonthEndDay(int day) async {
    _monthEndDay = day;
    await _saveSettings();
    notifyListeners();
  }


  Future<void> _saveSettings() async {
    await PrefsHelper.saveData(PREF_SETTINGS, {
      'hardSavingMode': _hardSavingMode,
      'currencySymbol': _currencySymbol,
      'monthEndDay': _monthEndDay,
      'monthStartDay': _monthStartDay,
    });
  }
}

