import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyNotifier extends StateNotifier<String> {
  String _keyData;

  KeyNotifier(this._keyData) : super(_keyData);

  getKey() => _keyData;

  setKey(String keyData) async {
    state = keyData;
  }

  void onKeyChanged(String value, KeyNotifier keyNotifier) async {
    keyNotifier.setKey(value);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('address', value);
  }
}
