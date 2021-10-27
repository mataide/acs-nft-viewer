
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLoginState {
  final String rest;

  const SettingsLoginState({this.rest = ""});
}

class SettingsLoginController extends StateNotifier<SettingsLoginState> {
  SettingsLoginController([SettingsLoginState? state]) : super(SettingsLoginState()) {
    sharedRead();
  }

  String get rest => state.rest;


  Future sharedWrite(val) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('key', val);
    state = SettingsLoginState(rest: val);
  }


  Future sharedRead() async {
    final preferences = await SharedPreferences.getInstance();
    final rest = preferences.getString('key');
    state = SettingsLoginState(rest: rest != null ? rest : "");
  }

  Future sharedRemove() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('key');
    state = SettingsLoginState(rest: "");
  }

}
