import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/database_helper.dart';

class AppState extends ChangeNotifier {
  bool isDeviceConnected = false;
  DateTime? _patchReplacementDate;
  String _pin = '0000';
  Map<String, dynamic>? _nextSomministrazione;

  final DatabaseHelper dbHelper = DatabaseHelper();

  String get pin => _pin;
  Map<String, dynamic>? get nextSomministrazione => _nextSomministrazione;

  AppState() {
    loadPin();
    loadPatchReplacementDate();
    loadNextSomministrazione();
  }

  void toggleConnection() {
    isDeviceConnected = !isDeviceConnected;
    notifyListeners();
  }

  Future<void> setPin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("staff_pin", newPin);
    _pin = newPin;
    notifyListeners();
  }

  Future<void> loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    _pin = prefs.getString("staff_pin") ?? '0000';
    notifyListeners();
  }

  Future<void> setPatchReplacementDate(DateTime newDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("patch_replacement_date", newDate.toIso8601String());
    _patchReplacementDate = newDate;
    notifyListeners();
  }

  Future<void> loadPatchReplacementDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString("patch_replacement_date");
    if (savedDate != null) {
      _patchReplacementDate = DateTime.parse(savedDate);
    }
    notifyListeners();
  }

  String? getExpirationDate() {
    if (_patchReplacementDate == null) {
      return "Patch non applicata";
    } else {
      DateTime next = _patchReplacementDate!.add(Duration(days: 2));
      return "Prossima sostituzione: ${DateFormat('dd/MM/yyyy').format(next)}";
    }
  }

  Future<void> loadNextSomministrazione() async {
    _nextSomministrazione = await dbHelper.getNextSomministrazione();
    notifyListeners();
  }

  String getNextSomministrazioneText() {
    if (_nextSomministrazione == null) return "Nessuna somministrazione programmata";
    return "Prossima somministrazione: ${_nextSomministrazione!['time']} - ${_nextSomministrazione!['meal']} (${_nextSomministrazione!['dosage']} UI)";
  }
}
