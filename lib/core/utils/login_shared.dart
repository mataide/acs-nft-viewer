
import 'package:NFT_View/core/utils/constants_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyNotifier extends StateNotifier<String> {
  String _KeyData;

  KeyNotifier(this._KeyData) : super(_KeyData);

  getKey() => _KeyData;

  setKey(String keyData) async {
    state = keyData;
  }

  void onKeyChanged(String value, KeyNotifier keyNotifier) async {
    keyNotifier.setKey(rest);
  }
}
